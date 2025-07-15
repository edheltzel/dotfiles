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

    -- Custom colours
    neo_ed.normal.a.fg = "#454E7D"
    neo_ed.normal.a.bg = "#212337"
    neo_ed.normal.b.fg = "#454E7D"
    neo_ed.normal.b.bg = "#212337"

    neo_ed.insert.a.fg = "#37F499"
    neo_ed.insert.a.bg = "#212337"
    neo_ed.insert.b.fg = "#454E7D"
    neo_ed.insert.b.bg = "#212337"

    neo_ed.visual.a.fg = "#A48CF2"
    neo_ed.visual.a.bg = "#212337"
    neo_ed.visual.b.fg = "#454E7D"
    neo_ed.visual.b.bg = "#212337"

    neo_ed.replace.a.fg = "#F16c75"
    neo_ed.replace.a.bg = "#212337"
    neo_ed.replace.b.fg = "#454E7D"
    neo_ed.replace.b.bg = "#212337"

    neo_ed.command.a.fg = "#F265B5"
    neo_ed.command.a.bg = "#212337"
    neo_ed.command.b.fg = "#454E7D"
    neo_ed.command.b.bg = "#212337"

    neo_ed.inactive.b.fg = "#454E7D"
    neo_ed.inactive.b.bg = "#212337"

    neo_ed.normal.c.fg = "#454E7D"
    neo_ed.normal.c.bg = "#212337"

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
          { "location", separator = { left = "", right = " " }, icon = "" },
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
