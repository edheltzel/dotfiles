function renewdns --description 'Renews the DNS lease by disabling and re-enabling the network adapter on macOS'
  # Request the user to run the script with sudo if not already running as root
  if not [ (id -u) -eq 0 ]
      echo "Please run this script with sudo."
      return 1
  end

  # Now that we're running with elevated privileges, we can run the commands without sudo
  ifconfig en0 down
  sleep 1  # Optional: give the network interface a moment to go down
  ifconfig en0 up
end
