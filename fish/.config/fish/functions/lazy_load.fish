function lazy_load -a tool init_cmd
    function $tool -V tool -V init_cmd
        functions -e $tool
        eval $init_cmd
        $tool $argv
    end
end
