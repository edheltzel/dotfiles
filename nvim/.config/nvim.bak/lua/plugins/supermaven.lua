return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_selection = "<Tab>",
          accept_word = "<C-j>",
        },
      })
    end,
  },
}
