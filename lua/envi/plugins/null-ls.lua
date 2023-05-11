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
  --[[ b.code_actions.xo, ]]
  --[[ b.diagnostics.xo, ]]
  --[[ b.diagnostics.eslint_d, ]]
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
  b.formatting.stylish_haskell,
  -- Shell
  b.diagnostics.zsh,
  b.formatting.beautysh,
  -- b.formatting.shfmt,
  -- Fish
  b.diagnostics.fish,
  b.formatting.fish_indent,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  -- Github Action
  b.diagnostics.actionlint,
  -- Elixir
  b.diagnostics.credo,
  b.formatting.mix,
  -- HTML
  b.diagnostics.curlylint,
  b.formatting.djhtml,
}

local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.prepare_format_on_save = function(bufnr)
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
      vim.lsp.buf.format {}
    end,
  })
end

M.setup = function()
  null_ls.setup {
    sources = sources,
    on_attach = function(client, bufnr)
      if client.supports_method "textDocument/formatting" then
        M.prepare_format_on_save(bufnr)
      end
    end,
  }
end

return M
