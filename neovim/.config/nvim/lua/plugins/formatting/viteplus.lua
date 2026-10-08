-- Vite+ / Oxfmt formatting.
-- `vp fmt` (forwards to Oxfmt) is the source of truth for JS/TS/React/JSON/CSS
-- formatting, replacing Biome. LazyVim's autoformat drives format-on-save through
-- these conform formatters.
--
-- Notes:
--   * vp is invoked by absolute path because the interactive `vp` is a shell
--     function that Neovim's (non-interactive) environment cannot resolve.
--   * `vp fmt` requires a workspace (package.json/vite.config.*); require_cwd makes
--     the formatter no-op outside one instead of erroring.
--   * Oxfmt does not support .astro yet, so astro is intentionally not wired here
--     and falls back to LazyVim's astro formatter.

local vp = vim.fn.expand("~/.vite-plus/bin/vp")

local viteplus_filetypes = {
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "scss",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local util = require("conform.util")
      opts.formatters = opts.formatters or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      opts.formatters.viteplus_fmt = {
        command = vp,
        args = { "fmt", "--stdin-filepath", "$FILENAME" },
        stdin = true,
        cwd = util.root_file({ "vite.config.ts", "vite.config.mts", "vite.config.js", "package.json" }),
        require_cwd = true,
      }

      for _, ft in ipairs(viteplus_filetypes) do
        opts.formatters_by_ft[ft] = { "viteplus_fmt" }
      end
    end,
  },
}
