vim.g.neoformat_enabled_haskell = { "brittany", "stylishhaskell" }

local M = {}

M.format = function()
  vim.lsp.buf.format {
    --[[ timeout_ms = 2000, ]]
    filter = function(client)
      -- no thank you slow tsserver
      return client.name ~= "tsserver"
    end,
  }
end

local augroup = vim.api.nvim_create_augroup("format_on_save", {})

--- format on save
vim.api.nvim_clear_autocmds { group = augroup }
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    vim.cmd [[Neoformat]]
  end,
})

return M
