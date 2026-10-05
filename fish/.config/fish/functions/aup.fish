function __aup_prime_agent_update --description 'Run prime-agent update with a temporary npmCommand wrapper'
    set -l wrapdir (mktemp -d)
    set -l wrapper $wrapdir/npm
    set -l restore $wrapdir/restore.py
    set -l meta $wrapdir/meta.json
    set -l real_npm (command -s npm)
    set -l py (command -s python3)
    set -l prefix (path dirname (path dirname (command -s prime-agent)))
    set -l settings $HOME/.prime/agent/settings.json
    printf '%s\n' \
        'import json, os, sys' \
        'settings, meta = sys.argv[1:3]' \
        'if not os.path.isfile(meta):' \
        '    raise SystemExit(1)' \
        'with open(meta) as f:' \
        '    m = json.load(f)' \
        'if not os.path.isfile(settings):' \
        '    raise SystemExit(0 if m.get("created") else 1)' \
        'with open(settings) as f:' \
        '    data = json.load(f) or {}' \
        'if m.get("had"):' \
        '    data["npmCommand"] = m.get("orig")' \
        'else:' \
        '    data.pop("npmCommand", None)' \
        'if data:' \
        '    with open(settings, "w") as f:' \
        '        json.dump(data, f, indent=2)' \
        '        f.write("\n")' \
        'elif m.get("created"):' \
        '    os.remove(settings)' \
        'else:' \
        '    with open(settings, "w") as f:' \
        '        json.dump(data, f, indent=2)' \
        '        f.write("\n")' >$restore
    printf '%s\n' \
        '#!/bin/sh' \
        "real_npm='$real_npm'" \
        "py='$py'" \
        "restore='$restore'" \
        "settings='$settings'" \
        "meta='$meta'" \
        'for arg in "$@"; do' \
        '  case "$arg" in' \
        '  https://*.r2.dev/releases/*/prime-agent-*.tgz)' \
        '    "$py" "$restore" "$settings" "$meta" || exit 1' \
        '    exec "$real_npm" --allow-remote=all --dangerously-allow-all-scripts "$@"' \
        '    ;;' \
        '  esac' \
        done \
        'exec "$real_npm" "$@"' >$wrapper
    chmod +x $wrapper
    python3 -c 'import json, os, sys
settings, wrapper, meta, prefix = sys.argv[1:5]
created = not os.path.isfile(settings)
data = {}
if not created:
    with open(settings) as f:
        data = json.load(f) or {}
with open(meta, "w") as f:
    json.dump({"had": "npmCommand" in data, "orig": data.get("npmCommand"), "created": created}, f)
data["npmCommand"] = [wrapper, "--prefix", prefix]
os.makedirs(os.path.dirname(settings), exist_ok=True)
with open(settings, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
' $settings $wrapper $meta $prefix
    or begin
        rm -rf $wrapdir
        return 1
    end
    command prime-agent $argv
    set -l st $status
    python3 $restore $settings $meta
    rm -rf $wrapdir
    return $st
end

function __aup_run --description 'Run one update command and report its result'
    set -l label $argv[1]
    set -l color $argv[2]
    set -l binary $argv[3]
    set -l version_command $argv[4]
    set -l update_args $argv[5..-1]

    printf '\n'

    if not command -q $binary
        set_color brblack
        printf '%s skipped (not installed).\n' "$label"
        set_color normal
        return 0
    end

    set_color --bold $color
    printf ₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋₋\n
    printf '%s Update in Progress\n' "$label"
    printf ⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻⁻\n
    set_color normal
    printf '\n'

    if test "$binary" = prime-agent
        __aup_prime_agent_update $update_args
    else
        command $binary $update_args
    end
    set -l update_status $status

    printf '\n'

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
    set -l manifest $__fish_config_dir/agent-harnesses.toml

    if not test -r "$manifest"
        set_color red
        printf 'aup: harness manifest not found at %s\n' "$manifest"
        set_color normal
        return 1
    end

    if not command -q python3
        set_color red
        printf 'aup: python3 is required to read %s\n' "$manifest"
        set_color normal
        return 1
    end

    set -l lines (python3 -c '
import sys, tomllib
path = sys.argv[1]
try:
    with open(path, "rb") as f:
        data = tomllib.load(f)
except (OSError, tomllib.TOMLDecodeError) as e:
    print("ERR\t" + str(e))
    raise SystemExit(2)
rows = data.get("harness", [])
if not isinstance(rows, list):
    print("ERR\tharness must be an array of tables")
    raise SystemExit(2)
for i, h in enumerate(rows, 1):
    if not isinstance(h, dict):
        print("BAD\t" + str(i) + "\tnot a table")
        continue
    missing = [k for k in ("label", "color", "binary") if not str(h.get(k) or "").strip()]
    if missing:
        print("BAD\t" + str(i) + "\tmissing " + ", ".join(missing))
        continue
    version = str(h.get("version") or "-").strip() or "-"
    args = h.get("args", [])
    if args is None:
        args = []
    if isinstance(args, str):
        args = args.split()
    elif isinstance(args, list):
        args = [str(a) for a in args]
    else:
        print("BAD\t" + str(i) + "\targs must be a string or list")
        continue
    fields = [str(h["label"]).strip(), str(h["color"]).strip(), str(h["binary"]).strip(), version, *args]
    if any(("\t" in f or "\n" in f) for f in fields):
        print("BAD\t" + str(i) + "\tfield contains a tab or newline")
        continue
    print("OK\t" + "\t".join(fields))
' $manifest)
    set -l parse_status $status

    if test $parse_status -ne 0
        set_color red
        printf 'aup: bad manifest %s\n' "$manifest"
        for line in $lines
            printf '%s\n' "$line"
        end
        set_color normal
        return 1
    end

    set -l failed 0
    set -l tab (printf '\t')

    for line in $lines
        set -l fields (string split -- $tab $line)
        switch $fields[1]
            case BAD
                set_color red
                printf 'aup: harness %s: %s\n' $fields[2] $fields[3]
                set_color normal
                set failed 1
            case OK
                __aup_run $fields[2] $fields[3] $fields[4] $fields[5] $fields[6..-1]
                or set failed 1
        end
    end

    printf '\n'
    return $failed
end
