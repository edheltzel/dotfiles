# Restart the WindowServer on macOS --> This will log you out - macOS has a bug with multiple displays where the WindowServer will consume CPU and/or Memory. It is annoying.'
killws() {
  sudo killall -HUP WindowServer
}
