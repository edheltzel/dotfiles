-- Push blink.cmp closer to VS Code IntelliSense.
-- LazyVim already enables the completion menu + auto documentation; these two
-- are the pieces it leaves off by default (signature help is commented out, and
-- ghost text only turns on when an AI source like Copilot is active).
return {
  "saghen/blink.cmp",
  opts = {
    -- Parameter hints: shows a function's signature/args while typing inside ()
    signature = { enabled = true },
    completion = {
      -- Inline grey preview of the selected item, VS Code style
      ghost_text = { enabled = true },
    },
  },
}
