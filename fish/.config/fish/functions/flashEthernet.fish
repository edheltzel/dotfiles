function flashEthernet --description 'Disable and re-enable the Ethernet network interface'
    set -l sudo_pass (sudo -p "Password: " -S echo)

    set -l interface Ethernet
    set result (echo $sudo_pass | sudo -S networksetup -setnetworkserviceenabled $interface off; and sleep 1; echo $sudo_pass | sudo -S networksetup -setnetworkserviceenabled $interface on)
    if test $status -eq 0
        echo "$interface successfully disabled and will re-enabled shortly."
    else
        echo "Failed to disable and re-enable $interface."
    end
end
