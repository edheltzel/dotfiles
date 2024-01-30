function freespace -d "Erases purgeable disk space with 0s on the selected disk"
    if test -z $argv[1]
        echo "Usage: freespace <disk>"
        echo "Example: freespace /dev/disk1s1"
        echo
        echo "Possible disks:"
        df -h | awk 'NR == 1 || /^\/dev\/disk/'
        return 1
    end

    echo "Cleaning purgeable files from disk: $argv[1] ...."
    diskutil secureErase freespace 0 $argv[1]
end

function _freespace
    set -l disks (string split "\n" (df | awk '/^\/dev\/disk/{ printf $1 ":"; for (i=9; i<=NF; i++) printf $i FS; print "" }'))
    for disk in $disks
        echo $disk
    end
end

complete -f -c freespace -n _freespace
