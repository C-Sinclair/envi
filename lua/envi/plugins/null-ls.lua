local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  -- Javascript
  b.formatting.prettierd.with {
    filetypes = {
      "html",
      "css",
      "json",
      "graphql",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "scss",
      "less",
      "svelte",
    },
  },
  b.code_actions.xo,
  b.diagnostics.xo,
  --[[ b.formatting.deno_fmt, ]]
  -- JSON
  b.diagnostics.jsonlint,
  -- Tailwind
  b.formatting.rustywind,
  -- Python
  b.formatting.black.with { extra_args = { "--line-length=99" } },
  b.diagnostics.flake8.with { extra_args = { "--max-line-length=99" } },
  -- b.formatting.mypy,
  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { "--global vim" } },
  -- Clojure
  b.formatting.cljstyle,
  -- Fennel
  b.formatting.fnlfmt,
  -- Golang
  b.formatting.gofmt,
  -- Markdown
  b.formatting.markdownlint,
  -- Prisma
  b.formatting.prismaFmt,
  -- Rust
  b.formatting.rustfmt,
  -- Haskell
  b.formatting.brittany,
  -- Shell
  b.diagnostics.zsh,
  b.formatting.beautysh,
  -- b.formatting.shfmt,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  -- Github Action
  b.diagnostics.actionlint,
}

local M = {}

local augroup = vim.api.nvim_create_augroup("format_on_save", {})

M.setup = function()
  null_ls.setup {
    -- debug = true,
    sources = sources,
    -- format on save
    on_attach = function(client, bufnr)
      if client.supports_method "textDocument/formatting" then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            --[[ vim.lsp.buf.formatting_seq_sync() -- deprecated ]]
            vim.lsp.buf.format()
          end,
        })
      end
    end,
  }
end

return M
