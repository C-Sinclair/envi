--[[
-- General capabilities shared across all language servers
--]]
local capabilities = vim.lsp.protocol.make_client_capabilities()

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

local cmp_nvim_lua_present, cmp_nvim_lua = pcall(require, "cmp_nvim_lua")
if cmp_nvim_lua_present and cmp_nvim_lua then
  capabilities = cmp_nvim_lua.update_capabilities(capabilities)
end

local function on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local success, lsp_status = pcall(require, "lsp-status")
  if success then
    lsp_status.on_attach(client)
  end
end

return capabilities, on_attach
