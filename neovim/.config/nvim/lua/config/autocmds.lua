-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
local api = vim.api

-- highlight YAML frontmatter
api.nvim_create_autocmd("FileType", {
  pattern = { "htmldjango", "jinja", "htmldjango", "njk", "nunjucks", "twig", "liquid" },
  callback = function()
    vim.cmd([[
    syntax include @YAML syntax/yaml.vim
    syntax region yamlFrontmatter start=/^---$/ end=/^---$/ keepend contains=@YAML
    ]])
  end,
})

-- open help in a vertical split
api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- resize splits automatically when terminal window is resized
api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- disables auto comment on new line
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- dotenv syntax highlighting
api.nvim_create_autocmd("BufRead", {
  group = api.nvim_create_augroup("dotenv_ft", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- Ghostty config uses `key = value` with `#` comments and quoted strings — treat as TOML
vim.filetype.add({
  pattern = {
    [".*/ghostty/config"] = "toml",
    [".*/ghostty/themes/.*"] = "toml",
    [".*/ghostty/colors/.*"] = "toml",
  },
})

-- Configure markdownlint-cli2 to use global config
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.md",
  once = true,
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok and lint.linters["markdownlint-cli2"] then
      lint.linters["markdownlint-cli2"].args = {
        "--config",
        vim.fn.expand("~/.config/markdownlint-cli2/config.yaml"),
      }
    end
  end,
})

------------------- LUALINE -------------------
---- Auto-refresh lualine when colorscheme changes
-- This ensures NEOED theme adapts to the colorscheme automatically
api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("lualine_colorscheme_refresh", { clear = true }),
  pattern = "*",
  callback = function(args)
    -- The colorscheme name is passed in args.match
    local colorscheme = args.match

    -- Skip if lualine hasn't been loaded yet (initial startup)
    -- This prevents errors when ColorScheme fires before plugins are fully initialized
    if not package.loaded["lualine"] then
      return
    end

    -- Clear cached modules so they reload with new colorscheme
    package.loaded["plugins.ui.lualine.neoed"] = nil
    package.loaded["plugins.ui.lualine.eldritch"] = nil
    package.loaded["plugins.ui.lualine.rose-pine"] = nil
    package.loaded["plugins.ui.lualine.catppuccin"] = nil
    package.loaded["plugins.ui.lualine.vesper"] = nil
    package.loaded["plugins.ui.lualine.dracula"] = nil
    package.loaded["plugins.ui.lualine.gruvbox"] = nil

    -- Refresh lualine with new theme, passing the colorscheme name
    local ok, lualine = pcall(require, "lualine")
    if ok then
      local neoEdTheme, _ = require("plugins.ui.lualine.neoed").setup(colorscheme)
      lualine.setup({ options = { theme = neoEdTheme } })
    end
  end,
})

-- Manual command to refresh lualine theme
api.nvim_create_user_command("LualineRefresh", function()
  -- Clear cached modules
  package.loaded["plugins.ui.lualine.neoed"] = nil
  package.loaded["plugins.ui.lualine.eldritch"] = nil
  package.loaded["plugins.ui.lualine.rose-pine"] = nil
  package.loaded["plugins.ui.lualine.catppuccin"] = nil
  package.loaded["plugins.ui.lualine.vesper"] = nil
  package.loaded["plugins.ui.lualine.dracula"] = nil
  package.loaded["plugins.ui.lualine.gruvbox"] = nil

  -- Reload lualine
  local ok, lualine = pcall(require, "lualine")
  if ok then
    local neoEdTheme, _ = require("plugins.ui.lualine.neoed").setup()
    lualine.setup({ options = { theme = neoEdTheme } })
    vim.notify("Lualine theme refreshed", vim.log.levels.INFO)
  else
    vim.notify("Failed to refresh lualine", vim.log.levels.ERROR)
  end
end, { desc = "Refresh lualine theme to match current colorscheme" })

api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("neoed_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- exclude wrapping of YAML frontmatter
api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
  group = api.nvim_create_augroup("neoed_frontmatter_nowrap", { clear = true }),
  pattern = { "*.md", "*.mdx" },
  callback = function()
    local row = api.nvim_win_get_cursor(0)[1]
    local in_fm = row > 1 and vim.fn.getline(1) == "---"
    for i = 2, row - 1 do
      if not in_fm then
        break
      end
      if vim.fn.getline(i) == "---" then
        in_fm = false
      end
    end
    vim.bo.textwidth = in_fm and 0 or vim.go.textwidth
  end,
})
