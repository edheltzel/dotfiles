return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      {
        "<leader>dT",
        function()
          local dap = require("dap")
          dap.run({
            type = "pwa-node",
            request = "launch",
            name = "Vite+: debug current test file",
            runtimeExecutable = "vp",
            runtimeArgs = { "test", "--run", vim.fn.expand("%") },
            cwd = (_G.LazyVim and LazyVim.root and LazyVim.root()) or vim.fn.getcwd(),
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            sourceMaps = true,
          })
        end,
        desc = "Debug Vite+ test file",
      },
    },
  },
}
