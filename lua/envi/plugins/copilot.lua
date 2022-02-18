-- Copilot
-- tab fix to avoid conflict with cmp
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ''

vim.keymap.set('i', '<C-k>', 'copilot#Accept()', { expr = true, silent = true })
