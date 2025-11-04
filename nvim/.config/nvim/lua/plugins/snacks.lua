return {
  {
    "folke/snacks.nvim",
    opts = {
      persistance = {
        need = 1,
      },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            layout = {
              layout = {
                position = "right",
              },
            },
          },
        },
      },
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "o",
              desc = "Find Session",
              action = function()
                require("persistence").select()
              end,
            },
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
