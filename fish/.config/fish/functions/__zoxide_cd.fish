function __zoxide_cd
    __zoxide_cd_internal $argv
    if test "$_ZO_ECHO" = 1
        __zoxide_pwd
    end
end
