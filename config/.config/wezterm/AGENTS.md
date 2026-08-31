# wezterm — modular terminal configuration

## Purpose

Own the modular Lua configuration for WezTerm, including rendering, tabs, status, keymaps, and startup workspaces.

## Ownership

- `wezterm.lua` orchestrates module setup and event registration.
- `configuration.lua` owns terminal, rendering, font, window, pane, and tab-bar options.
- `statusbar.lua`, `tabs.lua`, and `theme.lua` own visible status and tab rendering.
- `keymaps.lua` and `workspaces.lua` own navigation and startup topology.
- `README.md` documents user-facing behavior and controls.

## Local Contracts

- Use `wezterm.home_dir` for home-relative assets and tools; do not hardcode a user home path.
- Keep synchronous work out of per-tick rendering where possible. Bound unavoidable subprocess calls and cache their results.
- Render native WezTerm topology by default. While local Herdr is foreground, `statusbar.lua` may use cached `herdr api snapshot` state; any unavailable, remote, invalid, or timed-out state must fall back to native topology.
- Preserve leader and active key-table status precedence over workspace labels.

## Work Guidance

- Match the existing module style, including snake_case local names and small event-focused helpers.
- Update `README.md` when visible status, tab, workspace, or keybinding behavior changes.
- Preserve unrelated user customization in `configuration.lua`, `theme.lua`, and workspace names.

## Verification

- Run `luac -p` on changed Lua modules.
- Load the config with `wezterm --config-file config/.config/wezterm/wezterm.lua show-keys`.
- Reload or launch WezTerm and exercise the affected runtime path; Herdr status changes require a live local Herdr pane.

## Child DOX Index
