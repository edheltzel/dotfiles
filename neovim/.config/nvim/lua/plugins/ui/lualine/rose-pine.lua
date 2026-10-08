---- Rose Pine color palettes for NEO.ED theme
-- https://rosepinetheme.com/

local M = {}

M.palettes = {
  ["rose-pine"] = {
    colors = {
      darker = "#191724",
      bg = "#1f1d2e",
      darkGray = "#26233a",
      fg = "#6e6a86",
      gray = "#908caa",
      green = "#31748f",
      blue = "#9ccfd8",
      purple = "#c4a7e7",
      red = "#eb6f92",
      magenta = "#ebbcba",
    },
    -- Override function receives colors table, return overrides
    -- Example: Make visual mode use a different purple
    get_overrides = function(colors)
      return {
        normal = {
          a = { fg = colors.green },
        },
      }
    end,
  },
  ["rose-pine-moon"] = {
    colors = {
      darker = "#232136",
      bg = "#2a273f",
      darkGray = "#393552",
      fg = "#6e6a86",
      gray = "#908caa",
      green = "#3e8fb0",
      blue = "#9ccfd8",
      purple = "#c4a7e7",
      red = "#eb6f92",
      magenta = "#ea9a97",
    },
  },
  ["rose-pine-dawn"] = {
    colors = {
      darker = "#faf4ed",
      bg = "#fffaf3",
      darkGray = "#f2e9e1",
      fg = "#9893a5",
      gray = "#797593",
      green = "#286983",
      blue = "#56949f",
      purple = "#907aa9",
      red = "#b4637a",
      magenta = "#d7827e",
    },
  },
}

function M.get_colors(variant)
  variant = variant or "rose-pine"

  -- rose-pine.nvim sets vim.g.colors_name = "rose-pine" for ALL variants,
  -- so we query the plugin's internal config to detect the actual variant
  if variant == "rose-pine" then
    local ok, rp_config = pcall(require, "rose-pine.config")
    if ok and rp_config.options then
      local rp_variant = rp_config.options.variant
      if rp_variant == "dawn" then
        variant = "rose-pine-dawn"
      elseif rp_variant == "moon" then
        variant = "rose-pine-moon"
      end
      -- "main" stays as "rose-pine"
    end
  end

  local palette = M.palettes[variant] or M.palettes["rose-pine"]
  local overrides = palette.get_overrides and palette.get_overrides(palette.colors) or nil
  return palette.colors, overrides
end

return M
