-- re-source this file
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")

local ls = require "luasnip"

-- snippet creator
-- s(<trigger>, <nodes>)
local s = ls.s

-- format node
-- fmt(<fmt_string>, {...nodes})
local fmt = require("luasnip.extras.fmt").fmt

-- lambda
local l = require("luasnip.extras").lambda

-- dynamic lambda
local dl = require("luasnip.extras").dynamic_lambda

-- insert node
-- i(<position>, [default_text])
local i = ls.insert_node

-- repeat a node
-- rep(<position>)
local rep = require("luasnip.extras").rep
