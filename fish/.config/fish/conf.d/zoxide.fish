# Lazy-load zoxide on first use
if status is-interactive
    function __lazy_zoxide
        functions -e __lazy_zoxide z zi
        zoxide init fish | source
    end
    function z
        __lazy_zoxide
        z $argv
    end
    function zi
        __lazy_zoxide
        zi $argv
    end
end
