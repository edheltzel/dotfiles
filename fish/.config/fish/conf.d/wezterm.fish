# wezterm.fish: WezTerm shell integration.
#
# Emits OSC 7 on every directory change so WezTerm can track the pane's
# current working directory without doing a live process-tree walk.
#
# Why this matters: pane:get_current_working_dir() in WezTerm Lua config
# is documented as "not cheap to compute" — it does a syscall-based walk
# of the pane's process tree. With OSC 7, the shell proactively tells
# WezTerm the CWD, which is then a free pre-computed value lookup.
#
# Guarded on $TERM_PROGRAM so non-WezTerm terminals (Ghostty, etc.)
# aren't bothered with escape sequences they don't use.

if test "$TERM_PROGRAM" = "WezTerm"
    function __wezterm_osc7 --on-variable PWD --description 'Emit OSC 7 for WezTerm CWD tracking'
        # Format: ESC ] 7 ; file:// HOST URL-encoded-path ESC \
        printf '\e]7;file://%s%s\e\\' (hostname) (string escape --style=url -- "$PWD")
    end

    # Emit once on shell startup so WezTerm has the initial CWD
    __wezterm_osc7
end
