local dap = require "dap"
local dapui = require "dapui"

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
