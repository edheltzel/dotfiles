# Fix Zellij Status Bar CWD to Update Dynamically

## Context

The zjstatus status bar shows the current working directory using a `command_cwd` widget that runs `bash -c 'basename "$(pwd)"'` on a 5-second interval. This command runs in the zjstatus plugin's process context, not the active pane's shell, so it always shows the directory where Zellij was launched — never updating when you `cd` or switch tabs.

zjstatus has no native `{cwd}` widget. The two mechanisms available are:
- `command_*` — polls a shell command on interval (current, broken for CWD)
- `pipe_*` — receives data pushed from the shell via `zellij pipe` (event-driven, instant)

The fix: use the **pipe widget** so Fish pushes the actual CWD to zjstatus on every prompt.

## Changes

### 1. Create Fish function: `fish/.config/fish/conf.d/zellij.fish`

A new conf.d file that, when inside a Zellij session (`$ZELLIJ` is set), hooks into `fish_prompt` to push the current directory basename to zjstatus via pipe:

```fish
if status is-interactive; and set -q ZELLIJ
    function __zellij_update_cwd --on-event fish_prompt
        command zellij pipe --plugin zjstatus "zjstatus::pipe::cwd::(basename $PWD)"
    end
end
```

Key details:
- Only activates inside Zellij sessions (`set -q ZELLIJ`)
- Only in interactive shells
- Fires on every prompt (covers `cd`, new tabs, subshell returns)
- Uses `basename $PWD` to show just the directory name (matching current behavior)

### 2. Update zjstatus layout: `config/.config/zellij/layouts/default.kdl`

Replace the `command_cwd` block (lines 185-189) with a `pipe_cwd` widget:

```diff
-                // --- Current working directory ---
-                command_cwd_command     "bash -c 'basename \"$(pwd)\"'"
-                command_cwd_format      "#[bg=#171928,fg=#F265B5] 󰉋 {stdout} "
-                command_cwd_interval    "5"
-                command_cwd_rendermode  "static"
+                // --- Current working directory (pushed from shell via pipe) ---
+                pipe_cwd_format      "#[bg=#171928,fg=#F265B5] 󰉋 {stdout} "
```

And update `format_right` to reference `{pipe_cwd}` instead of `{command_cwd}`:

```diff
-                format_right  "{command_cwd}{command_git_branch}#[bg=#171928,fg=#AD4E54]  {session}"
+                format_right  "{pipe_cwd}{command_git_branch}#[bg=#171928,fg=#AD4E54]  {session}"
```

## Files Modified

- `fish/.config/fish/conf.d/zellij.fish` — **new file**, Fish prompt hook
- `config/.config/zellij/layouts/default.kdl` — lines 122, 185-189

## Verification

1. Restow: `just stow fish && just stow config`
2. Start a new Zellij session (or restart existing)
3. Verify CWD shows in status bar
4. `cd /tmp` — status bar should show `tmp` immediately (no 5s delay)
5. Open a new tab, `cd ~/Projects` — status bar should show `Projects`
6. Switch between tabs — CWD should update to each tab's directory
