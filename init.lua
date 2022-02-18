-- start by loading all the plugins
require "envi.plugins"

-- then load the core overwrites to nvim functionality
require "envi.core"
require "envi.core.mappings"
require "envi.core.globals"

-- load lsp specific functionality
require "envi.lsp"

-- load the theme
local theme_present, theme = pcall(require, "catppuccin")
if theme_present then
  theme.setup()
end
vim.cmd [[colorscheme catppuccin]]
