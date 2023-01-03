local lspconfig = require "lspconfig"
local capabilities = require "envi.lsp.capabilities"
local fo = require "envi.lsp.formatting"

vim.fn.sign_define(
  "DiagnosticSignError",
  { text = "", numhl = "DiagnosticSignError", texthl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignInfo", { text = "", numhl = "DiagnosticSignInfo", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", numhl = "DiagnosticSignHint", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", numhl = "DiagnosticSignWarn", texthl = "DiagnosticSignWarn" })

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = true,
}

-- borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

-- enable update jsx tags on insert
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = {
    spacing = 5,
    severity_limit = "Warning",
  },
  update_in_insert = true,
})

local function on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local lsp_status = require "lsp-status"
  lsp_status.on_attach(client)
end

-- lspservers with default config
local servers = {
  "html",
  "cssls",
  "clojure_lsp",
  "gopls",
  --[[ "tailwindcss", ]]
  "svelte",
  "elmls",
  "rnix",
  "hls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

lspconfig.elixirls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { vim.fn.expand "~" .. "/bin/elixir-ls/language_server.sh" },
}

--[[
  LSP related keymaps
  --]]

vim.keymap.set("n", "gd", function()
  vim.lsp.buf.definition()
  vim.cmd.norm [[ zz ]]
end)
vim.keymap.set("n", "gv", function()
  require("telescope.builtin").lsp_definitions { jump_type = "vsplit" }
  vim.cmd.norm [[ zz ]]
end)
vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover()
end)
vim.keymap.set("n", "gK", function()
  vim.lsp.buf.hover()
end)
vim.keymap.set("n", "<leader>lR", function()
  vim.lsp.buf.rename()
end)
vim.keymap.set("n", "<leader>lr", function()
  vim.lsp.buf.references()
end)
vim.keymap.set("n", "<leader>lc", function()
  vim.lsp.buf.code_action()
end)
vim.keymap.set("n", "<leader>ls", function()
  vim.lsp.buf.signature_help()
end)
vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.run, {
  buffer = true,
  noremap = true,
})

-- Formatting
vim.keymap.set("n", "<leader>lf", fo.format)

-- Open Diagnostics
vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.open_float()
end)
vim.keymap.set("n", "<leader>dd", function()
  require("telescope.builtin").diagnostics()
end)
vim.keymap.set("n", "<leader>df", function()
  vim.diagnostic.goto_next()
end)
vim.keymap.set("n", "<leader>dF", function()
  vim.diagnostic.goto_prev()
end)

-- Language specific config
require "envi.lsp.python"
require "envi.lsp.lua"
require "envi.lsp.typescript"
require "envi.lsp.rust"
