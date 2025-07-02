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
}
