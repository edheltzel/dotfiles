# OpenCode Configuration

Personal OpenCode configuration with custom commands, plugins, and themes.

## Hey Future Ed

Just in case you forget, plugins in the `plugin/` directory are **automatically loaded** by OpenCode.
There is no need to register them in `opencode.jsonc`.

See: https://opencode.ai/docs/plugins#location

## Structure

- `opencode.jsonc` - Main configuration (model, MCP servers, theme)
- `command/` - Custom slash commands (`/commit`, `/commit-push`, etc.)
- `plugin/` - Autoloaded plugins (audio feedback notifications, etc.)
- `themes/` - Custom color themes (Eldritch variants)
