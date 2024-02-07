# Defined in - @ line 0
function upp --description 'upp =Update Packages w/Topgrade and does some cleanup'

    # Define variables for Node output
    set -l nodeIcon '󰎙 '
    set -l nodeVerb 'Node Version in use: '

    # Print Node version
    printf "%s" "$nodeIcon"
    set_color green --bold
    printf "%s" "$nodeVerb"
    set_color normal
    node --version
    set_color white

    # Run topgrade and clean up Homebrew
    topgrade
    printf '\n―― %s - Brew - Cleanup ―――――――――――――――――――――――――――――――――――――――――――――――――――\n' (date "+%H:%M:%S")
    set_color normal
    brew cleanup --prune=all
    set_color white

    # Prepare pnpm and yarn with Corepack
    printf '\n―― %s - pnpm - Corepack  ――――――――――――――――――――――――――――――――――――――――――――――――――――\n' (date "+%H:%M:%S")
    set_color normal
    corepack prepare pnpm@latest --activate
    pnpm update -g --latest
end
