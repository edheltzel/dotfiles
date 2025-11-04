return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    window = {
      position = "right",
      width = 30,
      mappings = {
        ["Y"] = "none",
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_hidden = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".git",
          "node_modules",
        },
        never_show = {
          ".DS_Store",
        },
        always_show = {
          ".gitignored",
          ".env",
        },
      },
    },
  },
}
