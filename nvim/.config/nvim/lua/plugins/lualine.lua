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

    -- fill space bweteen left-most components and middle of terminal
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

    -- Custom theme and colors from lualine.lua
    local neoEd = require("lualine.themes.eldritch")

    local colors = {
      bg = "#212337",
      darkGray = "#323449",
      fg = "#454E7D",
      gray = "#586089",
      green = "#37F499",
      blue = "#04D1F9",
      purple = "#A48CF2",
      red = "#F16d75",
      magenta = "#F265B5",
    }
    -- Apply custom colors to modes
    neoEd.normal.a.fg = colors.fg
    neoEd.normal.a.bg = colors.bg
    neoEd.normal.b.fg = colors.fg
    neoEd.normal.b.bg = colors.fg
    neoEd.normal.c.fg = colors.fg
    neoEd.normal.c.bg = colors.bg

    neoEd.insert.a.bg = colors.magenta
    neoEd.insert.a.fg = colors.bg
    neoEd.insert.b.bg = colors.fg
    neoEd.insert.b.fg = colors.bg

    neoEd.visual.a.bg = colors.purple
    neoEd.visual.a.fg = colors.bg
    neoEd.visual.b.bg = colors.fg
    neoEd.visual.b.fg = colors.bg

    neoEd.replace.a.fg = colors.red
    neoEd.replace.a.bg = colors.bg
    neoEd.replace.b.fg = colors.fg
    neoEd.replace.b.bg = colors.bg

    neoEd.command.a.fg = colors.green
    neoEd.command.a.bg = colors.bg
    neoEd.command.b.fg = colors.fg
    neoEd.command.b.bg = colors.bg

    neoEd.terminal.a.fg = colors.bg
    neoEd.terminal.a.bg = colors.red
    neoEd.terminal.b.fg = colors.bg
    neoEd.terminal.b.bg = colors.red

    neoEd.inactive.b.fg = colors.fg
    neoEd.inactive.b.bg = colors.bg

    local opts = {
      options = {
        theme = neoEd,
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
            color = { fg = neoEd.fg },
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
          { -- show macro recording
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end -- not recording
              return " recording to @" .. reg
            end,
            padding = { left = 0, right = 0 },
            color = function()
              return { fg = Snacks.util.color("Error") }
            end,
            fmt = function(str)
              return add_width(str, "recording")
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
            file_status = true,
            newfile_status = true,
            color = { fg = neoEd.fg, gui = "BOLD" },
            padding = { left = 0, right = 0 },
            fmt = function(str)
              return add_width(str, "filename")
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
          { "branch", icon = "", color = { fg = neoEd.gray } },
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
