return {
  {
    "folke/snacks.nvim",
    opts = {
      persistance = {
        need = 1,
      },
      --
      picker = {
        sources = {
          explorer = {
            layout = {
              layout = { position = "right" },
            },
          },
          -- TODO: update keymaps to match VSpaceCode
          files = {
            hidden = true,
            ignored = true,
            exclude = {
              ".DS_Store",
              "**/.git/*",
              "**/node_modules/*",
            },
          },
        },
        hidden = true,
        ignored = true,
      },
      --
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "o", desc = "Find Session", action = ":SessionSearch" },
            { icon = "⊙ ", key = "d", desc = "DOTFILES", action = ":cd ~/.dotfiles | :e ." },
            { icon = " ", key = "v", desc = "NOE.ED", action = ":cd ~/.dotfiles/nvim/.config/nvim | :e ." },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
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
  },
}
