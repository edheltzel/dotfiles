return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "o", desc = "Find Session", action = ":SessionSearch" },
            { icon = "⊙ ", key = "d", desc = "DOTFILES", action = ":cd ~/.dotfiles | :e ." },
            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
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
