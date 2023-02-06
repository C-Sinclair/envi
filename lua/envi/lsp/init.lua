local lspconfig = require "lspconfig"
local capabilities, on_attach = require "envi.lsp.capabilities"
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

-- lspservers with default config
local servers = {
  "html",
  "cssls",
  "clojure_lsp",
  "gopls",
  "svelte",
  "elmls",
  "rnix",
  "hls",
  "ccls",
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

--[[
  LSP related keymaps
  --]]

vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
vim.keymap.set("n", "gv", "<cmd>Lspsaga peek_definition<CR>")
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
vim.keymap.set("n", "L", "<cmd>Lspsaga lsp_finder<CR>")
vim.keymap.set("n", "<C-K>", "<cmd>Lspsaga hover_doc ++keep<CR>")
vim.keymap.set("n", "<leader>lR", "<cmd>Lspsaga rename<CR>")
vim.keymap.set("n", "<leader>lr", function()
  vim.lsp.buf.references()
end)
vim.keymap.set("n", "<leader>lc", "<cmd>Lspsaga code_action<CR>")
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
vim.keymap.set("n", "<leader>de", "<cmd>Lspsaga show_cursor_diagnostics ++unfocus<CR>")
vim.keymap.set("n", "<leader>df", "<cmd>Lspsaga diagnostic_jump_next<CR>")
vim.keymap.set("n", "<leader>dF", "<cmd>Lspsaga diagnostic_jump_prev<CR>")

vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

-- load language servers
require "envi.lsp.typescript"
require "envi.lsp.rust"
require "envi.lsp.python"
require "envi.lsp.lua"
