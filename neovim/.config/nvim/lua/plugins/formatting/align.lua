return {
  {
    "Vonr/align.nvim",
    branch = "v2",
    lazy = true,
    init = function()
      local NS = { noremap = true, silent = true }

      vim.keymap.set("x", "aa", function()
        require("align").align_to_char({ length = 1 })
      end, NS)

      vim.keymap.set("x", "aw", function()
        require("align").align_to_string({ preview = true, regex = false })
      end, NS)

      vim.keymap.set("x", "ar", function()
        require("align").align_to_string({ preview = true, regex = true })
      end, NS)
    end,
  },
}
