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
# Guards:
#   $TERM_PROGRAM = "WezTerm" — skip when running in Ghostty/iTerm/etc.
#   -z $TMUX              — skip when running inside tmux (tmux inherits
#                           TERM_PROGRAM from its parent but swallows OSC 7,
#                           so emitting it is a wasted printf on every cd).
#   -z $ZELLIJ            — same reasoning for zellij.

if test "$TERM_PROGRAM" = "WezTerm"; and test -z "$TMUX"; and test -z "$ZELLIJ"
    function __wezterm_osc7 --on-variable PWD --description 'Emit OSC 7 for WezTerm CWD tracking'
        # Format: ESC ] 7 ; file:// URL-encoded-host URL-encoded-path ESC \
        # Both host and path are URL-encoded for robustness against exotic
        # hostnames (spaces, unicode) — Fish's string escape --style=url
        # applies RFC 3986 percent-encoding.
        printf '\e]7;file://%s%s\e\\' \
            (string escape --style=url -- (hostname)) \
            (string escape --style=url -- "$PWD")
    end

    # Emit once on shell startup so WezTerm has the initial CWD
    __wezterm_osc7
end
