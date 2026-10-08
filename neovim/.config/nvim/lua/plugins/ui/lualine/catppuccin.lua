---- Catppuccin color palettes for NEO.ED theme
-- https://catppuccin.com
-- Generated from the official catppuccin/palette spec.

local M = {}

-- Make the active (normal) mode indicator pop with the flavor's blue,
-- matching the rose-pine palette's treatment.
local function get_overrides(colors)
  return {
    normal = {
      a = { fg = colors.blue },
    },
  }
end

M.palettes = {
  ["catppuccin-latte"] = {
    colors = {
      darker = "#eff1f5",
      bg = "#ccd0da",
      darkGray = "#bcc0cc",
      fg = "#8c8fa1",
      gray = "#7c7f93",
      green = "#40a02b",
      blue = "#1e66f5",
      purple = "#8839ef",
      red = "#d20f39",
      magenta = "#ea76cb",
    },
    get_overrides = get_overrides,
  },
  ["catppuccin-frappe"] = {
    colors = {
      darker = "#303446",
      bg = "#414559",
      darkGray = "#51576d",
      fg = "#838ba7",
      gray = "#949cbb",
      green = "#a6d189",
      blue = "#8caaee",
      purple = "#ca9ee6",
      red = "#e78284",
      magenta = "#f4b8e4",
    },
    get_overrides = get_overrides,
  },
  ["catppuccin-macchiato"] = {
    colors = {
      darker = "#24273a",
      bg = "#363a4f",
      darkGray = "#494d64",
      fg = "#8087a2",
      gray = "#939ab7",
      green = "#a6da95",
      blue = "#8aadf4",
      purple = "#c6a0f6",
      red = "#ed8796",
      magenta = "#f5bde6",
    },
    get_overrides = get_overrides,
  },
  ["catppuccin-mocha"] = {
    colors = {
      darker = "#1e1e2e",
      bg = "#313244",
      darkGray = "#45475a",
      fg = "#7f849c",
      gray = "#9399b2",
      green = "#a6e3a1",
      blue = "#89b4fa",
      purple = "#cba6f7",
      red = "#f38ba8",
      magenta = "#f5c2e7",
    },
    get_overrides = get_overrides,
  },
}

function M.get_colors(variant)
  variant = variant or "catppuccin-mocha"

  -- catppuccin.nvim may report vim.g.colors_name = "catppuccin" for every
  -- flavour, so resolve the actual flavour from the plugin/global when needed.
  if variant == "catppuccin" then
    local flavour
    local ok, cat = pcall(require, "catppuccin")
    if ok and cat.options and cat.options.flavour then
      flavour = cat.options.flavour
    elseif vim.g.catppuccin_flavour then
      flavour = vim.g.catppuccin_flavour
    end
    if flavour then
      variant = "catppuccin-" .. flavour
    end
  end

  local palette = M.palettes[variant] or M.palettes["catppuccin-mocha"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
