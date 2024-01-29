function rmds -d "Remove .DS_Store files either recursively in a directory or only in the current directory"
    switch $argv[1]
        case -r or --recursive
            set cwd $argv[2]
            find $cwd -type f -name .DS_Store -delete
        case -c or --current
            set cwd .
            find $cwd -maxdepth 1 -type f -name .DS_Store -delete
        case '*'
            echo "Usage: rmds [-r|--recursive /path/to/directory] [-c|--current]"
    end
end
