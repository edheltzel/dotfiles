local M = {}

-- Default options for keymaps
local default_opts = { noremap = true, silent = true }

-- Store groups for which-key registration
local groups = {}

-- Enhanced keymap setter with auto-descriptions and consistent options
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  local final_opts = vim.tbl_extend("force", default_opts, opts)
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

-- Create and register a which-key group
function M.create_group(prefix, name, icon)
  groups[prefix] = { name = name, icon = icon }
  return groups[prefix]
end

-- Register all stored groups with which-key
function M.register_groups()
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    return
  end
  
  for prefix, group in pairs(groups) do
    wk.add({
      { prefix, group = group.name, icon = group.icon }
    })
  end
end

-- Batch register keymaps for a specific category/plugin
function M.register_keymaps(keymaps)
  for _, keymap in ipairs(keymaps) do
    local mode = keymap.mode or keymap[1]
    local lhs = keymap.lhs or keymap[2]
    local rhs = keymap.rhs or keymap[3]
    local opts = keymap.opts or keymap[4] or {}
    
    M.map(mode, lhs, rhs, opts)
  end
end

-- Helper for buffer-local keymaps (especially useful for LSP)
function M.buffer_map(bufnr, mode, lhs, rhs, desc)
  local opts = vim.tbl_extend("force", default_opts, {
    buffer = bufnr,
    desc = desc
  })
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Convenience function for plugin keymaps with consistent formatting
function M.plugin_keymaps(plugin_name, keymaps)
  for _, keymap in ipairs(keymaps) do
    local mode = keymap[1]
    local lhs = keymap[2]
    local rhs = keymap[3]
    local desc = keymap[4] or (plugin_name .. " action")
    
    M.map(mode, lhs, rhs, { desc = desc })
  end
end

-- Generate description based on common patterns
function M.auto_desc(action, target)
  local patterns = {
    toggle = "Toggle " .. target,
    open = "Open " .. target,
    close = "Close " .. target,
    find = "Find " .. target,
    show = "Show " .. target,
    go = "Go to " .. target,
    split = "Split " .. target,
    next = "Next " .. target,
    prev = "Previous " .. target,
  }
  
  return patterns[action] or (action .. " " .. target)
end

-- Quick group creators for common categories
function M.setup_common_groups()
  M.create_group("<leader>f", "Find", "🔍")
  M.create_group("<leader>s", "Split", "📋")
  M.create_group("<leader>t", "Tab", "📑")
  M.create_group("<leader>e", "Explorer", "📁")
  M.create_group("<leader>h", "Git Hunk", "🔀")
  M.create_group("<leader>r", "Replace", "🔄")
  M.create_group("<leader>c", "Code", "💻")
  M.create_group("<leader>d", "Diagnostics", "🔍")
  M.create_group("<leader>g", "Git", "🌿")
end

return M