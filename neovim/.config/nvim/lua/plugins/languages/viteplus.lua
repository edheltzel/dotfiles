local function root()
  if package.loaded["lazyvim.util"] then
    return require("lazyvim.util").root()
  end
  if _G.LazyVim and LazyVim.root then
    return LazyVim.root()
  end
  return vim.fn.getcwd()
end

local vp_bin = vim.fn.expand("~/.vite-plus/bin/vp")

local function has_vp()
  return vim.fn.executable(vp_bin) == 1
end

local function ensure_mason_packages(opts, packages)
  opts.ensure_installed = opts.ensure_installed or {}
  for _, package in ipairs(packages) do
    if not vim.tbl_contains(opts.ensure_installed, package) then
      table.insert(opts.ensure_installed, package)
    end
  end
end

local function viteplus_terminal(args, opts)
  opts = opts or {}
  local cmd = "vp " .. args

  if _G.Snacks and Snacks.terminal then
    Snacks.terminal.open(cmd, {
      cwd = opts.cwd or root(),
      win = {
        position = "bottom",
        height = opts.height or 0.35,
      },
    })
    return
  end

  vim.cmd("botright split | terminal " .. cmd)
end

local function viteplus_input_run()
  vim.ui.input({ prompt = "vp run " }, function(input)
    if input and input ~= "" then
      viteplus_terminal("run " .. input)
    end
  end)
end

local function viteplus_picker()
  local items = {
    { text = "dev", cmd = "dev" },
    { text = "check", cmd = "check" },
    { text = "check --fix", cmd = "check --fix" },
    { text = "lint", cmd = "lint" },
    { text = "lint --fix", cmd = "lint --fix" },
    { text = "fmt", cmd = "fmt" },
    { text = "test", cmd = "test" },
    { text = "test --watch", cmd = "test --watch" },
    { text = "build", cmd = "build" },
    { text = "preview", cmd = "preview" },
    { text = "install", cmd = "install" },
  }

  if _G.Snacks and Snacks.picker and Snacks.picker.select then
    Snacks.picker.select(items, {
      prompt = "Vite+",
      format = function(item)
        return item.text
      end,
    }, function(item)
      if item then
        viteplus_terminal(item.cmd)
      end
    end)
    return
  end

  vim.ui.select(items, {
    prompt = "Vite+",
    format_item = function(item)
      return item.text
    end,
  }, function(item)
    if item then
      viteplus_terminal(item.cmd)
    end
  end)
end

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- vtsls = TS language server; oxlint = Oxc lint LSP (live diagnostics).
      -- Formatting goes through `vp fmt` (conform), so the standalone oxfmt LSP
      -- is intentionally not installed/enabled.
      ensure_mason_packages(opts, {
        "vtsls",
        "oxlint",
        "js-debug-adapter",
      })
    end,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>v", group = "Vite+" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = { enabled = false },
        eslint = { enabled = false },
        tsserver = { enabled = false },
        ts_ls = { enabled = false },
        -- oxlint LSP = live lint diagnostics (replaces Biome's linting).
        oxlint = { enabled = true },
        -- oxfmt LSP off: formatting is handled by `vp fmt` via conform.
        -- See plugins/formatting/viteplus.lua.
        oxfmt = { enabled = false },
      },
    },
  },

  {
    "nvim-mini/mini.icons",
    optional = true,
    opts = {
      file = {
        ["vite.config.ts"] = { glyph = "󱐋", hl = "MiniIconsPurple" },
        ["vite.config.mts"] = { glyph = "󱐋", hl = "MiniIconsPurple" },
        ["vite.config.js"] = { glyph = "󱐋", hl = "MiniIconsPurple" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>vv", viteplus_picker, desc = "Vite+: picker" },
      {
        "<leader>vd",
        function()
          viteplus_terminal("dev")
        end,
        desc = "Vite+: dev",
      },
      {
        "<leader>vc",
        function()
          viteplus_terminal("check")
        end,
        desc = "Vite+: check",
      },
      {
        "<leader>vC",
        function()
          viteplus_terminal("check --fix")
        end,
        desc = "Vite+: check fix",
      },
      {
        "<leader>vl",
        function()
          viteplus_terminal("lint")
        end,
        desc = "Vite+: lint",
      },
      {
        "<leader>vL",
        function()
          viteplus_terminal("lint --fix")
        end,
        desc = "Vite+: lint fix",
      },
      {
        "<leader>vf",
        function()
          viteplus_terminal("fmt")
        end,
        desc = "Vite+: format",
      },
      {
        "<leader>vt",
        function()
          viteplus_terminal("test")
        end,
        desc = "Vite+: test",
      },
      {
        "<leader>vT",
        function()
          viteplus_terminal("test --watch")
        end,
        desc = "Vite+: test watch",
      },
      {
        "<leader>vb",
        function()
          viteplus_terminal("build")
        end,
        desc = "Vite+: build",
      },
      {
        "<leader>vp",
        function()
          viteplus_terminal("preview")
        end,
        desc = "Vite+: preview",
      },
      { "<leader>vr", viteplus_input_run, desc = "Vite+: run task" },
      {
        "<leader>vi",
        function()
          viteplus_terminal("install")
        end,
        desc = "Vite+: install",
      },
    },
    init = function()
      vim.api.nvim_create_user_command("VitePlus", function(cmd)
        if not has_vp() then
          vim.notify("vp is not executable in Neovim's PATH", vim.log.levels.ERROR)
          return
        end
        viteplus_terminal(cmd.args ~= "" and cmd.args or "")
      end, {
        nargs = "*",
        complete = function()
          return {
            "dev",
            "check",
            "check --fix",
            "lint",
            "lint --fix",
            "fmt",
            "test",
            "test --watch",
            "build",
            "preview",
            "run",
            "install",
          }
        end,
      })
    end,
  },
}
