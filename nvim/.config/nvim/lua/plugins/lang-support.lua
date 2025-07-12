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
    "ghostty",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles",
    lazy = false,
  },
}
