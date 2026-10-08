return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "astro", "css" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.astro = {}

      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@astrojs/ts-plugin",
              location = vim.env.MASON .. "/packages/" .. "astro-language-server" .. "/node_modules/@astrojs/ts-plugin",
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      }
    end,
  },

  -- Astro formatting is NOT handled by Vite+: Oxfmt (vp fmt) does not support
  -- .astro files. Formatting falls back to the astro language server above
  -- (best-effort; reformats only when prettier-plugin-astro is available in the
  -- project). Linting/type-info still come from oxlint + vtsls.
}
