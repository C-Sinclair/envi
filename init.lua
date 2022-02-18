-- start by loading all the plugins
require('envi.plugins')

-- then load the core overwrites to nvim functionality
require('envi.core')
require('envi.core.mappings')
require('envi.core.globals')

-- load the theme 
require('catppuccin').setup()
vim.cmd[[colorscheme catppuccin]]

