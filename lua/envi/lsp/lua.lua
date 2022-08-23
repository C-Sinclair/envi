local lspconfig = require "lspconfig"
local aerial = require "aerial"
local capabilities = require "envi.lsp.capabilities"

local sumneko_root_path = "/home/conor/Repos/sumneko/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local luadev = require("lua-dev").setup {
  -- add any options here, or leave empty to use the default settings
  lspconfig = {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      local lsp_status_present, lsp_status = pcall(require, "lsp-status")
      if lsp_status_present then
        lsp_status.on_attach(client)
      end
      aerial.on_attach(client, bufnr)
    end,
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
  },
}

lspconfig.sumneko_lua.setup(luadev)
