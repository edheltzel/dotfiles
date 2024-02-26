# Disable and re-enable the Ethernet network interface
flashEthernet() {
  sudo_pass=$(sudo -p "Password: " -S echo)

  interface="Ethernet"
  result=$(
    echo $sudo_pass | sudo -S networksetup -setnetworkserviceenabled $interface off
    sleep 1
    echo $sudo_pass | sudo -S networksetup -setnetworkserviceenabled $interface on
  )
  if [ $? -eq 0 ]; then
    echo "$interface successfully disabled and will be re-enabled shortly."
  else
    echo "Failed to disable and re-enable $interface."
  fi
}
