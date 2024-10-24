return{
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
       kemaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accpet_word = "<C-j>"
       },
       ignore_filetypes = { cpp = true },
       color = {
        suggestion_color = "#292D43",
        cterm = 244,
       },
       log_level = "info", -- set to "off" to disable logging completely
       disable_inline_completion = false, -- disables inline completion for use with cmp
       disable_keymaps = false,
       condition = function()
        return false
       end,
      })
    end,
  },
}
