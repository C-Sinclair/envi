local lspconfig = require "lspconfig"
local capabilities = require "envi.lsp.capabilities"

local M = {}

function M.setup()
  lspconfig.tailwindcss.setup {
    on_attach = function(client, bufnr)
      require("tailwindcss-colors").buf_attach(bufnr)
    end,
    capabilities = capabilities,
  }
end

return M
