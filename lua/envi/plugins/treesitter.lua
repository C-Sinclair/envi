local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
  print "treesitter not present"
  return
end

local config = {
  ensure_installed = "all",
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  autotag = {
    enable = true,
    filetype = {
      "html",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "rescript",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gni",
      node_incremental = "gnn",
      scope_incremental = "gns",
      node_decremental = "gnd",
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  playground = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 5000,
  },
  textobjects = {
    select = {
      enable = true,
      -- lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

vim.cmd 'autocmd BufRead,BufNewFile *.nomad set filetype=hcl'

local M = {}

M.setup = function()
  if present then
    ts_config.setup(config)

    -- treesitter specific keymaps
    vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<cr>")
  end
end

return M
