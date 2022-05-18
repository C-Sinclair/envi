--[[
Core VIM keymaps 
--]]

-- dont yank on paste
vim.keymap.set("v", "p", '"dp')

-- yank from current cursor to end of line
vim.keymap.set("n", "Y", "yg$")

-- dont yank on cut
vim.keymap.set({ "n", "v" }, "x", '"_x')

-- escape in terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- close the current buffer
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>")

-- close the quickfix list
vim.keymap.set("n", "<leader>q", "<cmd>cclose<cr>")

-- jump between buffer_state
vim.keymap.set("n", "<c-w>n", "<cmd>bnext<cr>")
vim.keymap.set("n", "<c-w>N", "<cmd>bprevious<cr>")
