# Lazy-load zoxide on first use
if status is-interactive
    function __lazy_zoxide
        functions -e __lazy_zoxide z zi
        zoxide init fish | source
    end
    function z
        __lazy_zoxide
        __zoxide_z $argv
    end
    function zi
        __lazy_zoxide
        __zoxide_zi $argv
    end
end
