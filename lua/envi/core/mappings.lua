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

-- toggle quickfix list
vim.keymap.set("n", "<c-q>", function()
  local is_open = vim.g.quickfix_open
  if is_open then
    vim.cmd "cclose"
    vim.g.quickfix_open = false
  else
    vim.cmd "copen"
    vim.g.quickfix_open = true
  end
end)

-- jump between buffer_state
vim.keymap.set("n", "<c-w>n", "<cmd>bnext<cr>")
vim.keymap.set("n", "<c-w>N", "<cmd>bprevious<cr>")

-- setup vim native functions
vim.cmd [[
  function! QFdelete(bufnr) range
    " get current qflist
    let l:qfl = getqflist()
    " no need for filter() and such; just drop the items in range
    call remove(l:qfl, a:firstline - 1, a:lastline - 1)
    " replace items in the current list, do not make a new copy of it;
    " this also preserves the list title
    call setqflist([], 'r', {'items': l:qfl})
    " restore current line
    call setpos('.', [a:bufnr, a:firstline, 1, 0])
  endfunction

  " using buffer-local mappings
  " note: still have to check &bt value to filter out `:e quickfix` and such
  augroup QFList | au!
      autocmd BufWinEnter quickfix if &bt ==# 'quickfix'
      autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :call QFdelete(bufnr())<CR>
      autocmd BufWinEnter quickfix    vnoremap <silent><buffer>d  :call QFdelete(bufnr())<CR>
      autocmd BufWinEnter quickfix endif
  augroup end
]]
