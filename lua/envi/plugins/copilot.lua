-- Copilot
-- tab fix to avoid conflict with cmp
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

vim.keymap.set("i", "<C-k><C-k>", "copilot#Accept()", { expr = true, silent = true })
vim.keymap.set("i", "<C-k><C-l>", "copilot#Next()", { expr = true, silent = true })
vim.keymap.set("i", "<C-k><C-h>", "copilot#Previous()", { expr = true, silent = true })

local M = {}

M.setup = function() end

return M
