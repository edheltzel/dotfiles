return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not opts.servers then
        opts.servers = {}
      end

      -- Configure jinja-lsp for Django/Jinja templates
      opts.servers.jinja_lsp = {
        filetypes = { "jinja", "htmldjango", "html.jinja" },
      }

      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure parsers are installed
      if not opts.ensure_installed then
        opts.ensure_installed = {}
      end
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "htmldjango", "yaml" })
      end

      return opts
    end,
  },
}
