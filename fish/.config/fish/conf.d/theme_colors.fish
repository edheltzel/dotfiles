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

# Light themes each need their own swatches that read against a cream/light
# background. The frozen file's values are tuned for dark backgrounds, so we
# override per-theme here. Add future light themes as new `case` branches.
if test -r $current_theme_file
    set -l current (cat $current_theme_file)
    switch $current
        case rose-pine-dawn
            # Rose Pine Dawn `muted` — canonical "subdued" swatch on the cream base.
            set --global fish_color_autosuggestion 9893a5
        case catppuccin-latte
            # Catppuccin Latte `yellow` — darker/more saturated than the frozen
            set --global fish_color_option df8e1d
    end
end
