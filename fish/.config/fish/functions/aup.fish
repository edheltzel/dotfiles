function __aup_run --description 'Run one update command and report its result'
    set -l label $argv[1]
    set -l color $argv[2]
    set -l version_command $argv[3]
    set -l update_command $argv[4..-1]

    command $update_command
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

function aup --description 'Update agent harnesses and installed extensions'
    set -l failed 0

    __aup_run Claude ff8c42 claude claude update; or set failed 1
    __aup_run Jcode 5fff87 jcode jcode update; or set failed 1
    __aup_run Pi ff69b4 pi pi update; or set failed 1
    __aup_run 'Pi extensions' ff69b4 - pi update --extensions; or set failed 1
    __aup_run OMP af87ff omp omp update; or set failed 1
    __aup_run 'OMP plugins' af87ff - omp update --plugins; or set failed 1
    __aup_run Herdr 5fd7ff herdr herdr update; or set failed 1

    return $failed
end
