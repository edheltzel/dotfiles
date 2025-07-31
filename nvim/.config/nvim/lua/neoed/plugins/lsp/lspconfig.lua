return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local km = require("neoed.core.keymap-utils")
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local bufnr = ev.buf

        -- LSP navigation keymaps
        km.buffer_map(bufnr, "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references")
        km.buffer_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        km.buffer_map(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
        km.buffer_map(bufnr, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations")
        km.buffer_map(bufnr, "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions")

        -- LSP code actions
        km.buffer_map(bufnr, { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
        km.buffer_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")

        -- Diagnostics
        km.buffer_map(bufnr, "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")
        km.buffer_map(bufnr, "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
        km.buffer_map(bufnr, "n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
        km.buffer_map(bufnr, "n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")

        -- Documentation and utilities
        km.buffer_map(bufnr, "n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
        km.buffer_map(bufnr, "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("svelte", {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("eslint", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}
