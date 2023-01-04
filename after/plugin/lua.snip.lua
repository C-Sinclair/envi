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

ls.add_snippets("lua", {
  s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
  s("lf", fmt("local {} = function({})\n\t{}\nend", { i(1), i(2), i(3) })),
})
