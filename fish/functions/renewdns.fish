function renewdns --description 'Renews the DNS lease by disabling and re-enabling the network adapter on macOS'
    set sudo_pass (sudo -p "Password: " -S echo)
    set result (echo $sudo_pass | sudo -S ifconfig en0 down; and sleep 1; echo $sudo_pass | sudo -S ifconfig en0 up)
    if test $status -eq 0
        echo "DNS lease successfully renewed"
    else
        echo "Failed to renew DNS lease"
    end
end
