return {
  -- see https://github.com/nvim-lualine/lualine.nvim/discussions/1389#discussion-8072342
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require
    local icons = LazyVim.config.icons

    local component_widths = {}

    -- check width of current component and add to maps
    local function add_width(str, name)
      if not str or str == "" then
        component_widths[name] = 0
        return str
      end
      component_widths[name] = #vim.api.nvim_eval_statusline(str, {}).str
      return str
    end

    -- fill space between left-most components and middle of terminal
    local function fill_space()
      local used_space = 0
      for _, width in pairs(component_widths) do
        used_space = used_space + width
      end

      local filetype_w = component_widths["filetype"] or 0
      local filename_w = component_widths["filename"] or 0

      used_space = used_space - (filename_w + filetype_w)

      local term_width = vim.opt.columns:get()

      local fill = string.rep(" ", math.floor((term_width - filename_w - filetype_w) / 2) - used_space)
      return fill
    end

    vim.o.laststatus = vim.g.lualine_laststatus

    local neoEdTheme, neoEdColors = require("plugins.ui.lualine.neoed").setup()

    local opts = {
      options = {
        theme = neoEdTheme,
        component_separators = "",
        section_separators = "",
        globalstatus = vim.o.laststatus == 1,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          winbar = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          { -- show current vim mode single character
            function()
              local mode = vim.api.nvim_get_mode()["mode"]
              return "" .. string.format("%-1s", mode)
            end,
            fmt = function(str)
              return add_width(str, "mode")
            end,
          },
        },
        lualine_b = {},
        lualine_c = {
          { -- show cwd (project dir nvim.project)
            function()
              local cwd = vim.fn.getcwd()
              return "󱉭 " .. vim.fs.basename(cwd)
            end,
            color = { fg = neoEdColors.fg },
            fmt = function(str)
              return add_width(str, "root")
            end,
          },
          { -- show cwd if it does not match prev component
            function()
              return LazyVim.lualine.root_dir({ icon = ">" })[1]()
            end,
            color = { fg = Snacks.util.color("Comment") }, -- Optional: Customize the appearance
            padding = { left = 0, right = 0 },
            fmt = function(str)
              return add_width(str, "cwd")
            end,
          },
          { -- show profiler events if enabled
            function()
              if Snacks.profiler.core.running then
                return Snacks.profiler.status()[1]()
              end
              return ""
            end,
            color = "DiagnosticError",
            fmt = function(str)
              return add_width(str, "profiler")
            end,
          },
          { -- show dap info
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return { fg = Snacks.util.color("Debug") }
            end,
            fmt = function(str)
              return add_width(str, "dap")
            end,
          },
          { -- show lazy update status
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
            fmt = function(str)
              return add_width(str, "lazy")
            end,
          },
          { -- show diagnostic info
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            fmt = function(str)
              return add_width(str, "diagnostics")
            end,
          },
          { -- fill space to center filename
            function()
              return fill_space()
            end,
            padding = { left = 0, right = 0 },
          },
          { -- filetype icon
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 0, right = 0 },
            fmt = function(str)
              return add_width(str, "filetype")
            end,
          },
          { -- filename centered to middle of window
            "filename",
            path = 1, -- show relative path
            file_status = true,
            newfile_status = true,
            color = { fg = neoEdColors.fg, gui = "italic" },
            padding = { left = 0, right = 1 },
            fmt = function(str)
              return add_width(str, "filename")
            end,
          },
          { -- show macro recording
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end -- not recording
              return " recording to @" .. reg .. " "
            end,
            padding = { left = 0, right = 0 },
            color = function()
              return {
                fg = neoEdColors.dark,
                bg = neoEdColors.red,
              }
            end,
            fmt = function(str)
              return add_width(str, "recording")
            end,
          },
        },

        lualine_x = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            "branch",
            icon = "",
            color = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns and (gitsigns.added or 0) + (gitsigns.changed or 0) + (gitsigns.removed or 0) > 0 then
                return { fg = neoEdColors.red }
              end
              return { fg = neoEdColors.gray }
            end,
          },
        },

        lualine_y = {},
        lualine_z = {
          function()
            local mode = vim.api.nvim_get_mode()["mode"]
            return "" .. string.format("%-1s", mode)
          end,
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "%=" },
          {
            "filename",
            path = 1, -- show path relative to cwd (nested directory + file, not full path)
            file_status = true,
            newfile_status = true,
            color = { fg = Snacks.util.color("Normal"), gui = "italic" },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "fzf" },
    }

    return opts
  end,
}
