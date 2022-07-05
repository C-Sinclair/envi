local lspconfig = require "lspconfig"
local aerial = require "aerial"
local python = require "envi.lsp.python"

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
if cmp_nvim_lua_present then
  capabilities = cmp_nvim_lua.update_capabilities(capabilities)
end

local function on_attach(client, bufnr)
  client.server_capabilities.document_formatting = false

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local lsp_status_present, lsp_status = pcall(require, "lsp-status")
  if lsp_status_present then
    lsp_status.on_attach(client)
    capabilities = lsp_status.capabilities
  end

  aerial.on_attach(client, bufnr)
end

-- lspservers with default config
local servers = { "html", "cssls", "tsserver", "clojure_lsp", "gopls", "tailwindcss" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

-- Lua
local sumneko_root_path = "/home/conor/Repos/sumneko/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

local luadev = require("lua-dev").setup {
  -- add any options here, or leave empty to use the default settings
  lspconfig = {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
}

local lspconfig = require "lspconfig"
lspconfig.sumneko_lua.setup(luadev)

-- Python
lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    python.setup_dap()
  end,
  capabilities = capabilities,
}

-- Rust
--
-- no rust tools version
-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     ["rust-analyzer"] = {
--       procMacro = {
--         enable = false,
--       },
--     },
--   },
-- }

-- rust tools to do the heavy lifting
local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

local opts = {
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = true,
          disabled = { "unresolved-proc-macro" },
          enableExperimental = true,
        },
      },
    },
  },
}
require("rust-tools").setup(opts)

--[[
  LSP related keymaps
  --]]

vim.keymap.set("n", "gd", function()
  vim.lsp.buf.definition()
end)
vim.keymap.set("n", "gv", function()
  require("telescope.builtin").lsp_definitions { jump_type = "vsplit" }
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

-- Open iagnostics
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
