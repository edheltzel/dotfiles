function flushdns -d "Flushes macOS DNS cache"
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
end
