# Defined in - @ line 0
function upp --description 'upp =Update Packages w/Topgrade and does some cleanup'

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
