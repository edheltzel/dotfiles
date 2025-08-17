return {
  {
    "rmagatti/auto-session",
    lazy = false,

    config = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      require("auto-session").setup({
        bypass_save_filetypes = { "alpha", "dashboard" },
        suppressed_dirs = { "~/", "/", "~/Downloads", "~/Developer/", "~/Sites/", "~/Documents/" },
        git_use_branch_name = true,
      })
    end,
  },
}
