return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 50,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local km = require("neoed.core.keymap-utils")
    
    local nvim_tree_keymaps = {
      { "n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" } },
      { "n", "<leader>fe", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Show active file in explorer" } },
      { "n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" } },
      { "n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" } },
    }
    
    km.register_keymaps(nvim_tree_keymaps)
  end,
}
