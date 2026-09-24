function yazi --wraps yazi --description "yazi with responsive 2/3-column layout"
    if test $COLUMNS -ge 120
        command yazi $argv
        return
    end

    # Narrow viewport: symlink full config, override just yazi.toml for 2-column layout
    set tmpdir (mktemp -d)
    for f in ~/.config/yazi/*
        ln -s $f $tmpdir/(basename $f)
    end
    ln -sf ~/.config/yazi-narrow/yazi.toml $tmpdir/yazi.toml

    YAZI_CONFIG_HOME=$tmpdir command yazi $argv

    rm -rf $tmpdir
end
