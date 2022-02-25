local M = {}

M.setup = function()
  -- evaluate the current form
  vim.keymap.set("n", "<leader>cc", "<cmd>ConjureEval<cr>")
  vim.keymap.set("v", "<leader>cc", "<cmd>'<,'>ConjureEval<cr>")
  -- evaluate the current file
  vim.keymap.set("n", "<leader>cf", "<cmd>ConjureEvalBuf<cr>")
  -- show the REPL log in a vertical split
  vim.keymap.set({ "n", "v" }, "<leader>cv", "<cmd>ConjureLogVSplit<cr>")
end

return M
