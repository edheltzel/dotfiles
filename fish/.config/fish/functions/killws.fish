# This will log you out - macOS has a bug with multiple displays where the WindowServer will consume CPU and/or Memory. It is annoying.'
function killws --description 'Restart the WindowServer on macOS'
    sudo killall -HUP WindowServer
end
