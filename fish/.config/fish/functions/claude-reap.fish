function claude-reap --description "Kill orphaned MCP server node processes left behind by dead Claude Code sessions"
    # Background: Claude Code on macOS has a known bug (issue #33947) where MCP
    # server child processes orphan to PPID=1 (launchd) when a session ends
    # abnormally. These accumulate silently and can reach hundreds of node
    # processes consuming GBs of RAM over days of use.
    #
    # This function finds and terminates those orphans safely (SIGTERM first,
    # never SIGKILL without confirmation). Only targets node processes with
    # PPID=1 — live MCP servers have PPID = their parent claude PID and are
    # untouched.

    set -l orphans (ps -eo pid,ppid,comm | awk '$2==1 && $3~/node/{print $1}')
    set -l count (count $orphans)

    if test $count -eq 0
        echo "No orphaned node processes found."
        return 0
    end

    # Show details before killing
    echo "Orphaned node processes (PPID=1):"
    for pid in $orphans
        set -l rss (ps -o rss= -p $pid 2>/dev/null | string trim)
        set -l etime (ps -o etime= -p $pid 2>/dev/null | string trim)
        if test -n "$rss"
            set -l mb (math $rss / 1024)
            echo "  PID $pid  age=$etime  RSS=$mb MB"
        end
    end

    # Summary stats
    set -l total_rss (ps -eo ppid,rss,comm | awk '$1==1 && $3~/node/ {sum+=$2} END {printf "%.1f", sum/1024}')
    echo ""
    echo "Total: $count orphans, ~$total_rss MB"
    echo ""

    # Kill with SIGTERM (graceful). macOS doesn't prompt — if you want a
    # confirmation step, call `ps -eo pid,ppid,comm | awk '\$2==1 && \$3~/node/'`
    # yourself first and verify before running this function.
    echo "Terminating orphans with SIGTERM..."
    kill $orphans 2>/dev/null

    # Brief wait, then SIGKILL any survivors
    sleep 1
    set -l stubborn (ps -eo pid,ppid,comm | awk '$2==1 && $3~/node/{print $1}')
    if test (count $stubborn) -gt 0
        echo "Force-killing "(count $stubborn)" stubborn process(es) with SIGKILL..."
        kill -9 $stubborn 2>/dev/null
    end

    echo "Done."
end
