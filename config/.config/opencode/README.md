# OpenCode Configuration

Personal OpenCode configuration with custom commands, plugins, and themes.

## Structure

- `opencode.jsonc` - Main configuration (model, MCP servers, theme)
- `command/` - Custom slash commands (`/commit`, `/commit-push`)
- `plugin/` - Autoloaded plugins (audio feedback notifications)
- `themes/` - Custom color themes (Eldritch variants)

## Plugins

Plugins in the `plugin/` directory are **automatically loaded** by OpenCode.
There is no need to register them in `opencode.jsonc`.

See: https://opencode.ai/docs/plugins#location
