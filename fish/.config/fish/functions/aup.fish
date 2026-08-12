function __aup_run --description 'Run one update command and report its result'
    set -l label $argv[1]
    set -l color $argv[2]
    set -l binary $argv[3]
    set -l version_command $argv[4]
    set -l update_args $argv[5..-1]

    if not command -q $binary
        set_color brblack
        printf '%s skipped (not installed).\n' "$label"
        set_color normal
        return 0
    end

    command $binary $update_args
    set -l update_status $status

    if test $update_status -eq 0
        set_color $color

        if test "$version_command" = -; or not command -q $version_command
            printf '%s updated.\n' "$label"
        else
            set -l version_output (command $version_command --version 2>&1 | string collect)
            set -l harness_version (string match -r '\d+\.\d+\.\d+(?:[-+][^ ]+)?' -- "$version_output")

            if test -n "$harness_version"
                printf '%s updated to v%s.\n' "$label" $harness_version[1]
            else
                printf '%s updated.\n' "$label"
            end
        end
    else
        set_color red
        printf '%s update failed (exit %d).\n' "$label" $update_status
    end

    set_color normal

    return $update_status
end

function aup --description 'Update installed agent harnesses and extensions'
    set -l manifest $__fish_config_dir/agent-harnesses.txt

    if not test -r "$manifest"
        set_color red
        printf 'aup: harness manifest not found at %s\n' "$manifest"
        set_color normal
        return 1
    end

    set -l failed 0

    while read -l line
        set line (string trim -- "$line")
        test -z "$line"; and continue
        string match -q '#*' -- "$line"; and continue

        set -l fields
        for field in (string split '|' -- "$line")
            set -a fields (string trim -- "$field")
        end

        if test (count $fields) -lt 5
            set_color red
            printf 'aup: malformed manifest line: %s\n' "$line"
            set_color normal
            set failed 1
            continue
        end

        set -l update_args (string split ' ' -- $fields[5])
        __aup_run $fields[1] $fields[2] $fields[3] $fields[4] $update_args
        or set failed 1
    end <"$manifest"

    return $failed
end
