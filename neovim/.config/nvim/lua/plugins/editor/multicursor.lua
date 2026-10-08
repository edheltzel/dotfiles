return {
  "jake-stewart/multicursor.nvim",
  event = "VeryLazy",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set
    local wk = require("which-key")

    wk.add({ { "<leader>m", group = "Multi-Cursor", icon = { icon = "󰇀", color = "cyan" } } })

    -- Add a cursor for all matches of cursor word/selection in the document.
    set({ "n", "x" }, "<leader>ma", mc.matchAllAddCursors, { desc = "Match all (add cursors)" })
    set({ "n", "x" }, "<C-A-l>", mc.matchAllAddCursors, { desc = "Match all (add cursors)" }) -- cmd+shift+l

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<C-A-j>", function()
      mc.matchAddCursor(1)
    end)
    set({ "n", "x" }, "<C-A-k>", function()
      mc.matchSkipCursor(-1)
    end) -- cmd+ctrl+j/k

    -- Add or skip cursor above/below the main cursor.
    -- set({ "n", "x" }, "<up>", function()
    --   mc.lineAddCursor(-1)
    -- end)
    -- set({ "n", "x" }, "<down>", function()
    --   mc.lineAddCursor(1)
    -- end)
    -- set({ "n", "x" }, "<leader><up>", function()
    --   mc.lineSkipCursor(-1)
    -- end)
    -- set({ "n", "x" }, "<leader><down>", function()
    --   mc.lineSkipCursor(1)
    -- end)

    -- Add and remove cursors with control + left click.
    set("n", "<C-leftmouse>", mc.handleMouse)
    set("n", "<C-leftdrag>", mc.handleMouseDrag)
    set("n", "<C-leftrelease>", mc.handleMouseRelease)

    -- Disable and enable cursors.
    set({ "n", "x" }, "<C-q>", mc.toggleCursor)

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor)
      layerSet({ "n", "x" }, "<right>", mc.nextCursor)

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
