-- re-source this file
vim.keymap.set('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>')

local ls = require('luasnip')

-- snippet creator
-- s(<trigger>, <nodes>)
local s = ls.s

-- format node
-- fmt(<fmt_string>, {...nodes})
local fmt = require('luasnip.extras.fmt').fmt

-- lambda
local l = require('luasnip.extras').lambda

-- dynamic lambda
local dl = require('luasnip.extras').dynamic_lambda

-- insert node
-- i(<position>, [default_text])
local i = ls.insert_node

-- repeat a node
-- rep(<position>)
local rep = require('luasnip.extras').rep

ls.snippets = {
	-- Available in any filetype
	all = {},
	-- Lua specific snippets
	lua = {
		s('req', fmt("local {} = require('{}')", { i(1, 'default'), rep(1) })),
		s('lf', fmt('local {} = function({})\n\t{}\nend', { i(1), i(2), i(3) })),
	},
	typescript = {
		s('ig', fmt('//@ts-ignore', {})),
	},
	typescriptreact = {
		s(
			'comp',
			fmt(
				'type {}Props = {{\n {}: {};\n }}\n\nexport function {}({{ {} }}: {}Props): Jsx {{\n\treturn (\n\t\t<>{}</>\n\t)\n}}\n',
				{ dl(1, l.TM_FILENAME, {}), i(2), i(3), rep(1), rep(2), rep(1), i(4) }
			)
		),
		s(
			'hook',
			fmt(
				'type Use{}Props = {{\n {}: {};\n}}\n\ntype Use{}Res = {{\n {}: {};\n}}\n\nexport function use{}({{ {} }}: Use{}Props): Use{}Res {{\n\treturn {}\n}}\n',
				{
					dl(1, l.TM_FILENAME, {}),
					i(2),
					i(3),
					rep(1),
					i(4),
					i(5),
					rep(1),
					rep(2),
					rep(1),
					rep(1),
					rep(2),
				}
			)
		),
	},
}
