function __aup_run --description 'Run one update command and report its result'
    set -l label $argv[1]
    set -e argv[1]

    command $argv
    set -l update_status $status

    if test $update_status -eq 0
        printf '[OK] %s update completed.\n' "$label"
    else
        printf '[FAIL] %s update failed (exit %d).\n' "$label" $update_status
    end

    return $update_status
end

function aup --description 'Update agent harnesses and installed extensions'
    set -l failed 0

    __aup_run Claude claude update; or set failed 1
    __aup_run 'Pi core' pi update; or set failed 1
    __aup_run 'Pi extensions' pi update --extensions; or set failed 1
    __aup_run 'OMP core' omp update; or set failed 1
    __aup_run 'OMP plugins' omp update --plugins; or set failed 1
    __aup_run Herdr herdr update; or set failed 1

    return $failed
end
