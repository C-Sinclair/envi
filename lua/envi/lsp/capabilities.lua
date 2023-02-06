--[[
-- General capabilities shared across all language servers
--]]

local function on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local success, lsp_status = pcall(require, "lsp-status")
  if success then
    lsp_status.on_attach(client)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_present, cmp = pcall(require, "cmp_nvim_lsp")
if not cmp_present then
  return capabilities, on_attach
end

capabilities = cmp.default_capabilities()

capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

return capabilities, on_attach
