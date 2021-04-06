# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

function l; command exa -Flagh --sort name --git --icons --group-directories-first $argv; end
function ll; command exa -Flagh --git --icons --group-directories-first --sort modified $argv; end
function la; command exa -Fla --icons; end
function tree; command exa --tree --icons $argv; end
function ls; command exa $argv; end
function cll; command clear; and exa -Flah --icons --sort modified $argv; end
