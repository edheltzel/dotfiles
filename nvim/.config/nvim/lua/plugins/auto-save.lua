-- https://github.com/okuuva/auto-save.nvim
-- delay in milliseconds before auto saving
DelayTime = 120000 -- 2 minutes

-- Autocommand for printing the autosaved message
local group = vim.api.nvim_create_augroup("autosave", {})
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePost",
  group = group,
  callback = function(opts)
    if opts.data.saved_buffer ~= nil then
      -- print("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
      print("AutoSaved")
    end
  end,
})

-- No auto-save when in VISUAL mode
-- see -> https://github.com/okuuva/auto-save.nvim/issues/67#issuecomment-2597631756
local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "*:[vV\x16]*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualEnter" })
    -- print("VisualEnter")
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "[vV\x16]*:*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualLeave" })
    -- print("VisualLeave")
  end,
})

-- Override the `flash.jump` function to detect start and end
local flash = require("flash")
local original_jump = flash.jump

flash.jump = function(opts)
  vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpStart" })
  -- print("flash.nvim enter")

  original_jump(opts)

  vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpEnd" })
  -- print("flash.nvim leave")
end

-- Disable auto-save when entering a snacks_input buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_input",
  group = group,
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputEnter" })
    -- print("snacks input enter")
  end,
})

-- Re-enable auto-save when leaving that buffer
vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = "*", -- check all buffers
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if ft == "snacks_input" then
      vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputLeave" })
      -- print("snacks input leave")
    end
  end,
})

-- Disable auto-save when entering a snacks_input buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  group = group,
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputEnter" })
    -- print("snacks picker input enter")
  end,
})

-- Re-enable auto-save when leaving that buffer
vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = "*", -- check all buffers
  callback = function(opts)
    local ft = vim.bo[opts.buf].filetype
    if ft == "snacks_picker_input" then
      vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputLeave" })
      -- print("snacks picker input leave")
    end
  end,
})

return {
  {
    "okuuva/auto-save.nvim",
    enabled = true,
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { -- See :h events
        -- -- vim events that trigger an immediate save
        -- -- I'm disabling this, as it's autosaving when I leave the buffer and
        -- -- that's autoformatting stuff if on insert mode and following a tutorial
        -- -- Re-enabling this to only save if NOT in insert mode in the condition below
        -- immediate_save = { nil },
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" }, -- vim events that trigger an immediate save
        -- vim events that trigger a deferred save (saves after `debounce_delay`)
        defer_save = {
          "InsertLeave",
          "TextChanged",
          { "User", pattern = "VisualLeave" },
          { "User", pattern = "FlashJumpEnd" },
          { "User", pattern = "SnacksInputLeave" },
          { "User", pattern = "SnacksPickerInputLeave" },
        },
        cancel_deferred_save = {
          "InsertEnter",
          { "User", pattern = "VisualEnter" },
          { "User", pattern = "FlashJumpStart" },
          { "User", pattern = "SnacksInputEnter" },
          { "User", pattern = "SnacksPickerInputEnter" },
        },
      },
      -- function that takes the buffer handle and determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      -- if set to `nil` then no specific condition is applied
      condition = function(buf)
        -- Do not save when I'm in insert mode
        -- Do NOT ADD VISUAL MODE HERE or the cancel_deferred_save wont' work
        -- If I STAY in insert mode and switch to another app, like YouTube to
        -- take notes, the BufLeave or FocusLost immediate_save will be ignored
        -- and the save will not be triggered
        local mode = vim.fn.mode()
        if mode == "i" then
          return false
        end

        -- Disable auto-save for the harpoon plugin, otherwise it just opens and closes
        -- https://github.com/ThePrimeagen/harpoon/issues/434
        --
        -- Disable auto-save for `sql` file types
        -- Run `:set filetype?` on a dadbod query to make sure of the filetype
        local filetype = vim.bo[buf].filetype
        if filetype == "harpoon" or filetype == "mysql" then
          return false
        end

        -- Skip auto-save when in an active snippet
        if require("luasnip").in_snippet() then
          return false
        end

        return true
      end,
      write_all_buffers = false, -- write all buffers when the current one meets `condition`
      -- Do not execute autocmds when saving
      -- If you set noautocmd = true, autosave won't trigger an auto format
      -- https://github.com/okuuva/auto-save.nvim/issues/55
      noautocmd = false,
      lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
      -- see global variable `DelayTime` in this file
      debounce_delay = DelayTime,
      -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
      debug = false,
    },
  },
}
