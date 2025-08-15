return {
  -- explorer and picker are the same plugin
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
          -- TODO: update keymaps for some of the items to better match VSpaceCode
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
