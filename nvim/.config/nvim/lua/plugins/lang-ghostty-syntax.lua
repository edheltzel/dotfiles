return {
  {
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "") .. "/../vim/vimfiles",
    lazy = false, -- Ensures it loads for Ghostty config detection
    name = "ghostty", -- Avoids the name being "vimfiles"
    cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil, -- Only load if Ghostty is installed
  },
}
