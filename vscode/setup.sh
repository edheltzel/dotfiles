#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.vscode-insiders/custom)"
# DESTINATION="$(realpath ~/.vscode/custom)" ## Regular VSCode

info "Setting up Visual Studio Code Insiders..."

substep_info "Creating Visual Studio Code Insiders folders..."
mkdir -p "$DESTINATION"

find * -not -name "$(basename ${0})" -type f | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished setting up Visual Studio Code Insiders"
