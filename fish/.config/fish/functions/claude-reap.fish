function claude-reap --description "Kill orphaned MCP server node processes left behind by dead Claude Code sessions"
    # Background: Claude Code on macOS has a known bug (issue #33947) where MCP
    # server child processes orphan to PPID=1 (launchd) when a session ends
    # abnormally. These accumulate silently and can reach hundreds of node
    # processes consuming GBs of RAM over days of use.
    #
    # Safety: we do NOT reap every PPID=1 node process blindly — that would
    # catch legitimate daemons (e.g., `nohup node server.js &`). Instead we
    # require the full command line to look like an MCP server, matching any of:
    #   - "mcp"                   — mcp-server-*, @anthropic/mcp-*, etc.
    #   - "modelcontextprotocol"  — @modelcontextprotocol/server-* packages
    #   - ".claude/"              — Claude Code installs servers under this
    #   - "claude-mcp"            — some user configs
    # With --force, the filter is loosened to all PPID=1 node processes
    # (useful if you know none of your node daemons should be spared).

    argparse 'f/force' 'd/dry-run' 'h/help' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: claude-reap [--dry-run] [--force]"
        echo ""
        echo "  --dry-run  List orphans that would be killed, but don't kill them"
        echo "  --force    Kill ALL PPID=1 node processes (not just MCP-looking ones)"
        return 0
    end

    # Pattern for MCP-related orphans. Full command line is checked (not just
    # comm), so we match on args like '/path/to/node .../some-mcp-server.js'.
    set -l pattern 'mcp|modelcontextprotocol|\.claude/|claude-mcp'
    if set -q _flag_force
        set pattern '.'  # match anything
    end

    # ps -eo with 'command' gives full argv. Filter by node-in-comm AND
    # MCP-ish pattern in the full command line.
    set -l orphans (ps -eo pid,ppid,comm,command | awk -v pat="$pattern" '
        $2==1 && $3~/node/ && $0~pat { print $1 }
    ')
    set -l count (count $orphans)

    if test $count -eq 0
        echo "No orphaned MCP processes found."
        return 0
    end

    # Show full command for each orphan so the user can verify before killing
    echo "Orphaned node processes (PPID=1) matching MCP pattern:"
    for pid in $orphans
        set -l rss (ps -o rss= -p $pid 2>/dev/null | string trim)
        set -l etime (ps -o etime= -p $pid 2>/dev/null | string trim)
        set -l cmd (ps -o command= -p $pid 2>/dev/null | string trim | string sub -l 100)
        if test -n "$rss"
            set -l mb (math $rss / 1024)
            echo "  PID $pid  age=$etime  RSS=$mb MB"
            echo "    cmd: $cmd"
        end
    end

    # Summary
    set -l total_rss (ps -o ppid,rss,pid -p $orphans 2>/dev/null | awk 'NR>1 {sum+=$2} END {printf "%.1f", sum/1024}')
    echo ""
    echo "Total: $count orphans, ~$total_rss MB"

    if set -q _flag_dry_run
        echo ""
        echo "(dry-run: not killing anything)"
        return 0
    end

    echo ""
    echo "Terminating orphans with SIGTERM..."
    kill $orphans 2>/dev/null

    # Brief wait, then SIGKILL any survivors (re-check with same filter)
    sleep 1
    set -l stubborn (ps -eo pid,ppid,comm,command | awk -v pat="$pattern" '
        $2==1 && $3~/node/ && $0~pat { print $1 }
    ')
    if test (count $stubborn) -gt 0
        echo "Force-killing "(count $stubborn)" stubborn process(es) with SIGKILL..."
        kill -9 $stubborn 2>/dev/null
    end

    echo "Done."
end
