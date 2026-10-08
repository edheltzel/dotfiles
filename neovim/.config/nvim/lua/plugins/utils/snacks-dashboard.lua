local function open_project(path)
  vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.expand(path)))
  local ok, persistence = pcall(require, "persistence")
  if ok and vim.fn.filereadable(persistence.current()) == 1 then
    persistence.load()
  else
    vim.cmd("enew")
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        keys = {
          {
            icon = "󱈅 ",
            key = "o",
            desc = "Find Session",
            action = function()
              require("persistence").select()
            end,
          },
          {
            icon = "⊙ ",
            key = "d",
            desc = "DOTFILES",
            action = function()
              open_project("~/.dotfiles")
            end,
          },
          {
            icon = "\u{E6AE} ",
            key = "v",
            desc = "NEO.ED",
            action = function()
              open_project("~/.dotfiles/neovim/.config/nvim")
            end,
          },
          {
            icon = "\u{F082E} ",
            key = "n",
            desc = "FieldNotes✱",
            action = function()
              open_project("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱")
            end,
          },
          { icon = "󰩈 ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
        ███╗   ██╗███████╗ ██████╗    ███████╗██████╗
        ████╗  ██║██╔════╝██╔═══██╗   ██╔════╝██╔══██╗
        ██╔██╗ ██║█████╗  ██║   ██║   █████╗  ██║  ██║
        ██║╚██╗██║██╔══╝  ██║   ██║   ██╔══╝  ██║  ██║
        ██║ ╚████║███████╗╚██████╔╝██╗███████╗██████╔╝
        ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝╚══════╝╚═════╝ ]],
      },
    },
  },
}
