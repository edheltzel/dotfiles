return {
  -- frontmatter support
  {
    "goropikari/front-matter.nvim",
    opts = {},
    build = "make setup",
  },
  --
  -- ghostty terminal config
  {
    "ghostty",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles",
    lazy = false,
  },
  --
  -- nunjucks from jinja lsp
  "neovim/nvim-lspconfig",
  dependencies = {},
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim" },
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      -- keybindings etc.
      vim.filetype.add({
        extension = {
          njk = "html.jinja",
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local jinja_lsp = {
        capabilities = capabilities,
        filetypes = { "nunjucks", "njk", "jinja", "html.jinja" },
        root_markers = { "package.json", ".git" },
        settings = {
          template_extensions = { "njk", "html.jinja" },
          templates = "./src/pages",
          backend = { "./src" },
          lang = "python",
        },
      }
      -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- For some reason `require("lspconfig")["jinja_lsp"] doesn't quite work right in v0.12 if neovim :shrug:`
      vim.lsp.config["jinja_lsp"] = jinja_lsp
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_enable = true,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      local disable_fn = function(lang, bufnr) -- Disable in large C++ buffers
        local filetypes = lang == "TelescopePrompt" or lang == "netrw" or lang == "markdown"
        return filetypes or vim.api.nvim_buf_line_count(bufnr) > 2000
      end

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        disable = disable_fn,
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = disable_fn, -- list of language that will be disabled

          -- *THIS IS THE IMPORTANT PART!* By default, this is false, and you won't get jinja highlighting.
          additional_vim_regex_highlighting = true,
        },
      })
    end,
  },
}
