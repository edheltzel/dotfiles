--
-- lualine.lua
--
-- Custom status line
--

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    -- Custom Lualine component to show attached language server
    local clients_lsp = function()
      local bufnr = vim.api.nvim_get_current_buf()

      local clients = vim.lsp.get_clients()
      if next(clients) == nil then
        return ""
      end

      local c = {}
      for _, client in pairs(clients) do
        table.insert(c, client.name)
      end
      return " " .. table.concat(c, "|")
    end

    local neo_ed = require("lualine.themes.eldritch")

    local colors = {
      bg = "#212337",
      fg = "#454E7D",
      gray = "#586089",
      green = "#37F499",
      purple = "#A48CF2",
      red = "#F16c75",
      magenta = "#F265B5",
    }
    -- Custom colors
    neo_ed.normal.a.fg = colors.gray
    neo_ed.normal.a.bg = colors.bg
    neo_ed.normal.b.fg = colors.fg
    neo_ed.normal.b.bg = colors.bg

    neo_ed.insert.a.fg = colors.green
    neo_ed.insert.a.bg = colors.bg
    neo_ed.insert.b.fg = colors.fg
    neo_ed.insert.b.bg = colors.bg

    neo_ed.visual.a.fg = colors.purple
    neo_ed.visual.a.bg = colors.bg
    neo_ed.visual.b.fg = colors.fg
    neo_ed.visual.b.bg = colors.bg

    neo_ed.replace.a.fg = colors.red
    neo_ed.replace.a.bg = colors.bg
    neo_ed.replace.b.fg = colors.fg
    neo_ed.replace.b.bg = colors.bg

    neo_ed.command.a.fg = colors.magenta
    neo_ed.command.a.bg = colors.bg
    neo_ed.command.b.fg = colors.fg
    neo_ed.command.b.bg = colors.bg

    neo_ed.terminal.a.fg = colors.magenta
    neo_ed.terminal.a.bg = colors.bg
    neo_ed.terminal.b.fg = colors.fg
    neo_ed.terminal.b.bg = colors.bg

    neo_ed.inactive.b.fg = colors.fg
    neo_ed.inactive.b.bg = colors.bg

    neo_ed.normal.c.fg = colors.fg
    neo_ed.normal.c.bg = colors.bg

    require("lualine").setup({
      options = {
        theme = neo_ed,
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "Outline" },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "", right = "" }, icon = "" },
        },
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          "filename",
        },
        lualine_c = {
          {
            "branch",
            icon = "",
          },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            colored = false,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            update_in_insert = true,
          },
        },
        lualine_y = { clients_lsp },
        lualine_z = {
          { "location", separator = { left = "", right = "" }, icon = "" },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      extensions = { "toggleterm", "trouble" },
    })
  end,
}
