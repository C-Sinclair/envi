local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  -- run tasks etc
  use "nvim-lua/plenary.nvim"

  -- speed up lua imports
  use "lewis6991/impatient.nvim"

  -- a better & faster filetype plugin
  use { "nathom/filetype.nvim" }

  -- packer installs plugins (and itself)
  use {
    "wbthomason/packer.nvim",
    event = "VimEnter",
  }

  -- icons!
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("envi.plugins.icons").setup()
    end,
  }

  -- indent blank lines
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("envi.plugins.blankline").setup()
    end,
  }

  -- highlight colours in code
  use {
    "NvChad/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("envi.plugins.colorizer").setup()
    end,
  }

  -- builds an AST of the current buffer for highlighting and navigation purposes
  use {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    run = ":TSUpdate",
    config = function()
      require("envi.plugins.treesitter").setup()
    end,
  }

  -- extends Treesitter with more objects
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  }

  -- view the treesitter AST
  use {
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  }

  -- git stuff
  use {
    "lewis6991/gitsigns.nvim",
    opt = true,
    config = function()
      require("envi.plugins.gitsigns").setup()
    end,
  }

  -- lsp stuff
  use "neovim/nvim-lspconfig"

  -- function signatures in lsp
  use {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("envi.plugins.lsp_signature").setup()
    end,
  }

  -- lsp status
  use {
    "nvim-lua/lsp-status.nvim",
    after = "nvim-lspconfig",
    as = "lsp-status",
    config = function()
      require("envi.plugins.lsp_status").setup()
    end,
  }

  -- extend '%' to hop between extra stuff!
  use { "andymass/vim-matchup" }

  -- autocomplete
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("envi.plugins.cmp").setup()
    end,
  }

  -- snippets
  use {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = function()
      require("envi.plugins.luasnip").setup()
    end,
  }

  -- snippets added to autocomplete
  use {
    "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
  }

  -- autocomplete for lua
  use {
    "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip",
  }

  use {
    "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua",
  }

  use {
    "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp",
  }

  use {
    "hrsh7th/cmp-path",
    after = "cmp-buffer",
  }

  use {
    "hrsh7th/cmp-emoji",
    after = "cmp-path",
  }

  -- automatically close brackets
  use {
    "windwp/nvim-autopairs",
    after = "nvim-treesitter",
    config = function()
      require("envi.plugins.autopairs").setup()
    end,
  }

  -- auto close/rename jsx tags
  use {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup {
        "html",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "rescript",
      }
    end,
  }

  -- starting dashboard
  use {
    "glepnir/dashboard-nvim",
    config = function()
      require("envi.plugins.dashboard").setup()
    end,
  }

  -- comments
  use {
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gcc" },
    config = function()
      require("envi.plugins.comment").setup()
    end,
  }

  -- better typescript commenting
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    after = { "nvim-treesitter", "Comment.nvim" },
  }

  -- popup fuzzy searching
  use {
    "nvim-telescope/telescope.nvim",
    module = "telescope",
    config = function()
      require("envi.plugins.telescope").setup()
    end,
  }

  -- search node_modules
  use {
    "nvim-telescope/telescope-node-modules.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
  }

  -- search emojis
  use {
    "xiyaowong/telescope-emoji.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
  }

  use {
    "nvim-telescope/telescope-dap.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "dap"
    end,
  }

  -- time tracking
  use { "wakatime/vim-wakatime" }

  -- formatting
  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("envi.plugins.null-ls").setup()
    end,
  }

  -- different way of marking files
  use {
    "ThePrimeagen/harpoon",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension "harpoon"
    end,
  }

  -- AI code completion
  use {
    "github/copilot.vim",
    config = function()
      require("envi.plugins.copilot").setup()
    end,
  }

  -- interactive LISPs and such
  -- use {
  --   "Olical/conjure",
  --   config = function()
  --     require("envi.plugins.conjure").setup()
  --   end,
  -- }
  --
  -- use "tpope/vim-sexp-mappings-for-regular-people"

  -- file explorer
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("envi.plugins.neotree").setup()
    end,
  }

  -- theme
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }

  -- status line
  use {
    "nvim-lualine/lualine.nvim",
    after = "catppuccin",
    config = function()
      require("envi.plugins.lualine").setup()
    end,
  }

  -- symbols tree viewer
  use {
    "simrat39/symbols-outline.nvim",
    after = "nvim-treesitter",
    config = function()
      require("envi.plugins.symbols").setup()
    end,
  }

  -- todo comments
  use {
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("todo-comments").setup {
        vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<cr>"),
      }
    end,
  }

  -- git diff
  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
  }

  -- github integration
  use {
    "pwntester/octo.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  }

  -- git viewer
  use {
    "TimUntersberger/neogit",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local neogit = require "neogit"
      neogit.setup {
        integrations = {
          diffview = true,
        },
      }
      vim.keymap.set("n", "<leader>gg", neogit.open)
    end,
  }

  -- nvim debugger
  use {
    "mfussenegger/nvim-dap",
    config = function()
      require "envi.plugins.dap"
    end,
  }
  use {
    "theHamsta/nvim-dap-virtual-text",
    requires = "mfussenegger/nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  }
  use { "mfussenegger/nvim-dap-python", requires = "mfussenegger/nvim-dap" }
  -- use "mfussenegger/nvim-dap-go"

  use "simrat39/rust-tools.nvim"

  -- lua repl and evaluation
  -- use {
  --   "bfredl/nvim-luadev",
  --   config = function() end,
  -- }

  use {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup {
        default_direction = "left",
        on_attach = function(bufnr)
          -- Toggle the aerial window with <leader>a
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
          -- Jump forwards/backwards with '{' and '}'
          vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
          vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
          -- Jump up the tree with '[[' or ']]'
          vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
          vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
        end,
      }
    end,
  }
end)
