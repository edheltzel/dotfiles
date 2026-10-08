-- got this from https://github.com/linkarzu/
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>n ",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Notification History",
      },
    },
    opts = {
      presets = {
        bottom_search = false,
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      messages = {
        enabled = true, -- enables the Noice messages UI
        view = "mini", -- default view for messages
        view_error = "mini", -- view for errors
        view_warn = "mini", -- view for warnings
        view_history = "mini", -- view for :messages
        view_search = "mini", -- view for search count messages. Set to `false` to disable
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        message = {
          enabled = true,
          view = "mini",
        },
      },
      views = {
        -- This sets the position for the search popup that shows up with / or with :
        cmdline_popup = {
          position = {
            row = "40%",
            col = "50%",
          },
        },
        mini = {
          -- timeout = 2000, -- timeout in milliseconds
          align = "center",
          position = {
            -- Centers messages top to bottom
            row = "95%",
            -- Aligns messages to the far right
            col = "100%",
          },
        },
      },
    },
  },
}
