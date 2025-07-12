return {
  -- jinjua2/nunjucks support
  {
    "armyers/Vim-Jinja2-Syntax",
    dependencies = {},
  },
  -- frontmatter support
  {
    "goropikari/front-matter.nvim",
    opts = {},
    build = "make setup",
  },
  {
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "") .. "/../vim/vimfiles",
    lazy = false, -- Ensures it loads for Ghostty config detection
    name = "ghostty", -- Avoids the name being "vimfiles"
    cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil, -- Only load if Ghostty is installed
  },
}
