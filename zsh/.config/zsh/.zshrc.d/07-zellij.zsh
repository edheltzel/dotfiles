# Zellij integration — auto-rename tabs based on CWD (≈ zellij.fish)
# Uses Zsh chpwd hook (equivalent to Fish --on-variable PWD)

if [[ -n "$ZELLIJ" ]]; then
  _zellij_update_tabname() {
    local tab_name git_root repo
    if [[ "$PWD" == "$HOME" ]]; then
      tab_name="~"
    elif git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
      repo=$(basename "$git_root")
      if [[ "$PWD" == "$git_root" ]]; then
        tab_name="$repo"
      else
        tab_name="$repo/${PWD#$git_root/}"
      fi
    else
      tab_name=$(basename "$PWD")
    fi
    command zellij action rename-tab "$tab_name" 2>/dev/null &!
  }

  chpwd_functions+=(_zellij_update_tabname)

  # Set tab name on shell startup
  _zellij_update_tabname
fi
