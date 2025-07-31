return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    local km = require("neoed.core.keymap-utils")
    
    local substitute_keymaps = {
      { "n", "<leader>r", substitute.operator, { desc = "Substitute with motion" } },
      { "n", "<leader>rr", substitute.line, { desc = "Substitute line" } },
      { "n", "<leader>R", substitute.eol, { desc = "Substitute to end of line" } },
      { "x", "<leader>r", substitute.visual, { desc = "Substitute in visual mode" } },
    }
    
    km.register_keymaps(substitute_keymaps)
  end,
}
