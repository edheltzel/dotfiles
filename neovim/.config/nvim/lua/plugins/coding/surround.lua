return {
  "nvim-mini/mini.surround",
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
    custom_surroundings = {
      -- Use 'e' for emphasis/bold in Markdown: gsae, gsde, gsre
      e = {
        input = { "%*%*().-()%*%*" },
        output = { left = "**", right = "**" },
      },
      -- Use 'h' for highlight in Markdown: gsah, gsdh, gsrh
      h = {
        input = { "==().-()==" },
        output = { left = "==", right = "==" },
      },
      -- Use 'L' for markdown links: gsaL, gsdL, gsrL
      L = {
        input = { "%[().-()%]%(.-%)" },
        output = function()
          local url = MiniSurround.user_input("URL")
          if not url then
            return nil
          end
          return { left = "[", right = "](" .. url .. ")" }
        end,
      },
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)

    -- Markdown-specific surroundings: no spaces for brackets
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "mdx" },
      callback = function()
        vim.b.minisurround_config = {
          custom_surroundings = {
            -- Brackets - no spaces
            ["["] = { output = { left = "[", right = "]" } },
            ["]"] = { output = { left = "[", right = "]" } },
            -- Parentheses - no spaces
            ["("] = { output = { left = "(", right = ")" } },
            [")"] = { output = { left = "(", right = ")" } },
            -- Curly braces - no spaces
            ["{"] = { output = { left = "{", right = "}" } },
            ["}"] = { output = { left = "{", right = "}" } },
            -- Angle brackets - no spaces
            ["<"] = { output = { left = "<", right = ">" } },
            [">"] = { output = { left = "<", right = ">" } },
            -- Backticks - for inline code
            ["`"] = { output = { left = "`", right = "`" } },
            -- Single quotes
            ["'"] = { output = { left = "'", right = "'" } },
            -- Double quotes
            ['"'] = { output = { left = '"', right = '"' } },
            -- Asterisks - for emphasis
            ["*"] = { output = { left = "*", right = "*" } },
            -- Underscores - for emphasis
            ["_"] = { output = { left = "_", right = "_" } },
            -- Tilde - for strikethrough
            ["~"] = { output = { left = "~~", right = "~~" } },
            -- Include global custom surroundings
            e = opts.custom_surroundings.e,
            h = opts.custom_surroundings.h,
            L = opts.custom_surroundings.L,
          },
        }
      end,
    })
  end,
}
