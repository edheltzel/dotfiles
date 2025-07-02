return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
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
    },
  },
}
