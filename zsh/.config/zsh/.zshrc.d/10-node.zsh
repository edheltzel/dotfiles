# Node via Vite+ shims (≈ config.fish). 03-brew.zsh re-prepends Homebrew, so move the shims back in front.
path=($HOME/.vite-plus/bin $path)

npx() { command bunx "$@"; }  # npx → bunx (matching Fish config)
