# theme_colors.fish — theme-aware fish color overrides.
#
# Fish 4.3 auto-generates `fish_frozen_theme.fish` with globals tuned for
# dark backgrounds. Its autosuggestion color (#3f4964) disappears into
# committed text on light backgrounds like Rose Pine Dawn.
#
# This file sorts AFTER `fish_frozen_theme.fish` in conf.d, so our
# `set --global` overrides the frozen values for light themes only.
# Dark themes keep whatever the frozen file set.

set -l current_theme_file $HOME/.config/theme-switcher/current

# Light themes need a muted ghost-text color that still reads against a
# cream/light background. Add future light themes here.
set -l light_themes rose-pine-dawn

if test -r $current_theme_file
    set -l current (cat $current_theme_file)
    if contains -- $current $light_themes
        # Rose Pine Dawn `muted` — canonical "subdued" swatch on the cream base.
        set --global fish_color_autosuggestion 9893a5
    end
end
