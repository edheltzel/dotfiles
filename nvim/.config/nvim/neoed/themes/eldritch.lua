return {
  name = 'eldritch',
  src = 'https://github.com/eldritch-theme/eldritch.nvim',
  needsSetup = true,
  setup = function()
    require('eldritch').setup({
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      hide_inactive_statusline = false,
      dim_inactive = true,
      lualine_bold = true
    })
  end
}
