--[[
Core VIM keymaps 
--]]

-- dont yank on paste
vim.keymap.set('v', 'p', '"_dp')

-- yank from current cursor to end of line
vim.keymap.set('n', 'Y', 'yg$')

-- dont yank on cut
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')

-- dont yank on delete
vim.keymap.set({ 'n', 'v' }, 'd', '"_d')

-- escape in terminal
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
