-- https://github.com/eldritch-theme/eldritch.nvim
-- I also contrubite to the vscode theme https://github.com/eldritch-theme/vscode
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
