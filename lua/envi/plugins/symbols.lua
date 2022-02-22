local M = {}

M.setup = function()
  vim.keymap.set("n", "<leader>ss", "<cmd>SymbolsOutlineOpen<cr>")
end

return M
