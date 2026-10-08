return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        projects = {
          dev = { "~/Developer", "~/Sites" },
          patterns = { ".git" },
          recent = true, -- also include recent file directories
          max_depth = 4, -- scan deeper for nested projects
          confirm = "load_session",
        },
      },
    },
  },
}
