local dap = require "dap"
local dap_python = require "dap-python"
local lspconfig = require "lspconfig"
local aerial = require "aerial"
local capabilities = require "envi.lsp.capabilities"

local python_exe = os.getenv "HOME" .. "/.virtualenvs/debugpy/bin/python"

PY = function()
  dap.run {
    type = "python",
    request = "launch",
    program = "${file}",
  }
end

local setup_dap = function()
  dap_python.setup(python_exe)
  dap_python.test_runner = "pytest"
  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

  dap.adapters.python = {
    type = "executable",
    command = python_exe,
    args = { "-m", "debugpy.adapter" },
  }

  local cwd = vim.fn.getcwd()
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      program = "${file}",
      cwd = cwd,
      env = { PYTHONPATH = cwd },
      console = "integratedTerminal",
      name = "Run file",
      justMyCode = false,
    },
  }
end

lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    local lsp_status_present, lsp_status = pcall(require, "lsp-status")
    if lsp_status_present then
      lsp_status.on_attach(client)
    end

    aerial.on_attach(client, bufnr)
    setup_dap()
  end,
  capabilities = capabilities,
}
