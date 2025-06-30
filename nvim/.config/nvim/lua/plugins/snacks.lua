return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
              hidden = { "input" },
              layout = { position = "right" },
            },
          },
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
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = " ",
              key = "d",
              desc = "Dotfiles",
              action = ":cd ~/.dotfiles | :e .",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
}
