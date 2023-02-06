local numbertogglegroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  pattern = "*",
  callback = function()
    -- to handle when in dashboard nvim
    if not vim.bo.modifiable then
      return
    end
    vim.wo.relativenumber = true
  end,
  group = numbertogglegroup,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
  group = numbertogglegroup,
})
