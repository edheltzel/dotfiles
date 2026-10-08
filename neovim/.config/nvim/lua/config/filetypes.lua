-- Custom filetype associations
vim.filetype.add({
  extension = {
    njk = "htmldjango",
    webc = "htmldjango",
    conf = "sh",
  },
  filename = {
    [".*%.env%.*%"] = "sh",
    ["_redirects"] = "plaintext",
  },
  pattern = {
    [".*%.blade%.php"] = "blade",
    ["*.svg"] = "html",
    ["*.h"] = "c",
  },
})
