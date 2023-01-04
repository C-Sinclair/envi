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

local for_ = fmt(
  [[for {item} <- {items} do
  {body}
end ]],
  {
    item = i(0),
    items = i(1),
    body = i(2),
  }
)

local if_ = fmt(
  [[if {cond} do
  {body}
end]],
  {
    cond = i(0),
    body = i(1),
  }
)

local ife = fmt(
  [[if {cond} do
  {if_body}
else
  {else_body}
end]],
  {
    cond = i(0),
    if_body = i(1),
    else_body = i(2),
  }
)

local def = fmt(
  [[def {name}({params}) do
  {body}
end]],
  {
    name = i(0),
    params = i(1),
    body = i(2),
  }
)
local defp = fmt(
  [[defp {name}({params}) do
  {body}
end]],
  {
    name = i(0),
    params = i(1),
    body = i(2),
  }
)

ls.add_snippets("elixir", {
  s("for", for_),
  s("if", if_),
  s("ife", ife),
  s("def", def),
  s("defp", defp),
})

--[[
-- TODO: case 
-- TODO: cond
-- TODO: IO.puts
-- TODO: IO inspect (with label)
-- TODO: def with doc
-- TODO: module
-- TODO: module with doc
-- TODO: require ${0:Logger}
-- TODO: test 
-- TODO: describe
-- TODO: pipe into filter
-- TODO: pipe into map
-- TODO: pipe into reduce
--]]
