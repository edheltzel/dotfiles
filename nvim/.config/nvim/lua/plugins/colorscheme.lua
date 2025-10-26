return {
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("eldritch")
    end,
  },
}
