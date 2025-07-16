return {
  {
    "rmagatti/auto-session",
    lazy = false,

    config = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      require('auto-session').setup({
        suppressed_dirs = { "~/", "/", "~/Downloads", "~/Developer/", "~/Sites/", "~/Documents/" },
        -- log_level = 'debug',
      })
    end
  },
}
