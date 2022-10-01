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
  b.diagnostics.eslint_d,
  --[[ b.formatting.deno_fmt, ]]
  -- JSON
  b.diagnostics.jsonlint,
  -- Tailwind
  -- b.formatting.rustywind,
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

M.setup = function()
  null_ls.setup {
    sources = sources,
  }
end

return M
