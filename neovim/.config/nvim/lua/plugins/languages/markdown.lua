return {
  {
    "davidmh/mdx.nvim",
    ft = { "markdown", "mdx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    -- auto add bullets
    "bullets-vim/bullets.vim",
    ft = "markdown",
    config = function()
      vim.g.bullets_delete_last_bullet_if_empty = 2
    end,
  },
}
