#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"
CONFIGDEST="$(realpath ~/.config/tmux)"

info "Setting up Tmux..."

git clone https://github.com/tmux-plugins/tpm "$CONFIGDEST/plugins/tpm"


find . -name ".tmux.conf" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

find * -type f \( -iname \*sh* -o -iname \*remote* \)  | while read fn; do
    symlink "$SOURCE/$fn" "$CONFIGDEST/$fn"
done

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
info  "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.config/tmux/plugins"
"$CONFIGDEST"/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

clear_broken_symlinks "$CONFIGDEST"

success "Tmux is now configured."
