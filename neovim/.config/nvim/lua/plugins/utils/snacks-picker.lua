return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      -- set to true to disable Snacks picker from opening on startup
      replace_netrw = true,
    },
    picker = {
      layout = "default",
      sources = {
        files = {
          hidden = true,
        },
        grep = {
          hidden = true, -- search hidden files
        },
        explorer = {
          hidden = true,
          ignored = true,
          trash = true,
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
}
