local lsp = require "vim.lsp.util"
local log = require "envi.log"

local M = {}

local augroup = vim.api.nvim_create_augroup("format_on_save", {})

-- format on save
M.setup_formatting_on_attach = function(client, bufnr)
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    callback = function()
      vim.lsp.buf.format {
        timeout_ms = 2000,
        filter = function(client)
          -- no thank you slow tsserver
          return client.name ~= "tsserver"
        end,
      }
    end,
  })
end

return M
