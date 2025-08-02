return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    spec = {
      -- Leader key groups
      { "<leader>f", group = "Find", icon = "🔍" },
      { "<leader>s", group = "Split", icon = "📋" },
      { "<leader>t", group = "Tab", icon = "📑" },
      { "<leader>e", group = "Explorer", icon = "📁" },
      { "<leader>h", group = "Git Hunk", icon = "🔀" },
      { "<leader>r", group = "Replace", icon = "🔄" },
      { "<leader>c", group = "Code", icon = "💻" },
      { "<leader>d", group = "Diagnostics", icon = "🔍" },
      { "<leader>g", group = "Git", icon = "🌿" },
      
      -- Non-leader groups
      { "g", group = "Go to" },
      { "]", group = "Next" },
      { "[", group = "Previous" },
      { "z", group = "Fold" },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
  },
}
