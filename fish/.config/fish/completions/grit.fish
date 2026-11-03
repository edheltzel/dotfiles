# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_grit_global_optspecs
    string join \n v/version json markdown filter= threads= C= c= git-dir= work-tree= no-optional-locks h/help
end

function __fish_grit_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_grit_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_grit_using_subcommand
    set -l cmd (__fish_grit_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c grit -n "__fish_grit_needs_command" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_needs_command" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_needs_command" -s C -d 'Run as if grit was started in DIR (repeatable; each one is relative to the previous)' -r -F
complete -c grit -n "__fish_grit_needs_command" -s c -d 'Set a config value for this invocation only (repeatable; a bare KEY means true)' -r
complete -c grit -n "__fish_grit_needs_command" -l git-dir -d 'Use this repository directory instead of discovering one (same as `GIT_DIR`)' -r -F
complete -c grit -n "__fish_grit_needs_command" -l work-tree -d 'Use this directory as the work tree root (same as `GIT_WORK_TREE`)' -r -F
complete -c grit -n "__fish_grit_needs_command" -s v -l version -d 'Print version'
complete -c grit -n "__fish_grit_needs_command" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_needs_command" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_needs_command" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_needs_command" -f -a "init" -d 'Create a new, empty repository'
complete -c grit -n "__fish_grit_needs_command" -f -a "checkout" -d 'Start work on a repository from a snapshot of its main branch (or some of its paths) instead of a clone'
complete -c grit -n "__fish_grit_needs_command" -f -a "checkin" -d 'Send a snapshot checkout\'s branches back to the server, grafted onto its real history'
complete -c grit -n "__fish_grit_needs_command" -f -a "integrate" -d 'Merge a branch into the server\'s target branch (checking it in first), then refresh this checkout'
complete -c grit -n "__fish_grit_needs_command" -f -a "slice" -d 'Named sets of paths to check out together, kept on the server\'s target branch'
complete -c grit -n "__fish_grit_needs_command" -f -a "clone" -d 'Copy a remote repository into a new directory'
complete -c grit -n "__fish_grit_needs_command" -f -a "remote" -d 'List remotes, or add one'
complete -c grit -n "__fish_grit_needs_command" -f -a "log" -d 'Show recent commits reachable from HEAD'
complete -c grit -n "__fish_grit_needs_command" -f -a "revs" -d 'List or count commits matching revision ranges'
complete -c grit -n "__fish_grit_needs_command" -f -a "merge-base" -d 'Find merge bases or test whether one commit is an ancestor of another'
complete -c grit -n "__fish_grit_needs_command" -f -a "reflog" -d 'Show, delete, or expire reflog entries'
complete -c grit -n "__fish_grit_needs_command" -f -a "blame" -d 'Show who last modified each line of a file'
complete -c grit -n "__fish_grit_needs_command" -f -a "diff" -d 'Show changes as a diff. No argument: uncommitted changes; with a commit: the change that commit introduced; with two commits (or `A..B`) diff their trees'
complete -c grit -n "__fish_grit_needs_command" -f -a "show" -d 'Show information about a commit, tag, or branch (defaults to HEAD)'
complete -c grit -n "__fish_grit_needs_command" -f -a "status" -d 'Show what\'s changed and where you are (this is the default)'
complete -c grit -n "__fish_grit_needs_command" -f -a "shortlog" -d 'List the commits on this branch that aren\'t on the target branch yet'
complete -c grit -n "__fish_grit_needs_command" -f -a "ahead" -d 'List the commits on this branch that aren\'t on the target branch yet'
complete -c grit -n "__fish_grit_needs_command" -f -a "add" -d 'Stage changes. With no paths, stages everything'
complete -c grit -n "__fish_grit_needs_command" -f -a "rm" -d 'Remove tracked paths from the working tree and index'
complete -c grit -n "__fish_grit_needs_command" -f -a "mv" -d 'Rename or move tracked paths'
complete -c grit -n "__fish_grit_needs_command" -f -a "clean" -d 'Remove untracked files from the working tree'
complete -c grit -n "__fish_grit_needs_command" -f -a "repack" -d 'Pack reachable objects and remove redundant packs'
complete -c grit -n "__fish_grit_needs_command" -f -a "gc" -d 'Pack refs, expire reflogs, repack, prune, and refresh commit-graph'
complete -c grit -n "__fish_grit_needs_command" -f -a "fsck" -d 'Check refs, objects, and pack indexes for problems'
complete -c grit -n "__fish_grit_needs_command" -f -a "ignore" -d 'Query exclude (gitignore) rules'
complete -c grit -n "__fish_grit_needs_command" -f -a "hooks" -d 'List hook scripts or run one by name'
complete -c grit -n "__fish_grit_needs_command" -f -a "patch-id" -d 'Print stable patch-IDs for commits or revision ranges'
complete -c grit -n "__fish_grit_needs_command" -f -a "resolve" -d 'Resolve revision specs to object ids and types'
complete -c grit -n "__fish_grit_needs_command" -f -a "cat" -d 'Show blob, tree, commit, or tag contents for a revision spec'
complete -c grit -n "__fish_grit_needs_command" -f -a "commit" -d 'Stage every change and record a new commit'
complete -c grit -n "__fish_grit_needs_command" -f -a "branch" -d 'List branches, or create / delete / rename / configure one'
complete -c grit -n "__fish_grit_needs_command" -f -a "switch" -d 'Switch to another branch, remote branch, or detached commit'
complete -c grit -n "__fish_grit_needs_command" -f -a "reset" -d 'Move the branch tip and optionally reset the index or worktree'
complete -c grit -n "__fish_grit_needs_command" -f -a "merge" -d 'Merge another branch, tag or commit into the current branch'
complete -c grit -n "__fish_grit_needs_command" -f -a "pick" -d 'Cherry-pick commits onto the current branch'
complete -c grit -n "__fish_grit_needs_command" -f -a "revert" -d 'Undo commits with new inverse commits'
complete -c grit -n "__fish_grit_needs_command" -f -a "history" -d 'Rewrite commits without a sequencer (plan, then apply refs atomically)'
complete -c grit -n "__fish_grit_needs_command" -f -a "stash" -d 'Save or restore shelved work'
complete -c grit -n "__fish_grit_needs_command" -f -a "restore" -d 'Restore working tree and/or index paths'
complete -c grit -n "__fish_grit_needs_command" -f -a "fetch" -d 'Download refs and objects from a remote'
complete -c grit -n "__fish_grit_needs_command" -f -a "pull" -d 'Fetch from the remote and integrate it into the current branch'
complete -c grit -n "__fish_grit_needs_command" -f -a "rebase" -d 'Replay local commits onto a new base (atomic ref update)'
complete -c grit -n "__fish_grit_needs_command" -f -a "push" -d 'Publish refs to a remote'
complete -c grit -n "__fish_grit_needs_command" -f -a "bundle" -d 'Create, verify, or list git bundle files'
complete -c grit -n "__fish_grit_needs_command" -f -a "notes" -d 'List, show, add, or remove Git notes on commits'
complete -c grit -n "__fish_grit_needs_command" -f -a "tag" -d 'List tags, or create / delete one'
complete -c grit -n "__fish_grit_needs_command" -f -a "worktree" -d 'List, add, or remove linked worktrees'
complete -c grit -n "__fish_grit_needs_command" -f -a "auth" -d 'Sign in to grithub (GitHub inside a github.com repository), a `grit serve` host, or store a username and token for any HTTPS host'
complete -c grit -n "__fish_grit_needs_command" -f -a "login" -d 'Sign in to grithub (GitHub inside a github.com repository), a `grit serve` host, or store a username and token for any HTTPS host'
complete -c grit -n "__fish_grit_needs_command" -f -a "update" -d 'Update grit to the latest release (re-runs the install script)'
complete -c grit -n "__fish_grit_needs_command" -f -a "skill" -d 'Print an agent skill (SKILL.md) that explains how to use grit'
complete -c grit -n "__fish_grit_needs_command" -f -a "completions" -d 'Generate shell completion scripts for bash, zsh, or fish'
complete -c grit -n "__fish_grit_needs_command" -f -a "config" -d 'Read, set, or list configuration values'
complete -c grit -n "__fish_grit_needs_command" -f -a "manager" -d 'Git credential helper backed by the Windows Credential Manager'
complete -c grit -n "__fish_grit_needs_command" -f -a "serve" -d 'Serve repositories over HTTP, with a web view where people sign in with email and password'
complete -c grit -n "__fish_grit_needs_command" -f -a "upload-pack" -d 'Serve a fetch or clone over stdin/stdout (run by ssh and grit-http-server)'
complete -c grit -n "__fish_grit_needs_command" -f -a "receive-pack" -d 'Accept a push over stdin/stdout (run by ssh and grit-http-server)'
complete -c grit -n "__fish_grit_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand init" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand init" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand init" -l ref-format -d 'Ref storage backend for the new repository' -r
complete -c grit -n "__fish_grit_using_subcommand init" -s b -l initial-branch -d 'Initial branch name (overrides `init.defaultBranch` from config)' -r
complete -c grit -n "__fish_grit_using_subcommand init" -l separate-git-dir -d 'Place the git directory here and link from the work tree via a gitfile' -r -F
complete -c grit -n "__fish_grit_using_subcommand init" -l object-format -d 'Object hash algorithm for the new repository (default SHA-1; omitted on reinit preserves format)' -r
complete -c grit -n "__fish_grit_using_subcommand init" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand init" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand init" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand init" -l bare -d 'Create a bare repository (no working tree)'
complete -c grit -n "__fish_grit_using_subcommand init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand checkout" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand checkout" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand checkout" -s p -l path -d 'Check out only this path, plus the files in the directories above it (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand checkout" -l into -d 'Directory to check out into (defaults to the repository name)' -r -F
complete -c grit -n "__fish_grit_using_subcommand checkout" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand checkout" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand checkout" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand checkout" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand checkin" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand checkin" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand checkin" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand checkin" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand checkin" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand checkin" -s f -l force -d 'Replace a server branch even where that drops commits it has'
complete -c grit -n "__fish_grit_using_subcommand checkin" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand integrate" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand integrate" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand integrate" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand integrate" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand integrate" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand integrate" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l url -d 'The repository whose slices to use (default: the checkout you are in)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -f -a "list" -d 'List the slices'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -f -a "new" -d 'Make a slice'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -f -a "edit" -d 'Add paths to a slice or remove them'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -f -a "delete" -d 'Delete a slice'
complete -c grit -n "__fish_grit_using_subcommand slice; and not __fish_seen_subcommand_from list new edit delete help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l url -d 'The repository whose slices to use (default: the checkout you are in)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -s p -l path -d 'A path in the slice (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -s d -l description -d 'What the slice is for' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l url -d 'The repository whose slices to use (default: the checkout you are in)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from new" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l add -d 'A path to add (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l remove -d 'A path to remove (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -s d -l description -d 'A new description' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l url -d 'The repository whose slices to use (default: the checkout you are in)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from edit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l url -d 'The repository whose slices to use (default: the checkout you are in)' -r
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from help" -f -a "list" -d 'List the slices'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from help" -f -a "new" -d 'Make a slice'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from help" -f -a "edit" -d 'Add paths to a slice or remove them'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Delete a slice'
complete -c grit -n "__fish_grit_using_subcommand slice; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -l depth -d 'Truncate fetched history to this many commits (`git clone --depth`)' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -s b -l branch -d 'Branch or tag to check out instead of the remote default' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -s o -l origin -d 'Name for the remote (default `origin`)' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -l blobs -d 'Partial clone: omit blobs (`none`), blobs at/above a size (`1k`, `512`, …), or what the server\'s accepted promisor remotes hold (`auto`)' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -l config -d 'Set a config value in the new repository before fetching (`git clone -c`; repeatable). Unlike the global `-c`, it is kept in the clone\'s config' -r
complete -c grit -n "__fish_grit_using_subcommand clone" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand clone" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand clone" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l shallow -d 'Shallow clone of the fetched ref (`git clone --depth=1`; hidden alias)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l single-branch -d 'Fetch only the branch checked out (same as `git clone --single-branch`)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l no-single-branch -d 'Fetch all branch tips even when `--shallow` is set (`git clone --no-single-branch`)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l no-tags -d 'Do not fetch any tags from the remote'
complete -c grit -n "__fish_grit_using_subcommand clone" -l bare -d 'Create a bare repository (`git clone --bare`)'
complete -c grit -n "__fish_grit_using_subcommand clone" -l no-checkout -d 'Do not check out the default branch (`git clone --no-checkout`)'
complete -c grit -n "__fish_grit_using_subcommand clone" -s q -l quiet -d 'Suppress progress and human output'
complete -c grit -n "__fish_grit_using_subcommand clone" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -s v -l verbose -d 'Show fetch and push URLs (like `git remote -v`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "add" -d 'Add a new remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "set-url" -d 'Set the fetch or push URL for an existing remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "remove" -d 'Remove a remote and its remote-tracking refs'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "prune" -d 'Delete stale remote-tracking refs without fetching'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "set-head" -d 'Set or delete `refs/remotes/<name>/HEAD`'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "show" -d 'Summarize a remote (URLs, branches, pull config)'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "rename" -d 'Rename an existing remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "refs" -d 'List references on a remote (like `git ls-remote`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and not __fish_seen_subcommand_from add set-url remove prune set-head show rename refs help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l fetch -d 'Fetch from the remote after adding it'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l push -d 'Update `pushurl` instead of `url`'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l dry-run -d 'Show what would change without writing config'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-url" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l dry-run -d 'Report changes without writing config or refs'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l dry-run -d 'Report refs that would be pruned without deleting them'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from prune" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l auto -d 'Query the remote and set HEAD from its default branch'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l delete -d 'Delete the local HEAD symref'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l dry-run -d 'Show what would change without updating refs'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from set-head" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -s n -l limit -d 'Return at most this many remote branches' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l no-query -d 'Use local remote-tracking refs only; do not contact the remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l dry-run -d 'Show what would change without writing the repository'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l sort -d 'Sort refs by `name` or `version` (`git ls-remote --sort=version:refname`)' -r -f -a "name\t'Full ref name order'
version\t'Numeric `version:refname` order'"
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -s n -l limit -d 'Return at most this many refs after sorting' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l heads -d 'Only show refs under `refs/heads/`'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l tags -d 'Only show refs under `refs/tags/`'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l reverse -d 'Reverse sort order (`git ls-remote --sort=-…`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from refs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add a new remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "set-url" -d 'Set the fetch or push URL for an existing remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove a remote and its remote-tracking refs'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "prune" -d 'Delete stale remote-tracking refs without fetching'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "set-head" -d 'Set or delete `refs/remotes/<name>/HEAD`'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "show" -d 'Summarize a remote (URLs, branches, pull config)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Rename an existing remote'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "refs" -d 'List references on a remote (like `git ls-remote`)'
complete -c grit -n "__fish_grit_using_subcommand remote; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand log" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l skip -d 'Skip this many commits after ordering' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l since -d 'Exclude commits older than this date (Git `--since`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l after -d 'Alias for `--since`' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l until -d 'Exclude commits newer than this date (Git `--until`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l before -d 'Alias for `--until` (date cutoff)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l branches -d 'Include branch tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l tags -d 'Include tag tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l remotes -d 'Include remote-tracking tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l author -d 'Limit to commits whose author matches this pattern (repeatable; OR together)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l committer -d 'Limit to commits whose committer matches this pattern (repeatable; OR together)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l grep -d 'Limit to commits whose message matches this pattern (repeatable; OR unless `--all-match`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -s S -d 'Keep commits where occurrence count of this string changed (`git log -S`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -s G -d 'Keep commits whose added/removed lines match this pattern (`git log -G`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l cursor -d 'Continue a paged walk from the `TOKEN` a previous page printed (an empty value is ignored)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -s U -l unified -d 'Lines of context around each change (Git `-U`)' -r
complete -c grit -n "__fish_grit_using_subcommand log" -l group-by -d 'Aggregate commits (`author` matches `git shortlog -sne` ordering)' -r -f -a "author\t''"
complete -c grit -n "__fish_grit_using_subcommand log" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand log" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand log" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l first-parent -d 'Follow only the first parent at merges'
complete -c grit -n "__fish_grit_using_subcommand log" -l merges -d 'Include only merge commits'
complete -c grit -n "__fish_grit_using_subcommand log" -l no-merges -d 'Exclude merge commits'
complete -c grit -n "__fish_grit_using_subcommand log" -l reverse -d 'Reverse commit order (oldest first)'
complete -c grit -n "__fish_grit_using_subcommand log" -l all -d 'Include every ref tip'
complete -c grit -n "__fish_grit_using_subcommand log" -s i -l regexp-ignore-case -d 'Case-insensitive pattern matching for `--author`, `--committer`, and `--grep`'
complete -c grit -n "__fish_grit_using_subcommand log" -l all-match -d 'Require every `--grep` pattern to match'
complete -c grit -n "__fish_grit_using_subcommand log" -l invert-grep -d 'Invert `--grep` matching (commits that do not match the grep group)'
complete -c grit -n "__fish_grit_using_subcommand log" -s F -l fixed-strings -d 'Treat `--author`, `--committer`, and `--grep` patterns as fixed strings'
complete -c grit -n "__fish_grit_using_subcommand log" -l no-mailmap -d 'Do not apply `.mailmap` when matching `--author` or `--committer`'
complete -c grit -n "__fish_grit_using_subcommand log" -l pickaxe-regex -d 'Treat `-S` as a BRE instead of a literal string (`--pickaxe-regex`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand log" -s p -l patch -d 'Unified patch for each commit (`git log -p`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l stat -d 'Summary with change bars per file (like `git diff --stat`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l numstat -d 'Machine-readable `insertions<TAB>deletions<TAB>path` lines'
complete -c grit -n "__fish_grit_using_subcommand log" -l shortstat -d 'Only the summary line (`N files changed, …`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l name-only -d 'Paths only, one per line'
complete -c grit -n "__fish_grit_using_subcommand log" -l name-status -d 'Status letter and path(s) per line'
complete -c grit -n "__fish_grit_using_subcommand log" -l patch-text -d 'Git-apply-compatible unified patch (`git diff --binary` shape); not combinable with `--json`'
complete -c grit -n "__fish_grit_using_subcommand log" -s W -l function-context -d 'Expand hunks to enclosing function boundaries (Git `-W` / `--function-context`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l oneline -d 'One line per commit: short oid and subject (refs when `--decorate`)'
complete -c grit -n "__fish_grit_using_subcommand log" -l decorate -d 'Show branch and tag names that point at each commit'
complete -c grit -n "__fish_grit_using_subcommand log" -l count -d 'With `--group-by`, omit per-commit lists in `--json` output'
complete -c grit -n "__fish_grit_using_subcommand log" -l graph -d 'Draw a commit graph in human output (implies topological order; Unicode by default)'
complete -c grit -n "__fish_grit_using_subcommand log" -l no-pager -d 'Write straight to the terminal instead of through the pager'
complete -c grit -n "__fish_grit_using_subcommand log" -l graph-ascii -d 'Use ASCII `*|` lane characters in `--graph` output instead of Unicode box-drawing'
complete -c grit -n "__fish_grit_using_subcommand log" -l graph-unicode -d 'Draw `--graph` with Unicode box-drawing (default when `--graph` is set)'
complete -c grit -n "__fish_grit_using_subcommand log" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand revs" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l skip -d 'Skip this many commits after ordering' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l since -d 'Exclude commits older than this date (Git `--since`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l after -d 'Alias for `--since`' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l until -d 'Exclude commits newer than this date (Git `--until`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l before -d 'Alias for `--until` (date cutoff)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l branches -d 'Include branch tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l tags -d 'Include tag tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l remotes -d 'Include remote-tracking tips, or those matching an optional glob' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l author -d 'Limit to commits whose author matches this pattern (repeatable; OR together)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l committer -d 'Limit to commits whose committer matches this pattern (repeatable; OR together)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l grep -d 'Limit to commits whose message matches this pattern (repeatable; OR unless `--all-match`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -s S -d 'Keep commits where occurrence count of this string changed (`git log -S`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -s G -d 'Keep commits whose added/removed lines match this pattern (`git log -G`)' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand revs" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand revs" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand revs" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand revs" -l first-parent -d 'Follow only the first parent at merges'
complete -c grit -n "__fish_grit_using_subcommand revs" -l merges -d 'Include only merge commits'
complete -c grit -n "__fish_grit_using_subcommand revs" -l no-merges -d 'Exclude merge commits'
complete -c grit -n "__fish_grit_using_subcommand revs" -l reverse -d 'Reverse commit order (oldest first)'
complete -c grit -n "__fish_grit_using_subcommand revs" -l all -d 'Include every ref tip'
complete -c grit -n "__fish_grit_using_subcommand revs" -s i -l regexp-ignore-case -d 'Case-insensitive pattern matching for `--author`, `--committer`, and `--grep`'
complete -c grit -n "__fish_grit_using_subcommand revs" -l all-match -d 'Require every `--grep` pattern to match'
complete -c grit -n "__fish_grit_using_subcommand revs" -l invert-grep -d 'Invert `--grep` matching (commits that do not match the grep group)'
complete -c grit -n "__fish_grit_using_subcommand revs" -s F -l fixed-strings -d 'Treat `--author`, `--committer`, and `--grep` patterns as fixed strings'
complete -c grit -n "__fish_grit_using_subcommand revs" -l no-mailmap -d 'Do not apply `.mailmap` when matching `--author` or `--committer`'
complete -c grit -n "__fish_grit_using_subcommand revs" -l pickaxe-regex -d 'Treat `-S` as a BRE instead of a literal string (`--pickaxe-regex`)'
complete -c grit -n "__fish_grit_using_subcommand revs" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand revs" -l count -d 'Print only the number of reachable commits'
complete -c grit -n "__fish_grit_using_subcommand revs" -l left-right -d 'Mark each commit of a symmetric range (`A...B`) as left or right; with `--count`, print left/right counts instead'
complete -c grit -n "__fish_grit_using_subcommand revs" -l cherry-mark -d 'Pair the two sides of a symmetric range (`A...B`) by patch-id and mark equivalent commits (implies `--left-right`)'
complete -c grit -n "__fish_grit_using_subcommand revs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l all -d 'List every minimal merge base (criss-cross histories)'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -l is-ancestor -d 'Exit 0 when `a` is an ancestor of `b`, 1 otherwise; prints nothing in human mode'
complete -c grit -n "__fish_grit_using_subcommand merge-base" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -s n -l max-count -d 'Show at most this many entries (newest first)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l since -d 'Exclude entries older than this date (Git `--since`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l after -d 'Alias for `--since`' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l until -d 'Exclude entries newer than this date (Git `--until`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l before -d 'Alias for `--until`' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l grep -d 'Keep entries whose message contains this substring (case-sensitive)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -a "delete" -d 'Remove one or more reflog entries (`ref@{n}`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -a "expire" -d 'Drop reflog entries older than configured or explicit cutoffs'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -a "list" -d 'List refs that currently have a reflog'
complete -c grit -n "__fish_grit_using_subcommand reflog; and not __fish_seen_subcommand_from delete expire list help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l expire -d 'Expire reachable entries older than this (Git `--expire` syntax)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l expire-unreachable -d 'Expire unreachable entries older than this' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l all -d 'Process every ref under `refs/`, not only refs that already have log files'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l dry-run -d 'Report what would be pruned without rewriting reflog files'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from expire" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -s n -l limit -d 'Return at most this many ref names (sorted)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from help" -f -a "delete" -d 'Remove one or more reflog entries (`ref@{n}`)'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from help" -f -a "expire" -d 'Drop reflog entries older than configured or explicit cutoffs'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from help" -f -a "list" -d 'List refs that currently have a reflog'
complete -c grit -n "__fish_grit_using_subcommand reflog; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand blame" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l rev -d 'Blame the file as committed at this revision. Without a revision the working tree file is blamed, with uncommitted lines marked' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -s L -l lines -d 'Limit output with a Git-style line range (`-L` / `--lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l ignore-rev -d 'Ignore this revision when attributing lines (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l ignore-revs-file -d 'Read revision oids to ignore from a file (repeatable; `""` clears prior entries)' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l contents -d 'Blame this file\'s content (`-` for stdin) instead of the working tree, on top of the revision (default `HEAD`); lines not in the revision show as uncommitted' -r
complete -c grit -n "__fish_grit_using_subcommand blame" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand blame" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand blame" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand blame" -l first-parent -d 'At merge commits, follow only the first parent (Git\'s `--first-parent`)'
complete -c grit -n "__fish_grit_using_subcommand blame" -l group -d 'With `--json`, emit grouped `hunks[]` instead of per-line `lines[]`'
complete -c grit -n "__fish_grit_using_subcommand blame" -s w -l ignore-all-space -d 'Ignore whitespace when comparing lines (`git blame -w`)'
complete -c grit -n "__fish_grit_using_subcommand blame" -s C -l copy-detection -d 'Detect lines copied from other files (`git blame -C`; repeat up to three times)'
complete -c grit -n "__fish_grit_using_subcommand blame" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand diff" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l against -d 'Compare the worktree to this ref\'s tree instead of HEAD (no commit arguments)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -s U -l unified -d 'Lines of context around each change (Git `-U`)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -s M -l find-renames -d 'Detect renames; optional similarity threshold (`50` default, or `50%`). Use `-M`, `-M30`, or `--find-renames` / `--find-renames=30` (long form requires `=` when a threshold is given)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l diff-algorithm -d 'Line diff algorithm (overrides `diff.algorithm`)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l diff-filter -d 'Limit output to these change types (Git letter syntax: `ADMR…`)' -r
complete -c grit -n "__fish_grit_using_subcommand diff" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand diff" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand diff" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l no-index -d 'Compare two filesystem paths outside any repository (like `git diff --no-index`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -s S -l staged -l cached -d 'Staged changes only (index vs HEAD)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l unstaged -d 'Unstaged changes only (worktree vs index)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l exit-code -d 'Exit with 1 when there are changes (errors exit 2)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l quiet -d 'Print nothing; implies `--exit-code`'
complete -c grit -n "__fish_grit_using_subcommand diff" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand diff" -s p -l patch -d 'Unified patch for each commit (`git log -p`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l stat -d 'Summary with change bars per file (like `git diff --stat`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l numstat -d 'Machine-readable `insertions<TAB>deletions<TAB>path` lines'
complete -c grit -n "__fish_grit_using_subcommand diff" -l shortstat -d 'Only the summary line (`N files changed, …`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l name-only -d 'Paths only, one per line'
complete -c grit -n "__fish_grit_using_subcommand diff" -l name-status -d 'Status letter and path(s) per line'
complete -c grit -n "__fish_grit_using_subcommand diff" -l patch-text -d 'Git-apply-compatible unified patch (`git diff --binary` shape); not combinable with `--json`'
complete -c grit -n "__fish_grit_using_subcommand diff" -s W -l function-context -d 'Expand hunks to enclosing function boundaries (Git `-W` / `--function-context`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l no-renames -d 'Do not detect renames'
complete -c grit -n "__fish_grit_using_subcommand diff" -s w -l ignore-all-space -d 'Ignore whitespace when comparing lines (`git diff -w`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -s b -l ignore-space-change -d 'Ignore changes in the amount of whitespace (`git diff -b`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -l ignore-blank-lines -d 'Ignore changes whose lines are all blank (`git diff --ignore-blank-lines`)'
complete -c grit -n "__fish_grit_using_subcommand diff" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand show" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand show" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand show" -l diff-merges -d 'Merge commit diffs: `combined` (default) or `first-parent`' -r
complete -c grit -n "__fish_grit_using_subcommand show" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand show" -s U -l unified -d 'Lines of context around each change (Git `-U`)' -r
complete -c grit -n "__fish_grit_using_subcommand show" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand show" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand show" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand show" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand show" -s p -l patch -d 'Unified patch for each commit (`git log -p`)'
complete -c grit -n "__fish_grit_using_subcommand show" -l stat -d 'Summary with change bars per file (like `git diff --stat`)'
complete -c grit -n "__fish_grit_using_subcommand show" -l numstat -d 'Machine-readable `insertions<TAB>deletions<TAB>path` lines'
complete -c grit -n "__fish_grit_using_subcommand show" -l shortstat -d 'Only the summary line (`N files changed, …`)'
complete -c grit -n "__fish_grit_using_subcommand show" -l name-only -d 'Paths only, one per line'
complete -c grit -n "__fish_grit_using_subcommand show" -l name-status -d 'Status letter and path(s) per line'
complete -c grit -n "__fish_grit_using_subcommand show" -l patch-text -d 'Git-apply-compatible unified patch (`git diff --binary` shape); not combinable with `--json`'
complete -c grit -n "__fish_grit_using_subcommand show" -s W -l function-context -d 'Expand hunks to enclosing function boundaries (Git `-W` / `--function-context`)'
complete -c grit -n "__fish_grit_using_subcommand show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand status" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand status" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand status" -l untracked -d 'How untracked paths are listed: `normal` (default) collapses wholly untracked directories; `all` lists every file; `no` omits untracked paths. When omitted, uses `status.showUntrackedFiles` from config' -r
complete -c grit -n "__fish_grit_using_subcommand status" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand status" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand status" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand status" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand status" -l no-ahead-behind -d 'Skip ahead/behind rev-list walks (also when `status.aheadBehind=false`)'
complete -c grit -n "__fish_grit_using_subcommand status" -l ignored -d 'List ignored paths (traditional mode; same set as `git status --ignored`)'
complete -c grit -n "__fish_grit_using_subcommand status" -s s -l short -d 'One line per path: two-letter index/worktree code plus path (`??` / `!!` for untracked / ignored)'
complete -c grit -n "__fish_grit_using_subcommand status" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand status" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l target -d 'Compare against this ref or revision instead of the discovered target branch' -r
complete -c grit -n "__fish_grit_using_subcommand shortlog" -s n -l max-count -d 'Maximum commits to list on each side (`ahead`, and with `--behind` the behind list too)' -r
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l behind -d 'Also list commits on the target that are not on this branch yet'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l stat -d 'Summary with change bars per file (like `git log --stat`)'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -l name-only -d 'Paths only, one per line'
complete -c grit -n "__fish_grit_using_subcommand shortlog" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand ahead" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand ahead" -l target -d 'Compare against this ref or revision instead of the discovered target branch' -r
complete -c grit -n "__fish_grit_using_subcommand ahead" -s n -l max-count -d 'Maximum commits to list on each side (`ahead`, and with `--behind` the behind list too)' -r
complete -c grit -n "__fish_grit_using_subcommand ahead" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l behind -d 'Also list commits on the target that are not on this branch yet'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l stat -d 'Summary with change bars per file (like `git log --stat`)'
complete -c grit -n "__fish_grit_using_subcommand ahead" -l name-only -d 'Paths only, one per line'
complete -c grit -n "__fish_grit_using_subcommand ahead" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand add" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l patch-file -d 'Apply a unified diff to the index (`git apply --cached`). Use `-` for stdin' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l hunks -d 'Stage only the listed hunk ids from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l lines -d 'Stage only new-side line ranges from `grit diff --json` (`path:start-end`, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand add" -s U -l unified -d 'Unified context lines when resolving `--hunks` / `--lines` (match `grit diff -U`; default 3)' -r
complete -c grit -n "__fish_grit_using_subcommand add" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand add" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand add" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand add" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand add" -s u -l update -d 'Stage tracked changes only (modified and deleted paths; no untracked files)'
complete -c grit -n "__fish_grit_using_subcommand add" -l dry-run -d 'Report paths that would be staged without writing the index or object database'
complete -c grit -n "__fish_grit_using_subcommand add" -s N -l intent-to-add -d 'Record intent to add (empty index entries) instead of staging file content'
complete -c grit -n "__fish_grit_using_subcommand add" -s f -l force -d 'Stage paths that would otherwise be rejected as ignored'
complete -c grit -n "__fish_grit_using_subcommand add" -l executable -d 'Mark staged regular files as executable (`100755`) in the index'
complete -c grit -n "__fish_grit_using_subcommand add" -l non-executable -d 'Mark staged regular files as non-executable (`100644`) in the index'
complete -c grit -n "__fish_grit_using_subcommand add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand rm" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand rm" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand rm" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand rm" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand rm" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand rm" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand rm" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand rm" -l cached -d 'Remove from the index only; keep files in the working tree'
complete -c grit -n "__fish_grit_using_subcommand rm" -s f -l force -d 'Remove even when paths have local modifications'
complete -c grit -n "__fish_grit_using_subcommand rm" -l dry-run -d 'List paths that would be removed without changing the index or work tree'
complete -c grit -n "__fish_grit_using_subcommand rm" -l ignore-unmatch -d 'Treat non-matching pathspecs as success with an empty result'
complete -c grit -n "__fish_grit_using_subcommand rm" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand mv" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand mv" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand mv" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand mv" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand mv" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand mv" -s f -l force -d 'Replace existing files at the destination'
complete -c grit -n "__fish_grit_using_subcommand mv" -l dry-run -d 'List moves that would happen without changing the index or work tree'
complete -c grit -n "__fish_grit_using_subcommand mv" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand clean" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand clean" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand clean" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand clean" -s e -l exclude -d 'Additional exclude patterns; matching paths are not removed' -r
complete -c grit -n "__fish_grit_using_subcommand clean" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand clean" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand clean" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand clean" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand clean" -s f -l force -d 'Actually delete files. Without this flag, only prints what would be removed'
complete -c grit -n "__fish_grit_using_subcommand clean" -l dry-run -d 'Explicit dry run (default when `-f` is not passed)'
complete -c grit -n "__fish_grit_using_subcommand clean" -l ignored -d 'Remove ignored files as well (like `git clean -x`)'
complete -c grit -n "__fish_grit_using_subcommand clean" -l only-ignored -d 'Remove only ignored files (like `git clean -X`)'
complete -c grit -n "__fish_grit_using_subcommand clean" -l files-only -d 'Remove only files, not untracked directories'
complete -c grit -n "__fish_grit_using_subcommand clean" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand repack" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand repack" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand repack" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand repack" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand repack" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand repack" -s f -l force -d 'Recompute every delta instead of reusing the ones already in packs'
complete -c grit -n "__fish_grit_using_subcommand repack" -l dry-run -d 'Show what would be packed without writing'
complete -c grit -n "__fish_grit_using_subcommand repack" -s q -l quiet -d 'Suppress progress summary on stderr'
complete -c grit -n "__fish_grit_using_subcommand repack" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l dry-run -d 'Show what would run without writing'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -l auto -d 'Run only when `gc.auto` or `gc.autoPackLimit` is exceeded (what commands run on their own)'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -s q -l quiet -d 'Suppress progress summary on stderr'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "repack" -d 'Repack reachable objects into one pack'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "commit-graph" -d 'Write a reachable commit-graph with changed-path Bloom filters'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "midx" -d 'Write or refresh the multi-pack-index'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "pack-refs" -d 'Pack loose refs into `packed-refs` (or compact reftable)'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "prune" -d 'Delete unreachable loose objects'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "offload" -d 'Move large blobs to a large-object promisor remote and drop them here'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "drop-large-blobs" -d 'Drop large blobs a promisor remote can supply again and nothing needed recently'
complete -c grit -n "__fish_grit_using_subcommand gc; and not __fish_seen_subcommand_from repack commit-graph midx pack-refs prune offload drop-large-blobs help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l bitmaps -d 'Write a reachability `.bitmap` sidecar for the new pack'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -s f -l force -d 'Recompute every delta instead of reusing the ones already in packs'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l dry-run -d 'Report what would be packed without writing'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from repack" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l dry-run -d 'Report commit count without writing the graph file'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from commit-graph" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l dry-run -d 'Report pack coverage without writing the index'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from midx" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l dry-run -d 'Report refs that would be packed without writing'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from pack-refs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l older-than -d 'Only remove objects older than this date (Git approxidate syntax)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l dry-run -d 'Report objects that would be deleted without removing them'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from prune" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l to -d 'Promisor remote that receives the blobs (`remote.<name>.url`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l blobs -d 'Blobs to move: `none` for every blob, or a size such as `1m` (blobs at least that big). Defaults to `remote.<REMOTE>.partialCloneFilter`' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l lop-dir -d 'The promisor\'s git directory, when its URL is not a local path' -r -F
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l configure-lop -d 'Also set `uploadpack.allowFilter` and `uploadpack.allowAnySHA1InWant` in the promisor'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l dry-run -d 'Report what would move without changing anything'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from offload" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l min-size -d 'Drop blobs at least this big, such as `1m` (default: `maintenance.drop-large-blobs.minSize`, else the promisor\'s `blob:limit`, else 1m)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l older-than -d 'Keep blobs needed since this date (Git approxidate; `now` keeps none for recency). Default: `maintenance.drop-large-blobs.expire`, else `2.weeks.ago`' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l dry-run -d 'List the blobs that would be dropped without changing anything'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from drop-large-blobs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "repack" -d 'Repack reachable objects into one pack'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "commit-graph" -d 'Write a reachable commit-graph with changed-path Bloom filters'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "midx" -d 'Write or refresh the multi-pack-index'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "pack-refs" -d 'Pack loose refs into `packed-refs` (or compact reftable)'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "prune" -d 'Delete unreachable loose objects'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "offload" -d 'Move large blobs to a large-object promisor remote and drop them here'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "drop-large-blobs" -d 'Drop large blobs a promisor remote can supply again and nothing needed recently'
complete -c grit -n "__fish_grit_using_subcommand gc; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand fsck" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand fsck" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l connectivity-only -d 'Check connectivity from refs only (skip store-wide object validation)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l dangling -d 'Report unreachable objects (with `--connectivity-only`, off unless this flag is set)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l no-dangling -d 'Do not list dangling objects (matches Git `--no-dangling`)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -l strict -d 'Treat ref warnings as errors'
complete -c grit -n "__fish_grit_using_subcommand fsck" -s v -l verbose -d 'Include info-level object diagnostics in human output (matches Git `--verbose`)'
complete -c grit -n "__fish_grit_using_subcommand fsck" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -f -a "check" -d 'Print whether paths match exclude rules'
complete -c grit -n "__fish_grit_using_subcommand ignore; and not __fish_seen_subcommand_from check help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l all -d 'Also list paths that are not ignored'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from check" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from help" -f -a "check" -d 'Print whether paths match exclude rules'
complete -c grit -n "__fish_grit_using_subcommand ignore; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -f -a "list" -d 'List hook scripts in the resolved hooks directory'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -f -a "run" -d 'Run a hook by name (passes `--` arguments through to the script)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and not __fish_seen_subcommand_from list run help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from help" -f -a "list" -d 'List hook scripts in the resolved hooks directory'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from help" -f -a "run" -d 'Run a hook by name (passes `--` arguments through to the script)'
complete -c grit -n "__fish_grit_using_subcommand hooks; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand patch-id" -l unstable -d 'Use legacy unstable patch-ID algorithm (Git 1.9 and older)'
complete -c grit -n "__fish_grit_using_subcommand patch-id" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand resolve" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand resolve" -l verify -d 'Resolve exactly one spec strictly (`git rev-parse --verify`); pass the spec as the flag value' -r
complete -c grit -n "__fish_grit_using_subcommand resolve" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l short -d 'Print abbreviated object ids'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l abbrev-ref -d 'Print the shortest unambiguous ref name for each spec (like `git rev-parse --abbrev-ref`)'
complete -c grit -n "__fish_grit_using_subcommand resolve" -l symbolic-full-name -d 'Print the full symbolic ref name for each spec (like `git rev-parse --symbolic-full-name`)'
complete -c grit -n "__fish_grit_using_subcommand resolve" -s q -l quiet -d 'With `--verify`, answer yes/no via exit status only (no stdout/stderr)'
complete -c grit -n "__fish_grit_using_subcommand resolve" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand cat" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand cat" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand cat" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand cat" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand cat" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand cat" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand commit" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l author -d 'Author ident (`Name <email>` or bare email)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l date -d 'Override the author date (Git date formats, RFC 3339, `@epoch`, …)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l trailer -d 'Append a commit trailer (`key=value` or `key: value`); repeat for multiple trailers' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -s C -l reuse-message -d 'Reuse the log message and author from a commit (`-C` / `--reuse-message`)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l patch-file -d 'Apply a unified diff to the index, then commit only that staged content (`git apply --cached` + commit)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l hunks -d 'Commit only the listed hunk ids from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l lines -d 'Commit only line ranges from the unstaged diff (same format as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand commit" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand commit" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand commit" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand commit" -s q -l quiet -d 'Suppress progress and human output'
complete -c grit -n "__fish_grit_using_subcommand commit" -s s -l signoff -d 'Append a `Signed-off-by` trailer for the committer'
complete -c grit -n "__fish_grit_using_subcommand commit" -l reset-author -d 'Set the author to the committer with a fresh author date'
complete -c grit -n "__fish_grit_using_subcommand commit" -s S -l gpg-sign -d 'Sign the commit with the configured signing key'
complete -c grit -n "__fish_grit_using_subcommand commit" -l no-gpg-sign -d 'Do not sign this commit, even when `commit.gpgsign` is enabled'
complete -c grit -n "__fish_grit_using_subcommand commit" -l no-verify -d 'Skip the `pre-commit` and `commit-msg` hooks'
complete -c grit -n "__fish_grit_using_subcommand commit" -s a -l all -d 'Stage every change first, then commit. This is the default when `commit.autoStage` is true'
complete -c grit -n "__fish_grit_using_subcommand commit" -l staged -d 'Commit only what is already staged (same as `git commit` without `-a`)'
complete -c grit -n "__fish_grit_using_subcommand commit" -l amend -d 'Replace the tip commit instead of creating a new one'
complete -c grit -n "__fish_grit_using_subcommand commit" -l allow-empty -d 'Record a commit even when the tree matches the parent (same as `git commit --allow-empty`)'
complete -c grit -n "__fish_grit_using_subcommand commit" -l dry-run -d 'Compute the commit without writing objects, updating refs, or running hooks'
complete -c grit -n "__fish_grit_using_subcommand commit" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand commit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand branch" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -s u -l set-upstream-to -d 'Set upstream for the named branch (or the current branch when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -s m -l move -d 'Rename a branch: `-m <new>` or `-m <old> <new>`' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -s M -d 'Force rename: `-M <new>` or `-M <old> <new>`' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l list -d 'Include only branches whose short name matches `GLOB` (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l merged -d 'List branches merged into `REV` (defaults to `HEAD` when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l no-merged -d 'List branches not merged into `REV` (defaults to `HEAD` when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l contains -d 'List branches whose tip contains `REV` (defaults to `HEAD` when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l sort -d 'Sort key: `name`, `version`, or `date`' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand branch" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand branch" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand branch" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand branch" -s f -l force -d 'Overwrite an existing branch when creating or renaming'
complete -c grit -n "__fish_grit_using_subcommand branch" -s t -l track -d 'Configure upstream from the start point when creating'
complete -c grit -n "__fish_grit_using_subcommand branch" -l no-track -d 'Do not configure upstream when creating'
complete -c grit -n "__fish_grit_using_subcommand branch" -l unset-upstream -d 'Remove upstream configuration for the named branch (or the current branch)'
complete -c grit -n "__fish_grit_using_subcommand branch" -s d -l delete -d 'Delete the named branch instead of creating it'
complete -c grit -n "__fish_grit_using_subcommand branch" -s D -l force-delete -d 'Delete even when the branch is not fully merged into the current branch'
complete -c grit -n "__fish_grit_using_subcommand branch" -s r -l remotes -d 'List remote-tracking branches under `refs/remotes/`'
complete -c grit -n "__fish_grit_using_subcommand branch" -s a -l all -d 'List local and remote-tracking branches'
complete -c grit -n "__fish_grit_using_subcommand branch" -l reverse -d 'Reverse sort order'
complete -c grit -n "__fish_grit_using_subcommand branch" -l show-current -d 'Print the current branch name only (same as `git branch --show-current`)'
complete -c grit -n "__fish_grit_using_subcommand branch" -l dry-run -d 'Preview the operation without updating refs, config, or reflogs'
complete -c grit -n "__fish_grit_using_subcommand branch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand switch" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand switch" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand switch" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand switch" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand switch" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand switch" -s c -l create -d 'Create the branch first, then switch to it'
complete -c grit -n "__fish_grit_using_subcommand switch" -l detach -d 'Check out a commit in detached HEAD mode'
complete -c grit -n "__fish_grit_using_subcommand switch" -l dry-run -d 'Run overwrite checks without updating refs, the index, or the worktree'
complete -c grit -n "__fish_grit_using_subcommand switch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand reset" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand reset" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand reset" -s n -l limit -d 'Maximum orphaned commits to list in `--json` output' -r
complete -c grit -n "__fish_grit_using_subcommand reset" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reset" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand reset" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand reset" -l soft -d 'Keep the index and worktree; move the branch tip only'
complete -c grit -n "__fish_grit_using_subcommand reset" -l mixed -d 'Reset the index to the target commit; keep the worktree (default)'
complete -c grit -n "__fish_grit_using_subcommand reset" -l hard -d 'Reset the index and worktree to match the target commit'
complete -c grit -n "__fish_grit_using_subcommand reset" -l keep -d 'Reset the tip and update differing paths while keeping unrelated local edits'
complete -c grit -n "__fish_grit_using_subcommand reset" -l dry-run -d 'Preview the reset without updating refs, the index, or the worktree'
complete -c grit -n "__fish_grit_using_subcommand reset" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand merge" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand merge" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand merge" -s X -d 'Prefer ours or theirs on overlapping edits (`-X ours` / `-X theirs`)' -r -f -a "ours\t'Prefer the current branch when both sides changed the same region'
theirs\t'Prefer the branch being merged when both sides changed the same region'"
complete -c grit -n "__fish_grit_using_subcommand merge" -l conflict -d 'Conflict marker style (`merge`, `diff3`, or `zdiff3`)' -r -f -a "merge\t'Standard two-section conflict markers'
diff3\t'Three-section markers including the base section'
zdiff3\t'Zealous diff3 (`zdiff3`)'"
complete -c grit -n "__fish_grit_using_subcommand merge" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand merge" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand merge" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand merge" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand merge" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand merge" -l abort -d 'Cancel an in-progress merge and restore the pre-merge state'
complete -c grit -n "__fish_grit_using_subcommand merge" -l continue -d 'Finish an in-progress merge after resolving conflicts (or after `--no-commit`)'
complete -c grit -n "__fish_grit_using_subcommand merge" -l check -d 'Predict whether the merge would succeed without changing refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand merge" -l dry-run -d 'Report the planned merge outcome without changing refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand merge" -l ff-only -d 'Refuse when a fast-forward is not possible (exit code 128)'
complete -c grit -n "__fish_grit_using_subcommand merge" -l no-ff -d 'Record a merge commit even when a fast-forward is possible'
complete -c grit -n "__fish_grit_using_subcommand merge" -l no-commit -d 'Apply the merge to the index and worktree but do not commit yet'
complete -c grit -n "__fish_grit_using_subcommand merge" -l squash -d 'Squash merged commits into staged changes and write `SQUASH_MSG`'
complete -c grit -n "__fish_grit_using_subcommand merge" -l allow-unrelated-histories -d 'Merge histories that share no commits (uses the empty tree as merge base)'
complete -c grit -n "__fish_grit_using_subcommand merge" -l no-verify -d 'Skip the `pre-merge-commit` and `commit-msg` hooks (`prepare-commit-msg` and `post-merge` still run)'
complete -c grit -n "__fish_grit_using_subcommand merge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand pick" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand pick" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand pick" -l mainline -d 'Parent number when picking a merge commit (1-based, long only)' -r
complete -c grit -n "__fish_grit_using_subcommand pick" -l empty -d 'When a pick step would not change the tree: stop (default), keep an empty commit, or drop the step' -r -f -a "stop\t'Stop and leave sequencer state for `--continue` / `--skip`'
keep\t'Record an empty commit for the step'
drop\t'Skip the commit and continue with the next one'"
complete -c grit -n "__fish_grit_using_subcommand pick" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand pick" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand pick" -s X -d 'Auto-resolve replay conflicts: `ours` keeps the current branch side, `theirs` keeps the replayed change' -r -f -a "ours\t'Favor the upstream / onto side during rebase replay (matches `git rebase -X ours`)'
theirs\t'Favor the commit being replayed (matches `git rebase -X theirs`)'"
complete -c grit -n "__fish_grit_using_subcommand pick" -l conflict -d 'Conflict marker style when a step would stop with conflicts' -r -f -a "merge\t'Standard two-section conflict markers'
diff3\t'Three-section markers including the base section'
zdiff3\t'Zealous diff3 (`zdiff3`)'"
complete -c grit -n "__fish_grit_using_subcommand pick" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand pick" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand pick" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand pick" -l continue -d 'Finish a pick stopped on conflicts or an empty commit'
complete -c grit -n "__fish_grit_using_subcommand pick" -l abort -d 'Cancel an in-progress pick and restore the pre-pick state'
complete -c grit -n "__fish_grit_using_subcommand pick" -l skip -d 'Skip the current pick step and continue with the next commit'
complete -c grit -n "__fish_grit_using_subcommand pick" -s x -l record-origin -d 'Append `(cherry picked from commit …)` to each new commit message'
complete -c grit -n "__fish_grit_using_subcommand pick" -l no-commit -d 'Apply the pick to the index only; do not create a commit yet'
complete -c grit -n "__fish_grit_using_subcommand pick" -l check -d 'Predict whether the pick would succeed without changing refs, the index, or the worktree'
complete -c grit -n "__fish_grit_using_subcommand pick" -l dry-run -d 'List commits that would be picked without changing refs or the worktree'
complete -c grit -n "__fish_grit_using_subcommand pick" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand revert" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand revert" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand revert" -l mainline -d 'Parent number when reverting a merge commit (1-based, long only)' -r
complete -c grit -n "__fish_grit_using_subcommand revert" -l empty -d 'When a revert step would not change the tree: stop (default), keep an empty commit, or drop the step' -r -f -a "stop\t'Stop and leave sequencer state for `--continue` / `--skip`'
keep\t'Record an empty commit for the step'
drop\t'Skip the commit and continue with the next one'"
complete -c grit -n "__fish_grit_using_subcommand revert" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand revert" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand revert" -s X -d 'Auto-resolve replay conflicts: `ours` keeps the current branch side, `theirs` keeps the replayed change' -r -f -a "ours\t'Favor the upstream / onto side during rebase replay (matches `git rebase -X ours`)'
theirs\t'Favor the commit being replayed (matches `git rebase -X theirs`)'"
complete -c grit -n "__fish_grit_using_subcommand revert" -l conflict -d 'Conflict marker style when a step would stop with conflicts' -r -f -a "merge\t'Standard two-section conflict markers'
diff3\t'Three-section markers including the base section'
zdiff3\t'Zealous diff3 (`zdiff3`)'"
complete -c grit -n "__fish_grit_using_subcommand revert" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand revert" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand revert" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand revert" -l continue -d 'Finish a revert stopped on conflicts or an empty commit'
complete -c grit -n "__fish_grit_using_subcommand revert" -l abort -d 'Cancel an in-progress revert and restore the pre-revert state'
complete -c grit -n "__fish_grit_using_subcommand revert" -l skip -d 'Skip the current revert step and continue with the next commit'
complete -c grit -n "__fish_grit_using_subcommand revert" -l no-commit -d 'Apply the revert to the index only; do not create a commit yet'
complete -c grit -n "__fish_grit_using_subcommand revert" -l check -d 'Predict whether the revert would succeed without changing refs, the index, or the worktree'
complete -c grit -n "__fish_grit_using_subcommand revert" -l dry-run -d 'List commits that would be reverted without changing refs or the worktree'
complete -c grit -n "__fish_grit_using_subcommand revert" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "drop" -d 'Remove a commit and replay descendants onto its parent'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "move" -d 'Reorder a commit on the first-parent chain of `HEAD`'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "reword" -d 'Replace a commit message and replay descendants onto the new history'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "fixup" -d 'Apply staged changes onto a commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "absorb" -d 'Assign staged hunks into recent commits and replay descendants once'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "rebase" -d 'Replay local commits onto a new base (same as top-level `grit rebase`)'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "split" -d 'Peel path-limited changes out of a commit into a new parent and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "undo" -d 'Undo the last applied history rewrite using the recorded ref plan'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "squash" -d 'Fold a revision range into the oldest commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and not __fish_seen_subcommand_from drop move reword fixup absorb rebase split undo squash help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from drop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l before -d 'Place the commit immediately before this revision' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l after -d 'Place the commit immediately after this revision' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from move" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l author -d 'Author ident (`Name <email>` or bare email)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from reword" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l hunks -d 'Unstaged hunk ids to fold (`grit diff --unstaged --json`, comma-separated or repeated)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l lines -d 'Unstaged new-side line ranges to fold (`path:start-end` or `path:line`, comma-separated or repeated)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from fixup" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l base -d 'Oldest commit boundary (exclusive) for candidate commits' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from absorb" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l onto -d 'Replay onto this commit instead of `UPSTREAM`' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -s X -d 'Auto-resolve replay conflicts: `ours` keeps the onto side, `theirs` keeps replayed commits' -r -f -a "ours\t'Favor the upstream / onto side during rebase replay (matches `git rebase -X ours`)'
theirs\t'Favor the commit being replayed (matches `git rebase -X theirs`)'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l exec -d 'Run a shell command after each replayed commit is checked out (repeatable; incompatible with `--dry-run` and `--check`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l continue -d 'Finish a rebase stopped on conflicts after resolving and staging paths'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l abort -d 'Cancel an in-progress rebase and restore the branch to its pre-rebase tip'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l skip -d 'Skip the current commit and replay the rest'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l check -d 'Predict whether the rebase would succeed without changing refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l no-verify -d 'Skip the `pre-rebase` hook'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from rebase" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l rest-message -d 'Replace the remaining commit\'s message after the split' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from split" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from undo" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l combine -d 'Build a combined autosquash-style message from every commit in the range'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from squash" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "drop" -d 'Remove a commit and replay descendants onto its parent'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "move" -d 'Reorder a commit on the first-parent chain of `HEAD`'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "reword" -d 'Replace a commit message and replay descendants onto the new history'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "fixup" -d 'Apply staged changes onto a commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "absorb" -d 'Assign staged hunks into recent commits and replay descendants once'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "rebase" -d 'Replay local commits onto a new base (same as top-level `grit rebase`)'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "split" -d 'Peel path-limited changes out of a commit into a new parent and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "undo" -d 'Undo the last applied history rewrite using the recorded ref plan'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "squash" -d 'Fold a revision range into the oldest commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand history; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "push" -d 'Save local changes to the stash and reset the working tree'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "list" -d 'List stash entries'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "show" -d 'Show the summary or patch for a stash entry'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "branch" -d 'Create a branch at the stash base commit and apply the stash with `--index`'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "clear" -d 'Remove every stash entry'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "apply" -d 'Apply a stash entry without removing it'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "pop" -d 'Apply a stash entry and remove it when there are no conflicts'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "drop" -d 'Remove a stash entry without applying it'
complete -c grit -n "__fish_grit_using_subcommand stash; and not __fish_seen_subcommand_from push list show branch clear apply pop drop help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s m -l message -d 'Stash message' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l hunks -d 'Stash only unstaged hunks from `grit diff --json`' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l lines -d 'Stash only unstaged line ranges (`path:start-end`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s u -l include-untracked -d 'Include untracked files in the stash'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s S -l staged -d 'Stash only index changes vs `HEAD`'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s k -l keep-index -d 'Leave staged content in the index and worktree after stashing'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from push" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l stat -d 'Show a diffstat summary (default)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s p -l patch -d 'Show the full patch instead of a diffstat'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s u -l include-untracked -d 'Include untracked files from the stash U parent'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from branch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l force -d 'Delete all stash entries (required)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l dry-run -d 'Report how many entries would be cleared without deleting'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from clear" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l index -d 'Restore the stashed index as well as the worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from apply" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l index -d 'Restore the stashed index as well as the worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from pop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s m -l message -d 'Stash message (bare `grit stash` / `grit stash push`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l hunks -d 'Stash only unstaged hunks from `grit diff --json` (comma-separated, repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l lines -d 'Stash only unstaged line ranges (`path:start-end`, same as `grit add --lines`)' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s n -l limit -d 'Cap path lists in `--dry-run` preview output' -r
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s u -l include-untracked -d 'Include untracked files (bare `grit stash` / `grit stash push`)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -l dry-run -d 'Preview stash without updating refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s S -l staged -d 'Stash only index changes vs `HEAD` (unstaged edits on other paths remain)'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s k -l keep-index -d 'After stashing, leave the index and worktree matching staged content'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from drop" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "push" -d 'Save local changes to the stash and reset the working tree'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "list" -d 'List stash entries'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show the summary or patch for a stash entry'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "branch" -d 'Create a branch at the stash base commit and apply the stash with `--index`'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "clear" -d 'Remove every stash entry'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "apply" -d 'Apply a stash entry without removing it'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "pop" -d 'Apply a stash entry and remove it when there are no conflicts'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "drop" -d 'Remove a stash entry without applying it'
complete -c grit -n "__fish_grit_using_subcommand stash; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand restore" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -l pathspec-from-file -d 'Read pathspecs from a file (`-` for stdin) instead of or in addition to argv paths' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -s s -l source -d 'Tree or commit to restore from' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -l conflict -d 'Conflict marker style (implies `--merge`)' -r -f -a "merge\t'Standard two-section conflict markers'
diff3\t'Three-section markers including the base section'
zdiff3\t'Zealous diff3 (`zdiff3`)'"
complete -c grit -n "__fish_grit_using_subcommand restore" -l hunks -d 'Discard only the listed unstaged hunk ids (`grit diff --unstaged --json`) or unstage staged ids (`--staged`)' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -l lines -d 'Discard or unstage only new-side line ranges (`path:start-end` from `grit diff --json`)' -r
complete -c grit -n "__fish_grit_using_subcommand restore" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand restore" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand restore" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand restore" -l pathspec-file-nul -d '`--pathspec-from-file` entries are NUL-separated'
complete -c grit -n "__fish_grit_using_subcommand restore" -s S -l staged -d 'Restore the index from HEAD (or `--source`)'
complete -c grit -n "__fish_grit_using_subcommand restore" -s W -l worktree -d 'Restore the working tree (default when `--staged` is absent)'
complete -c grit -n "__fish_grit_using_subcommand restore" -l ours -d 'For unmerged paths, write our side (index stage 2) into the worktree'
complete -c grit -n "__fish_grit_using_subcommand restore" -l theirs -d 'For unmerged paths, write their side (index stage 3) into the worktree'
complete -c grit -n "__fish_grit_using_subcommand restore" -l merge -d 'Rebuild conflict markers in the worktree from index stages'
complete -c grit -n "__fish_grit_using_subcommand restore" -l dry-run -d 'Report paths that would change without writing the worktree or index'
complete -c grit -n "__fish_grit_using_subcommand restore" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand fetch" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand fetch" -l depth -d 'Fetch only the recent history of each branch (same as `git fetch --depth`)' -r
complete -c grit -n "__fish_grit_using_subcommand fetch" -l deepen -d 'Deepen an existing shallow clone by this many commits (`git fetch --deepen`)' -r
complete -c grit -n "__fish_grit_using_subcommand fetch" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l all -d 'Fetch from every configured remote (respects `remote.<name>.skipFetchAll`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l tags -d 'Fetch all tags from the remote (`git fetch --tags`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l no-tags -d 'Do not fetch tags automatically (`git fetch --no-tags`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l prune -d 'Remove remote-tracking refs that no longer exist on the remote'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l no-prune -d 'Do not prune stale remote-tracking refs, even when config enables it'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l dry-run -d 'Report ref updates without writing refs or objects'
complete -c grit -n "__fish_grit_using_subcommand fetch" -s q -l quiet -d 'Suppress progress and human output'
complete -c grit -n "__fish_grit_using_subcommand fetch" -l unshallow -d 'Convert a shallow repository to a complete one (`git fetch --unshallow`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -s f -l force -d 'Force ref updates that would be rejected (non-fast-forward, tag clobber with `--tags`)'
complete -c grit -n "__fish_grit_using_subcommand fetch" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand pull" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand pull" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand pull" -l depth -d 'Fetch only the recent history of each branch (same as `git fetch --depth`)' -r
complete -c grit -n "__fish_grit_using_subcommand pull" -l deepen -d 'Deepen an existing shallow clone by this many commits (`git fetch --deepen`)' -r
complete -c grit -n "__fish_grit_using_subcommand pull" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand pull" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand pull" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l all -d 'Fetch from every configured remote (respects `remote.<name>.skipFetchAll`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l tags -d 'Fetch all tags from the remote (`git fetch --tags`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l no-tags -d 'Do not fetch tags automatically (`git fetch --no-tags`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l prune -d 'Remove remote-tracking refs that no longer exist on the remote'
complete -c grit -n "__fish_grit_using_subcommand pull" -l no-prune -d 'Do not prune stale remote-tracking refs, even when config enables it'
complete -c grit -n "__fish_grit_using_subcommand pull" -l dry-run -d 'Report ref updates without writing refs or objects'
complete -c grit -n "__fish_grit_using_subcommand pull" -s q -l quiet -d 'Suppress progress and human output'
complete -c grit -n "__fish_grit_using_subcommand pull" -l unshallow -d 'Convert a shallow repository to a complete one (`git fetch --unshallow`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -s f -l force -d 'Force ref updates that would be rejected (non-fast-forward, tag clobber with `--tags`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l ff-only -d 'Refuse when a merge would be required (exit 1 when diverged)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l no-rebase -d 'Merge instead of rebasing, overriding `pull.rebase`'
complete -c grit -n "__fish_grit_using_subcommand pull" -l rebase -d 'Rebase local commits onto the fetched upstream, overriding `pull.rebase=false`'
complete -c grit -n "__fish_grit_using_subcommand pull" -l autostash -d 'Stash dirty worktree/index changes around the pull (`merge.autoStash` / `rebase.autoStash`)'
complete -c grit -n "__fish_grit_using_subcommand pull" -l check -d 'Fetch and report whether a fast-forward is possible without changing the branch'
complete -c grit -n "__fish_grit_using_subcommand pull" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand rebase" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand rebase" -l onto -d 'Replay onto this commit instead of `UPSTREAM`' -r
complete -c grit -n "__fish_grit_using_subcommand rebase" -s X -d 'Auto-resolve replay conflicts: `ours` keeps the onto side, `theirs` keeps replayed commits' -r -f -a "ours\t'Favor the upstream / onto side during rebase replay (matches `git rebase -X ours`)'
theirs\t'Favor the commit being replayed (matches `git rebase -X theirs`)'"
complete -c grit -n "__fish_grit_using_subcommand rebase" -l exec -d 'Run a shell command after each replayed commit is checked out (repeatable; incompatible with `--dry-run` and `--check`)' -r
complete -c grit -n "__fish_grit_using_subcommand rebase" -l update-refs -d 'Which refs to rewrite: all descendant branches (default) or only `HEAD`' -r -f -a "branches\t'Every local branch descending from the edited commit, plus `HEAD` when applicable, except other branches at the `HEAD` commit (backups keep the old history)'
head\t'Only the commit `HEAD` currently points at'"
complete -c grit -n "__fish_grit_using_subcommand rebase" -l empty -d 'When a replayed commit would not change the tree: drop (default), keep an empty commit, or abort' -r -f -a "drop\t'Omit commits whose tree matches the new parent'
keep\t'Keep empty commits'
abort\t'Refuse when a commit would become empty'"
complete -c grit -n "__fish_grit_using_subcommand rebase" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l continue -d 'Finish a rebase stopped on conflicts after resolving and staging paths'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l abort -d 'Cancel an in-progress rebase and restore the branch to its pre-rebase tip'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l skip -d 'Skip the current commit and replay the rest'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l check -d 'Predict whether the rebase would succeed without changing refs, index, or worktree'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l no-verify -d 'Skip the `pre-rebase` hook'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l dry-run -d 'Print planned ref updates without moving refs (new commit objects are still written)'
complete -c grit -n "__fish_grit_using_subcommand rebase" -l keep-committer -d 'Keep each replayed commit\'s original committer line instead of the configured committer'
complete -c grit -n "__fish_grit_using_subcommand rebase" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand push" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand push" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand push" -l remote -d 'Remote to push to (defaults to the current branch\'s remote or `origin`)' -r
complete -c grit -n "__fish_grit_using_subcommand push" -l force-with-lease -d 'Push only when the remote ref matches the local remote-tracking ref, or `=<rev>` when pushing exactly one ref' -r
complete -c grit -n "__fish_grit_using_subcommand push" -s o -l push-option -d 'Server-side push option (repeatable; `GIT_PUSH_OPTION_*` in hooks)' -r
complete -c grit -n "__fish_grit_using_subcommand push" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand push" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand push" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand push" -s t -l tags -d 'Push tags instead of the current branch. Pushes every local tag under `refs/tags/` to the remote'
complete -c grit -n "__fish_grit_using_subcommand push" -l delete -d 'Delete the named remote branches or tags instead of pushing'
complete -c grit -n "__fish_grit_using_subcommand push" -l dry-run -d 'Contact the remote but do not update refs or send objects'
complete -c grit -n "__fish_grit_using_subcommand push" -s f -l force -d 'Overwrite remote refs even when the update is not a fast-forward'
complete -c grit -n "__fish_grit_using_subcommand push" -s u -l set-upstream -d 'Set `branch.<name>.remote` and `branch.<name>.merge` for each pushed branch'
complete -c grit -n "__fish_grit_using_subcommand push" -l atomic -d 'All ref updates succeed or none are applied'
complete -c grit -n "__fish_grit_using_subcommand push" -l follow-tags -d 'Push annotated tags reachable from the commits being pushed'
complete -c grit -n "__fish_grit_using_subcommand push" -l no-verify -d 'Skip the `pre-push` hook'
complete -c grit -n "__fish_grit_using_subcommand push" -s q -l quiet -d 'Suppress progress and human output'
complete -c grit -n "__fish_grit_using_subcommand push" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -f -a "create" -d 'Write a bundle file from revision specs'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -f -a "verify" -d 'Check that a bundle file is well-formed'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -f -a "list" -d 'List refs recorded in a bundle header'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -f -a "unbundle" -d 'Ingest a bundle pack into the current repository'
complete -c grit -n "__fish_grit_using_subcommand bundle; and not __fish_seen_subcommand_from create verify list unbundle help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l all -d 'Include every ref tip in the bundle header (`HEAD`, all branches and tags)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l dry-run -d 'Report refs, prerequisites, and object count without writing a file'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from verify" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l dry-run -d 'Verify and list ref updates without ingesting objects or writing refs'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from unbundle" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from help" -f -a "create" -d 'Write a bundle file from revision specs'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from help" -f -a "verify" -d 'Check that a bundle file is well-formed'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from help" -f -a "list" -d 'List refs recorded in a bundle header'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from help" -f -a "unbundle" -d 'Ingest a bundle pack into the current repository'
complete -c grit -n "__fish_grit_using_subcommand bundle; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l ref -d 'Notes ref (default: `core.notesRef` or `refs/notes/commits`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -l dry-run -d 'Preview `add` or `remove` without writing objects or refs'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -f -a "list" -d 'List notes attached to commits'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -f -a "show" -d 'Show the note for a revision'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -f -a "add" -d 'Add or replace a note on a revision'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -f -a "remove" -d 'Remove notes from one or more revisions'
complete -c grit -n "__fish_grit_using_subcommand notes; and not __fish_seen_subcommand_from list show add remove help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l ref -d 'Notes ref (default: `core.notesRef` or `refs/notes/commits`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -l dry-run -d 'Preview `add` or `remove` without writing objects or refs'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l ref -d 'Notes ref (default: `core.notesRef` or `refs/notes/commits`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -l dry-run -d 'Preview `add` or `remove` without writing objects or refs'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l ref -d 'Notes ref (default: `core.notesRef` or `refs/notes/commits`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l force -d 'Replace an existing note'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -l dry-run -d 'Preview `add` or `remove` without writing objects or refs'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l ref -d 'Notes ref (default: `core.notesRef` or `refs/notes/commits`)' -r
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -l dry-run -d 'Preview `add` or `remove` without writing objects or refs'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from help" -f -a "list" -d 'List notes attached to commits'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show the note for a revision'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add or replace a note on a revision'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove notes from one or more revisions'
complete -c grit -n "__fish_grit_using_subcommand notes; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand tag" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -s l -l list -d 'List tags matching `PATTERN` (repeatable). Omit `PATTERN` to list all tags' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l sort -d 'Sort listed tags by version, date, or name' -r -f -a "version\t'`version:refname` (default)'
date\t'Creator date (tagger or committer)'
name\t'Ref name'"
complete -c grit -n "__fish_grit_using_subcommand tag" -l contains -d 'Only tags whose peeled commit contains this revision (`HEAD` when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l points-at -d 'Only tags pointing at this object (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -s n -l limit -l max-count -d 'Maximum number of rows to list' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -s m -l message -d 'Commit message text' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -s F -l message-file -d 'Read the message from a file (`-` for stdin)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l file -d 'Deprecated alias for `--message-file`' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l object -d 'Object to tag (revision). Defaults to `HEAD`' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l signing-key -d 'Signing key id or path (overrides `user.signingkey` for this tag)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l exclude-submodule -d 'Submodule path globs excluded from the digest (repeatable)' -r
complete -c grit -n "__fish_grit_using_subcommand tag" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand tag" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand tag" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand tag" -l reverse -d 'Reverse the sort order'
complete -c grit -n "__fish_grit_using_subcommand tag" -s d -l delete -d 'Delete the named tag instead of creating it'
complete -c grit -n "__fish_grit_using_subcommand tag" -s a -l annotate -d 'Git habit: `-m` / `-F` already write an annotated tag; ignored when a message is set'
complete -c grit -n "__fish_grit_using_subcommand tag" -s f -l force -d 'Replace an existing tag with the same name'
complete -c grit -n "__fish_grit_using_subcommand tag" -l dry-run -d 'Preview create or delete without changing refs'
complete -c grit -n "__fish_grit_using_subcommand tag" -s s -l sign -d 'Sign the tag object (implies annotated). Honors `tag.gpgSign` when omitted'
complete -c grit -n "__fish_grit_using_subcommand tag" -l no-sign -d 'Do not sign even when `tag.gpgSign` is true'
complete -c grit -n "__fish_grit_using_subcommand tag" -s v -l verify -d 'Verify annotated tag signatures and optional `tree-sha256` claims'
complete -c grit -n "__fish_grit_using_subcommand tag" -l no-signature -d 'Skip signature verification (still checks `tree-sha256` when present)'
complete -c grit -n "__fish_grit_using_subcommand tag" -l tree-sha256 -d 'Attach a tree-sha256 content digest to the tag (implies `--sign`)'
complete -c grit -n "__fish_grit_using_subcommand tag" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "list" -d 'List registered worktrees (main first, then linked)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "add" -d 'Create a linked worktree at `path`'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "remove" -d 'Remove a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "prune" -d 'Drop registrations for linked worktrees whose directories are gone'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "lock" -d 'Mark a linked worktree as locked (prevents accidental removal)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "unlock" -d 'Clear the lock on a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "move" -d 'Move a linked worktree to a new directory'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "repair" -d 'Fix `.git` / `gitdir` links after a manual directory move'
complete -c grit -n "__fish_grit_using_subcommand worktree; and not __fish_seen_subcommand_from list add remove prune lock unlock move repair help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -s b -l branch -d 'Create and check out a new branch' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -s B -d 'Create or reset a branch to the start point (`-B`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l reason -d 'Reason stored in the lock file (requires `--lock`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l detach -d 'Check out in detached HEAD mode'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -s f -l force -d 'Reuse a stale registration when the working tree directory is missing'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l lock -d 'Mark the new worktree locked before checkout finishes'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l no-checkout -d 'Register the worktree without populating files (HEAD only)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l track -d 'Set upstream when the start point is a remote-tracking branch'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -s f -l force -d 'Remove even when the worktree has local changes or is locked'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l dry-run -d 'List prunable worktrees without removing registrations'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from prune" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l reason -d 'Optional reason stored in the lock file' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from lock" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from unlock" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -s f -l force -d 'Allow move when the worktree is locked'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l dry-run -d 'Preview the move without changing disk state'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from move" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l dry-run -d 'Report repairs without writing files'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from repair" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "list" -d 'List registered worktrees (main first, then linked)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "add" -d 'Create a linked worktree at `path`'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "prune" -d 'Drop registrations for linked worktrees whose directories are gone'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "lock" -d 'Mark a linked worktree as locked (prevents accidental removal)'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "unlock" -d 'Clear the lock on a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "move" -d 'Move a linked worktree to a new directory'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "repair" -d 'Fix `.git` / `gitdir` links after a manual directory move'
complete -c grit -n "__fish_grit_using_subcommand worktree; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l token -d 'Store this access token: with `--username`, for any HTTP(S) host; alone, a `grit serve` or grithub token, checked with the server' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l username -d 'Store `--token` for this user name on any HTTP(S) host, without signing in' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -a "logout" -d 'Forget the stored token (sign out) for grithub (GitHub inside a github.com repository), or for a `grit serve` URL'
complete -c grit -n "__fish_grit_using_subcommand auth; and not __fish_seen_subcommand_from logout help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l dry-run -d 'Report which stored credential would be removed without erasing it'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "logout" -d 'Forget the stored token (sign out) for grithub (GitHub inside a github.com repository), or for a `grit serve` URL'
complete -c grit -n "__fish_grit_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l token -d 'Store this access token: with `--username`, for any HTTP(S) host; alone, a `grit serve` or grithub token, checked with the server' -r
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l username -d 'Store `--token` for this user name on any HTTP(S) host, without signing in' -r
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -a "logout" -d 'Forget the stored token (sign out) for grithub (GitHub inside a github.com repository), or for a `grit serve` URL'
complete -c grit -n "__fish_grit_using_subcommand login; and not __fish_seen_subcommand_from logout help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l dry-run -d 'Report which stored credential would be removed without erasing it'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from help" -f -a "logout" -d 'Forget the stored token (sign out) for grithub (GitHub inside a github.com repository), or for a `grit serve` URL'
complete -c grit -n "__fish_grit_using_subcommand login; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand update" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand update" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand update" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand update" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand update" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand update" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand skill" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand skill" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand skill" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand skill" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand skill" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand skill" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand completions" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand completions" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand completions" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand completions" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand completions" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand config" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand config" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand config" -s f -l file -d 'Read or write only the given config file (no repository required)' -r -F
complete -c grit -n "__fish_grit_using_subcommand config" -l rename-section -d 'Current section name for `--rename-section`' -r
complete -c grit -n "__fish_grit_using_subcommand config" -l rename-section-new -d 'New section name for `--rename-section`' -r
complete -c grit -n "__fish_grit_using_subcommand config" -l remove-section -d 'Remove an entire section' -r
complete -c grit -n "__fish_grit_using_subcommand config" -l type -d 'Coerce values as bool, int, or path (canonical on write)' -r -f -a "bool\t''
int\t''
path\t''"
complete -c grit -n "__fish_grit_using_subcommand config" -l default -d 'When reading, use this value if the key is unset' -r
complete -c grit -n "__fish_grit_using_subcommand config" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand config" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand config" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand config" -l global -d 'Use the global (per-user) config file instead of this repository\'s'
complete -c grit -n "__fish_grit_using_subcommand config" -l local -d 'Read or write only this repository\'s config file (`.git/config`)'
complete -c grit -n "__fish_grit_using_subcommand config" -l system -d 'Read or write the system config file (`/etc/gitconfig` or `GIT_CONFIG_SYSTEM`)'
complete -c grit -n "__fish_grit_using_subcommand config" -l worktree -d 'Read or write this worktree\'s `config.worktree` (requires `extensions.worktreeConfig`)'
complete -c grit -n "__fish_grit_using_subcommand config" -s l -l list -d 'List configuration values (optional `<prefix>` filters keys)'
complete -c grit -n "__fish_grit_using_subcommand config" -l all -d 'Return every value for a multi-valued key'
complete -c grit -n "__fish_grit_using_subcommand config" -l add -d 'Append a value without replacing existing entries'
complete -c grit -n "__fish_grit_using_subcommand config" -l unset -d 'Remove the key instead of reading or setting it'
complete -c grit -n "__fish_grit_using_subcommand config" -l unset-all -d 'Remove every occurrence of a multi-valued key'
complete -c grit -n "__fish_grit_using_subcommand config" -l dry-run -d 'Show what would change without writing the config file'
complete -c grit -n "__fish_grit_using_subcommand config" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand manager" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand manager" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand manager" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand manager" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand manager" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand manager" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l root -d 'A repository, or a directory of repositories, to serve' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l db -d 'The user database (default: `grit-serve.db` in the root, or in its `.git`)' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l bind -d 'Address to listen on' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l email -d 'Email address of the admin `--setup` creates (asked for when omitted)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l bundle-interval -d 'How often to rebuild a changed repository\'s clone bundle, like `24h`, `30m` or `2d`' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l setup -d 'Create the user database and its first admin user, then exit. Prompts for a password (or generates one)'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -l no-bundles -d 'Do not build or offer clone bundles'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -f -a "add-user" -d 'Add a user. Prompts for their password, or generates a temporary one'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -f -a "token" -d 'Create an access token for a user, for scripts and CI that cannot sign in in a browser'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -f -a "grant" -d 'Give a user read access to a repository (or write access with `--write`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -f -a "users" -d 'List users, their tokens and their repository access'
complete -c grit -n "__fish_grit_using_subcommand serve; and not __fish_seen_subcommand_from add-user token grant users help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l root -d 'A repository, or a directory of repositories, to serve' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l db -d 'The user database (default: `grit-serve.db` in the root, or in its `.git`)' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l admin -d 'Make the user an admin, with read and write access to every repository'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from add-user" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l root -d 'A repository, or a directory of repositories, to serve' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l db -d 'The user database (default: `grit-serve.db` in the root, or in its `.git`)' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from token" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l root -d 'A repository, or a directory of repositories, to serve' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l db -d 'The user database (default: `grit-serve.db` in the root, or in its `.git`)' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l write -d 'Allow pushing as well as fetching'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from grant" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l root -d 'A repository, or a directory of repositories, to serve' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l db -d 'The user database (default: `grit-serve.db` in the root, or in its `.git`)' -r -F
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from users" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from help" -f -a "add-user" -d 'Add a user. Prompts for their password, or generates a temporary one'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from help" -f -a "token" -d 'Create an access token for a user, for scripts and CI that cannot sign in in a browser'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from help" -f -a "grant" -d 'Give a user read access to a repository (or write access with `--write`)'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from help" -f -a "users" -d 'List users, their tokens and their repository access'
complete -c grit -n "__fish_grit_using_subcommand serve; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l stateless-rpc -d 'Answer a single request without advertising refs first (smart HTTP)'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -l advertise-refs -d 'Print the ref advertisement and exit (smart HTTP discovery)'
complete -c grit -n "__fish_grit_using_subcommand upload-pack" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l filter -d 'jq-like expression applied to JSON output (requires `--json`)' -r
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l threads -d 'Worker threads for parallel library work (`0` = auto, `1` = serial)' -r
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l json -d 'Emit machine-readable JSON instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l markdown -d 'Emit agent-friendly Markdown instead of human-readable text'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l no-optional-locks -d 'Skip opportunistic index updates that take optional locks (same as `GIT_OPTIONAL_LOCKS=0`)'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l stateless-rpc -d 'Answer a single request without advertising refs first (smart HTTP)'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -l advertise-refs -d 'Print the ref advertisement and exit (smart HTTP discovery)'
complete -c grit -n "__fish_grit_using_subcommand receive-pack" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "init" -d 'Create a new, empty repository'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "checkout" -d 'Start work on a repository from a snapshot of its main branch (or some of its paths) instead of a clone'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "checkin" -d 'Send a snapshot checkout\'s branches back to the server, grafted onto its real history'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "integrate" -d 'Merge a branch into the server\'s target branch (checking it in first), then refresh this checkout'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "slice" -d 'Named sets of paths to check out together, kept on the server\'s target branch'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "clone" -d 'Copy a remote repository into a new directory'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "remote" -d 'List remotes, or add one'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "log" -d 'Show recent commits reachable from HEAD'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "revs" -d 'List or count commits matching revision ranges'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "merge-base" -d 'Find merge bases or test whether one commit is an ancestor of another'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "reflog" -d 'Show, delete, or expire reflog entries'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "blame" -d 'Show who last modified each line of a file'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "diff" -d 'Show changes as a diff. No argument: uncommitted changes; with a commit: the change that commit introduced; with two commits (or `A..B`) diff their trees'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "show" -d 'Show information about a commit, tag, or branch (defaults to HEAD)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "status" -d 'Show what\'s changed and where you are (this is the default)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "shortlog" -d 'List the commits on this branch that aren\'t on the target branch yet'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "add" -d 'Stage changes. With no paths, stages everything'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "rm" -d 'Remove tracked paths from the working tree and index'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "mv" -d 'Rename or move tracked paths'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "clean" -d 'Remove untracked files from the working tree'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "repack" -d 'Pack reachable objects and remove redundant packs'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "gc" -d 'Pack refs, expire reflogs, repack, prune, and refresh commit-graph'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "fsck" -d 'Check refs, objects, and pack indexes for problems'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "ignore" -d 'Query exclude (gitignore) rules'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "hooks" -d 'List hook scripts or run one by name'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "patch-id" -d 'Print stable patch-IDs for commits or revision ranges'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "resolve" -d 'Resolve revision specs to object ids and types'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "cat" -d 'Show blob, tree, commit, or tag contents for a revision spec'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "commit" -d 'Stage every change and record a new commit'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "branch" -d 'List branches, or create / delete / rename / configure one'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "switch" -d 'Switch to another branch, remote branch, or detached commit'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "reset" -d 'Move the branch tip and optionally reset the index or worktree'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "merge" -d 'Merge another branch, tag or commit into the current branch'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "pick" -d 'Cherry-pick commits onto the current branch'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "revert" -d 'Undo commits with new inverse commits'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "history" -d 'Rewrite commits without a sequencer (plan, then apply refs atomically)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "stash" -d 'Save or restore shelved work'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "restore" -d 'Restore working tree and/or index paths'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "fetch" -d 'Download refs and objects from a remote'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "pull" -d 'Fetch from the remote and integrate it into the current branch'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "rebase" -d 'Replay local commits onto a new base (atomic ref update)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "push" -d 'Publish refs to a remote'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "bundle" -d 'Create, verify, or list git bundle files'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "notes" -d 'List, show, add, or remove Git notes on commits'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "tag" -d 'List tags, or create / delete one'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "worktree" -d 'List, add, or remove linked worktrees'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "auth" -d 'Sign in to grithub (GitHub inside a github.com repository), a `grit serve` host, or store a username and token for any HTTPS host'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "update" -d 'Update grit to the latest release (re-runs the install script)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "skill" -d 'Print an agent skill (SKILL.md) that explains how to use grit'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "completions" -d 'Generate shell completion scripts for bash, zsh, or fish'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "config" -d 'Read, set, or list configuration values'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "manager" -d 'Git credential helper backed by the Windows Credential Manager'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "serve" -d 'Serve repositories over HTTP, with a web view where people sign in with email and password'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "upload-pack" -d 'Serve a fetch or clone over stdin/stdout (run by ssh and grit-http-server)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "receive-pack" -d 'Accept a push over stdin/stdout (run by ssh and grit-http-server)'
complete -c grit -n "__fish_grit_using_subcommand help; and not __fish_seen_subcommand_from init checkout checkin integrate slice clone remote log revs merge-base reflog blame diff show status shortlog add rm mv clean repack gc fsck ignore hooks patch-id resolve cat commit branch switch reset merge pick revert history stash restore fetch pull rebase push bundle notes tag worktree auth update skill completions config manager serve upload-pack receive-pack help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from slice" -f -a "list" -d 'List the slices'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from slice" -f -a "new" -d 'Make a slice'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from slice" -f -a "edit" -d 'Add paths to a slice or remove them'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from slice" -f -a "delete" -d 'Delete a slice'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from slice" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "add" -d 'Add a new remote'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "set-url" -d 'Set the fetch or push URL for an existing remote'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "remove" -d 'Remove a remote and its remote-tracking refs'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "prune" -d 'Delete stale remote-tracking refs without fetching'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "set-head" -d 'Set or delete `refs/remotes/<name>/HEAD`'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "show" -d 'Summarize a remote (URLs, branches, pull config)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "rename" -d 'Rename an existing remote'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "refs" -d 'List references on a remote (like `git ls-remote`)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from remote" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from reflog" -f -a "delete" -d 'Remove one or more reflog entries (`ref@{n}`)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from reflog" -f -a "expire" -d 'Drop reflog entries older than configured or explicit cutoffs'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from reflog" -f -a "list" -d 'List refs that currently have a reflog'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from reflog" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "repack" -d 'Repack reachable objects into one pack'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "commit-graph" -d 'Write a reachable commit-graph with changed-path Bloom filters'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "midx" -d 'Write or refresh the multi-pack-index'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "pack-refs" -d 'Pack loose refs into `packed-refs` (or compact reftable)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "prune" -d 'Delete unreachable loose objects'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "offload" -d 'Move large blobs to a large-object promisor remote and drop them here'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "drop-large-blobs" -d 'Drop large blobs a promisor remote can supply again and nothing needed recently'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from gc" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from ignore" -f -a "check" -d 'Print whether paths match exclude rules'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from ignore" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from hooks" -f -a "list" -d 'List hook scripts in the resolved hooks directory'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from hooks" -f -a "run" -d 'Run a hook by name (passes `--` arguments through to the script)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from hooks" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "drop" -d 'Remove a commit and replay descendants onto its parent'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "move" -d 'Reorder a commit on the first-parent chain of `HEAD`'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "reword" -d 'Replace a commit message and replay descendants onto the new history'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "fixup" -d 'Apply staged changes onto a commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "absorb" -d 'Assign staged hunks into recent commits and replay descendants once'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "rebase" -d 'Replay local commits onto a new base (same as top-level `grit rebase`)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "split" -d 'Peel path-limited changes out of a commit into a new parent and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "undo" -d 'Undo the last applied history rewrite using the recorded ref plan'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "squash" -d 'Fold a revision range into the oldest commit and replay descendants'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from history" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "push" -d 'Save local changes to the stash and reset the working tree'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "list" -d 'List stash entries'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "show" -d 'Show the summary or patch for a stash entry'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "branch" -d 'Create a branch at the stash base commit and apply the stash with `--index`'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "clear" -d 'Remove every stash entry'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "apply" -d 'Apply a stash entry without removing it'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "pop" -d 'Apply a stash entry and remove it when there are no conflicts'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "drop" -d 'Remove a stash entry without applying it'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from stash" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from bundle" -f -a "create" -d 'Write a bundle file from revision specs'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from bundle" -f -a "verify" -d 'Check that a bundle file is well-formed'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from bundle" -f -a "list" -d 'List refs recorded in a bundle header'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from bundle" -f -a "unbundle" -d 'Ingest a bundle pack into the current repository'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from bundle" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from notes" -f -a "list" -d 'List notes attached to commits'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from notes" -f -a "show" -d 'Show the note for a revision'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from notes" -f -a "add" -d 'Add or replace a note on a revision'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from notes" -f -a "remove" -d 'Remove notes from one or more revisions'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from notes" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "list" -d 'List registered worktrees (main first, then linked)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "add" -d 'Create a linked worktree at `path`'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "remove" -d 'Remove a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "prune" -d 'Drop registrations for linked worktrees whose directories are gone'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "lock" -d 'Mark a linked worktree as locked (prevents accidental removal)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "unlock" -d 'Clear the lock on a linked worktree'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "move" -d 'Move a linked worktree to a new directory'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "repair" -d 'Fix `.git` / `gitdir` links after a manual directory move'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from worktree" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a "logout" -d 'Forget the stored token (sign out) for grithub (GitHub inside a github.com repository), or for a `grit serve` URL'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from serve" -f -a "add-user" -d 'Add a user. Prompts for their password, or generates a temporary one'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from serve" -f -a "token" -d 'Create an access token for a user, for scripts and CI that cannot sign in in a browser'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from serve" -f -a "grant" -d 'Give a user read access to a repository (or write access with `--write`)'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from serve" -f -a "users" -d 'List users, their tokens and their repository access'
complete -c grit -n "__fish_grit_using_subcommand help; and __fish_seen_subcommand_from serve" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
