#!/bin/sh
# Run after installing or reinstalling adihex/herdr-agent-icons.
# Usage: sh ~/.config/herdr/agent-icons/apply.sh [plugin-checkout]
set -eu
command -v patch >/dev/null
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ "$#" -eq 0 ]; then
  set -- "$script_dir"/../plugins/github/local.agent-icons-*
fi
if [ "$#" -ne 1 ] || [ ! -f "$1/icons.conf" ]; then
  printf '%s\n' 'Expected one installed agent-icons checkout; pass its path explicitly.' >&2
  exit 1
fi
plugin_dir=$1
patch_file=$script_dir/omp.patch
if patch --dry-run --batch --forward -p1 -d "$plugin_dir" < "$patch_file" >/dev/null 2>&1; then
  patch --batch --forward -p1 -d "$plugin_dir" < "$patch_file"
elif patch --dry-run --batch --reverse -p1 -d "$plugin_dir" < "$patch_file" >/dev/null 2>&1; then
  printf '%s\n' 'omp icon patch is already applied.'
else
  printf '%s\n' 'icons.conf has changed; patch not applied. Review omp.patch against the installed version.' >&2
  exit 1
fi
printf '%s\n' 'The running reporter picks up the mapping on its next refresh.'
