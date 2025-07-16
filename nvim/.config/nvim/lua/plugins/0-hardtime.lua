return {
  "m4xshen/hardtime.nvim",
  enabled = true,
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "BufEnter",
  keys = {},
  opts = function(_, opts)
    -- make sure the default table exists
    opts.restricted_keys = opts.restricted_keys or {}
    opts.max_count = 12
  end,
}
