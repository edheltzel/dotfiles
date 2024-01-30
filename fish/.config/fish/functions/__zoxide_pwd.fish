function __zoxide_pwd
    if test "$_ZO_RESOLVE_SYMLINKS" = 1
        builtin pwd -P
    else
        builtin pwd -L
    end
end
