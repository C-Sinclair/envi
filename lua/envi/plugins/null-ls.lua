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
    },
  },
  b.formatting.deno_fmt,
  -- Python
  b.formatting.black,
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

  -- Shell
  -- b.formatting.shfmt,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local M = {}

M.setup = function()
  null_ls.setup {
    -- debug = true,
    sources = sources,
    --   -- format on save
    on_attach = function(client)
      if client.resolved_capabilities.document_formatting then
        vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
      end
    end,
  }
end

return M
