local dap = require "dap"
local dapui = require "dapui"
local dapjs = require "dap-vscode-js"

vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

-- drop a breakpoint
vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end)

-- drop a conditional breakpoint
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end)

-- continue
vim.keymap.set("n", "<leader>dn", function()
  dap.continue()
end)

-- toggle the REPL
vim.keymap.set("n", "<leader>dr", function()
  dap.repl.toggle()
end)

-- remap K to hover
local keymap_restore = {}
dap.listeners.after["event_initialized"]["me"] = function()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        vim.api.nvim_buf_del_keymap(buf, "n", "K")
      end
    end
  end
  vim.api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
end
dap.listeners.after["event_terminated"]["me"] = function()
  for _, keymap in pairs(keymap_restore) do
    vim.api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
  end
  keymap_restore = {}
end

--[[ dap.adapters.chrome = { ]]
--[[   type = "executable", ]]
--[[   command = "node", ]]
--[[   args = { os.getenv "HOME" .. "/Repos/microsoft/vscode-chrome-debug/out/src/chromeDebug.js" }, ]]

dapjs.setup {
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
}

for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
  dap.configurations[language] = {
    {
      type = "chrome",
      name = "chrome",
      request = "attach",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
    {
      name = "SSR",
      type = "node-terminal",
      request = "launch",
      command = "npm run dev",
    },
    {
      name = "Client",
      type = "pwa-chrome",
      request = "launch",
      url = "http://localhost:3000",
    },
    {
      type = "node-terminal",
      name = "Next",
      request = "launch",
      command = "pnpm run dev",
      cwd = vim.fn.getcwd(),
      serverReadyAction = {
        pattern = "started server on .+, url: (https?://.+)",
        uriFormat = "%s",
        action = "debugWithChrome",
      },
    },
  }
end

dapui.setup()

vim.keymap.set("n", "<leader>dd", function()
  dapui.toggle()
end)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
