local M = {}

local dap = require "dap"
local dap_python = require "dap-python"

local python_exe = os.getenv "HOME" .. "/.asdf/shims/python"

PY = function()
  dap.run {
    type = "python",
    request = "launch",
    program = "${file}",
  }
end

M.setup_dap = function()
  dap_python.setup(python_exe)
  dap_python.test_runner = "pytest"

  dap.adapters.python = {
    type = "executable",
    command = python_exe,
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      program = "${file}",
      justMyCode = false,
    },
  }

  -- vim.keymap.set("n", "<leader>df", function()
  --   dap_python.test_method()
  -- end)
  -- vim.keymap.set("n", "<leader>dc", function()
  --   dap_python.test_class()
  -- end)
  -- vim.keymap.set("n", "<leader>ds", function()
  --   dap_python.debug_selection()
  -- end)
end

return M
