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
  use {
    "nathom/filetype.nvim",
    config = function()
      require("filetype").setup {
        complex = {
          -- handle blog tera templates
          ["templates/*.html"] = "htmldjango",
          ["templates/**/*.html"] = "htmldjango",
        },
      }
    end,
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

  -- manage lsp servers and 3rd party deps
  use {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "astro",
          "lua_ls",
          "rust_analyzer",
          "bashls",
          "cssls",
          "eslint",
          "elixirls",
          "elmls",
          "gopls",
          "html",
          "tsserver",
          "jsonls",
          "rnix",
          "tailwindcss",
          "teal_ls",
          "zls",
          "svelte",
        },
      }
    end,
  }

  use {
    "jay-babu/mason-null-ls.nvim",
    requires = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function() end,
  }

  -- lsp stuff
  use "neovim/nvim-lspconfig"

  use { "elixir-tools/elixir-tools.nvim", requires = { "nvim-lua/plenary.nvim" } }

  -- formatting
  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("envi.plugins.null-ls").setup()
    end,
  }

  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup {
        outline = {
          keys = {
            jump = "<enter>",
            expand_collapse = "<tab>",
          },
        },
      }
    end,
    requires = { { "nvim-tree/nvim-web-devicons" } },
  }

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

  use {
    "themaxmarchuk/tailwindcss-colors.nvim",
    -- load only on require("tailwindcss-colors")
    module = "tailwindcss-colors",
    -- run the setup function after plugin is loaded
    config = function()
      -- pass config options here (or nothing to use defaults)
      require("tailwindcss-colors").setup()
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

  -- comments
  use {
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gcc", "gcb" },
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

  use {
    "natecraddock/telescope-zf-native.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "zf-native"
    end,
  }

  use {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      require("telescope").load_extension "advanced_git_search"
    end,
    requires = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
    },
  }

  use { "axkirillov/easypick.nvim", requires = "nvim-telescope/telescope.nvim" }

  -- time tracking
  use { "wakatime/vim-wakatime" }

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

  use "simrat39/rust-tools.nvim"

  -- lua repl and evaluation
  -- use {
  --   "bfredl/nvim-luadev",
  --   config = function() end,
  -- }

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

  -- lua help inside vim
  use "milisims/nvim-luaref"

  use "folke/neodev.nvim"

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
    "zdcthomas/yop.nvim",
    config = function()
      require("envi.plugins.yop").setup()
    end,
  }

  --[[ use {
    "rcarriga/nvim-notify",
    config = function()
      -- set notify for other plugins
      vim.notify = require "notify"
    end,
  } ]]
  --[[ use { ]]
  --[[   "tenxsoydev/karen-yank.nvim", ]]
  --[[   config = function() ]]
  --[[     require("karen-yank").setup { ]]
  --[[       mappings = { ]]
  --[[         disable = { "s", "S" }, ]]
  --[[       }, ]]
  --[[     } ]]
  --[[   end, ]]
  --[[ } ]]

  use {
    "chrisgrieser/nvim-spider",
    config = function()
      local spider = require "spider"
      spider.setup {}

      vim.keymap.set({ "n", "o", "x" }, "w", function()
        spider.motion "w"
      end, { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", function()
        spider.motion "e"
      end, { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", function()
        spider.motion "b"
      end, { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", function()
        spider.motion "ge"
      end, { desc = "Spider-ge" })
    end,
  }

  --[[ use { ]]
  --[[   "hkupty/iron.nvim", ]]
  --[[   config = function() ]]
  --[[     require("envi.plugins.iron").setup() ]]
  --[[   end, ]]
  --[[ } ]]
end)
