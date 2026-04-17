# Lazy-load zoxide on first use.
# --no-cmd: zoxide only defines __zoxide_* internals, so it does NOT overwrite
# our z / zi wrappers with its own `alias z=__zoxide_z` (which would skip __list_dir).
if status is-interactive
    function __lazy_zoxide
        functions -q __zoxide_z; and return
        zoxide init fish --no-cmd | source
    end
    function z
        __lazy_zoxide
        __zoxide_z $argv; and __list_dir
    end
    function zi
        __lazy_zoxide
        __zoxide_zi $argv; and __list_dir
    end
end
