local lspconfig = require "lspconfig"
local cmp_present, cmp = pcall(require, "cmp_nvim_lsp")
local lsp_status_present, lsp_status = pcall(require, "lsp-status")
if lsp_status_present then
  lsp_status.register_progress()
end

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  if lsp_status_present then
    lsp_status.on_attach(client)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

if lsp_status_present then
  capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
end

if cmp_present then
  capabilities = vim.tbl_extend("keep", capabilities, cmp.default_capabilities())
end

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

capabilities.workspace.symbol.dynamicRegistration = true
capabilities.workspace.semanticTokens.dynamicRegistration = true

capabilities.textDocument.hover.dynamicRegistration = true
capabilities.textDocument.completion.dynamicRegistration = true
capabilities.textDocument.callHierarchy.dynamicRegistration = true
capabilities.textDocument.signatureHelp.dynamicRegistration = true
capabilities.textDocument.documentSymbol.dynamicRegistration = true
capabilities.textDocument.semanticTokens.dynamicRegistration = true
capabilities.textDocument.synchronization.dynamicRegistration = true
capabilities.textDocument.documentHighlight.dynamicRegistration = true

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
vim.keymap.set("i", "<C-h>", function()
  vim.lsp.buf.signature_help()
end)

-- Open Diagnostics
vim.keymap.set("n", "<leader>de", "<cmd>Lspsaga show_cursor_diagnostics ++unfocus<CR>")
vim.keymap.set("n", "<leader>df", "<cmd>Lspsaga diagnostic_jump_next<CR>")
vim.keymap.set("n", "<leader>dF", "<cmd>Lspsaga diagnostic_jump_prev<CR>")

vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

local default_handler = function(server)
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

local mason = require "mason-lspconfig"

mason.setup_handlers {
  default_handler,
  ["elixirls"] = function()
    local elixir = require "elixir"
    local elixirls = require "elixir.elixirls"

    elixir.setup {
      elixirls = {
        repo = "elixir-lsp/elixir-ls",
        tag = "v0.14.6",
        settings = elixirls.settings {
          dialyzerEnabled = true,
          fetchDeps = true,
          enableTestLenses = true,
          suggestSpecs = true,
        },
        on_attach = function(client, bufnr)
          local null_ls = require "envi.plugins.null-ls"
          null_ls.prepare_format_on_save(bufnr)

          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      },
    }
  end,
  ["tsserver"] = function()
    require("typescript").setup {}
  end,
  ["tailwindcss"] = function()
    lspconfig.tailwindcss.setup {
      cmd = { vim.fn.stdpath "data" .. "/mason/bin/tailwindcss-language-server" },
      on_attach = function(client, bufnr)
        require("tailwindcss-colors").buf_attach(bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      init_options = {
        userLanguages = {
          elixir = "phoenix-heex",
          eruby = "erb",
          heex = "phoenix-heex",
          svelte = "html",
        },
      },
      settings = {
        tailwindCSS = {
          validate = true,
          experimental = {
            configFile = vim.loop.cwd() .. "/assets/tailwind.config.js",
          },
        },
      },
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "heex",
        "elixir",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "svelte",
      },
    }
  end,
  ["lua_ls"] = function()
    require("neodev").setup {}

    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim", "awesome", "client", "screen", "root" },
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
    }
  end,
  ["astro"] = function()
    lspconfig.astro.setup {
      on_attach = function(client, bufnr)
        local null_ls = require "envi.plugins.null-ls"
        null_ls.prepare_format_on_save(bufnr)
        return on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    }
  end,
}
