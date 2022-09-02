local aerial = require "aerial"
local ts = require "typescript"
local fo = require "envi.lsp.formatting"

ts.setup {
  server = {
    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      local lsp_status_present, lsp_status = pcall(require, "lsp-status")
      if lsp_status_present then
        lsp_status.on_attach(client)
      end
      aerial.on_attach(client, bufnr)
      fo.setup_formatting_on_attach(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 150,
    },
  },
}
