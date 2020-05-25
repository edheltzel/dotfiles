#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/ranger)"

info "Setting up Ranger File Manager..."
find . -name "*.conf" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

# might consider using submodule
git clone https://github.com/alexanderjeurissen/ranger_devicons "$DESTINATION"/plugins/ranger_devicons


clear_broken_symlinks "$DESTINATION"

success "Finished configuring Ranger."
