# Navigation
function ..    ; cd .. ; end
function ...   ; cd ../.. ; end
function ....  ; cd ../../.. ; end
function ..... ; cd ../../../.. ; end

function ls; command exa --group-directories-first; end
function l; command exa -Flah --sort name --group-directories-first ; end
function ll; command exa -Flagh --git --group-directories-first --sort modified ; end
function la; command exa -Fla; end
function lm; command exa -Flagh --git --group-directories-first --sort modified; end
function ld; command exa -Flgh --git --group-directories-first; end
function ltd; command exa --tree -D; end
function tree; command exa --tree; end
function cll; command clear; and exa -Flah --sort modified; end
