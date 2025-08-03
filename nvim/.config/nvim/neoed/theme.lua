local themes = vim.pack
local cmd = vim.cmd

-- Get active theme from global variable (set in init.lua)
local activeTheme = vim.g.active_theme or 'default'

-- Load theme configurations from themes/ directory
local function loadThemeConfig(themeName)
  local ok, config = pcall(require, 'config.themes.' .. themeName)
  if not ok then
    print("Warning: Theme config not found for '" .. themeName .. "'")
    return nil
  end
  return config
end

-- Get all available themes by scanning the themes directory
local function getAvailableThemes()
  local availableThemes = {}
  local themeFiles = vim.fn.glob(vim.fn.stdpath('config') .. '/config/themes/*.lua', false, true)
  
  for _, file in ipairs(themeFiles) do
    local themeName = vim.fn.fnamemodify(file, ':t:r')
    local config = loadThemeConfig(themeName)
    if config then
      availableThemes[themeName] = config
    end
  end
  
  return availableThemes
end

-- Load all theme configurations
local themeConfigs = getAvailableThemes()

-- Add all configured themes to vim.pack
local themeSources = {}
for _, config in pairs(themeConfigs) do
  table.insert(themeSources, { src = config.src })
end
if #themeSources > 0 then
  themes.add(themeSources)
end

-- Setup the active theme if it needs setup
local activeConfig = themeConfigs[activeTheme]
if activeConfig and activeConfig.needsSetup and activeConfig.setup then
  local ok, err = pcall(activeConfig.setup)
  if not ok then
    print("Warning: Failed to setup " .. activeTheme .. " theme: " .. (err or "unknown error"))
  end
end

local function set_colorscheme(name, fallback)
  local colorscheme_cmd = "colorscheme " .. name
  local success, _ = pcall(cmd, colorscheme_cmd)
  if not success then
    print("Warning: Theme '" .. name .. "' not found, using fallback")
    if fallback then
      local fallback_cmd = "colorscheme " .. fallback
      pcall(cmd, fallback_cmd)
    end
  end
end

set_colorscheme(activeTheme, 'default')

-- cmd(":hi statusline guibg=NONE guifg=#0090d0")
