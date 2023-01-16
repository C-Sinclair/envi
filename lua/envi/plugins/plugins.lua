-- recompile this file on save
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

return require("packer").startup(function(use)
  -- packer installs plugins (and itself)
  use "wbthomason/packer.nvim"

  -- run tasks etc
  use "nvim-lua/plenary.nvim"

  -- speed up lua imports
  use "lewis6991/impatient.nvim"

  -- a better & faster filetype plugin
  use { "nathom/filetype.nvim" }

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

  use {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup()
    end,
  }

  -- view the treesitter AST
  use {
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  }

  -- git stuff
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("envi.plugins.gitsigns").setup()
    end,
  }

  -- lsp stuff
  use "neovim/nvim-lspconfig"

  -- use {
  --   "m-demare/hlargs.nvim",
  --   requires = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("hlargs").setup()
  --   end,
  -- }

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

  -- typescript specific lsp
  use "jose-elias-alvarez/typescript.nvim"

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

  use {
    "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
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
    requires = { "nvim-lua/plenary.nvim" },
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
  use {
    "natecraddock/telescope-zf-native.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "zf-native"
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
  use "sbdchd/neoformat"

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
  -- use {
  --   "github/copilot.vim",
  --   config = function()
  --     require("envi.plugins.copilot").setup()
  --   end,
  -- }

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

  use {
    "mrbjarksen/neo-tree-diagnostics.nvim",
    requires = "nvim-neo-tree/neo-tree.nvim",
    module = "neo-tree.sources.diagnostics",
  }

  -- theme
  use {
    "catppuccin/nvim",
    as = "catppuccin",
  }

  -- status line
  use {
    "glepnir/galaxyline.nvim",
    branch = "main",
    -- your statusline
    config = function()
      require("envi.plugins.galaxyline").setup()
    end,
    -- some optional icons
    requires = { "kyazdani42/nvim-web-devicons" },
  }
  --[[ use {
    "nvim-lualine/lualine.nvim",
    after = "catppuccin",
    config = function()
      require("envi.plugins.lualine").setup()
    end,
  } ]]

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
      vim.keymap.set("n", "<leader>g", neogit.open)
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
  use "rcarriga/nvim-dap-ui"

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
        layout = {
          default_direction = "left",
        },
        on_attach = function(bufnr)
          -- Toggle the aerial window with <leader>a
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
        end,
      }
    end,
  }

  -- lsp status on startup
  use {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  }

  -- pretty quickfix list
  use {
    "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    config = function()
      require("pqf").setup()
    end,
  }

  -- testing super powers
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup {
        output = {
          enabled = true,
          open_on_run = "yes",
        },
        adapters = {
          require "neotest-python" {
            runner = "pytest",
            dap = { justMyCode = false, console = "integratedTerminal" },
          },
          require "neotest-jest" {
            jestCommand = "yarn test --",
          },
          require "neotest-go",
        },
      }
    end,
  }

  -- stylish buffer switching
  use {
    "ghillb/cybu.nvim",
    branch = "main",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      local ok, cybu = pcall(require, "cybu")
      if not ok then
        return
      end
      cybu.setup()
      vim.keymap.set("n", "<c-w>N", "<cmd>CybuPrev<cr>")
      vim.keymap.set("n", "<c-w>n", "<cmd>CybuNext<cr>")
      vim.keymap.set("n", "<c-w><tab>", "<cmd>CybuLastusedNext<cr>")
    end,
  }

  -- lua help inside vim
  use "milisims/nvim-luaref"

  use "folke/neodev.nvim"

  -- smooth scrolling
  --[[ use {
    "declancm/cinnamon.nvim",
    config = function()
      require("envi.plugins.cinnamon").setup()
    end,
  } ]]

  -- browser vim!
  -- use {
  -- "glacambre/firenvim",
  -- run = function()
  -- vim.fn["firenvim#install"](0)
  -- end,
  -- }

  -- whole load of nvim extension goodness
  use {
    "echasnovski/mini.nvim",
    config = function()
      require("envi.plugins.mini").setup()
    end,
  }

  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      { "kkharji/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  }

  use {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  }

  --[[ use {
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require("noice").setup()
    end,
    requires = {
      "MunifTanjim/nui.nvim",
    },
  } ]]

  --[[ use { ]]
  --[[   "mhanberg/elixir.nvim", ]]
  --[[   requires = { "nvim-lua/plenary.nvim" }, ]]
  --[[   config = function() ]]
  --[[     require("envi.lsp.elixir").setup {} ]]
  --[[   end, ]]
  --[[ } ]]

  use {
    "~/Repos/C-Sinclair/iex.nvim",
    config = function()
      require("iex").setup {
        --[[ debug = true, ]]
      }
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  use {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup {}
    end,
  }
end)
