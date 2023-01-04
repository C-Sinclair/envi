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

local i = ls.insert_node
local sn = ls.snippet_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local r = ls.restore_node
local f = ls.function_node

-- repeat a node
-- rep(<position>)
local rep = require("luasnip.extras").rep

-- full credit to this genius for this one
-- https://github.com/garcia5/dotfiles/blob/master/files/nvim/lua/ag/plugin-conf/luasnip.lua
local ts_function_fmt = [[
{doc}
{type} {async}{name}({params}): {ret} {{
	{body}
}}
]]
local ts_function_snippet = function(type)
  return fmt(ts_function_fmt, {
    doc = f(function(args)
      local params_str = args[1][1]
      local return_type = args[2][1]
      local nodes = { "/**" }
      for _, param in ipairs(vim.split(params_str, ",", true)) do
        local name = param:match "([%a%d_-]+):?"
        local t = param:match ": ?([%S^,]+)"
        if name then
          local str = " * @param " .. name
          if t then
            str = str .. " {" .. t .. "}"
          end
          table.insert(nodes, str)
        end
      end
      vim.list_extend(nodes, { " * @returns " .. return_type, " */" })
      return nodes
    end, { 3, 4 }),
    type = t(type),
    async = c(1, { t "async ", t "" }),
    name = i(2, "funcName"),
    params = i(3),
    ret = d(4, function(args)
      local async = string.match(args[1][1], "async")
      if async == nil then
        return sn(nil, {
          r(1, "return_type", i(nil, "void")),
        })
      end
      return sn(nil, {
        t "Promise<",
        r(1, "return_type", i(nil, "void")),
        t ">",
      })
    end, { 1 }),
    body = i(0),
  }, {
    stored = {
      ["return_type"] = i(nil, "void"),
    },
  })
end
local ts_loop_fmt = [[
{type}({async}({item}) => {{
	{body}
}})
]]
local ts_loop_snippet = function(type)
  return fmt(ts_loop_fmt, {
    type = t(type),
    async = c(1, { t "", t "async " }),
    item = c(2, { i(1, "item"), sn(nil, { t "{ ", i(1, "field"), t " }" }) }),
    body = i(0),
  })
end

ls.add_snippets("typescript", {
  s("ig", fmt("//@ts-ignore", {})),
  s("fun", ts_function_snippet ""),
  s("public", ts_function_snippet "public"),
  s("private", ts_function_snippet "private"),
  s(
    "describe",
    fmt(
      [[
describe('{suite}', () => {{
	{body}
}});
        ]],
      {
        suite = i(1, "function or module"),
        body = i(0),
      }
    )
  ),
  s(
    "it",
    fmt(
      [[
it('{test_case}', {async}() => {{
	{body}
}});
    ]],
      {
        test_case = i(1, "does something"),
        async = c(2, { t "async ", t "" }),
        body = i(0),
      }
    )
  ),
  s("map", ts_loop_snippet "map"),
  s("filter", ts_loop_snippet "filter"),
})

ls.add_snippets("typescriptreact", {
  s(
    "comp",
    fmt(
      "type {}Props = {{\n {}: {};\n }}\n\nexport function {}({{ {} }}: {}Props): Jsx {{\n\treturn (\n\t\t<>{}</>\n\t)\n}}\n",
      { dl(1, l.TM_FILENAME, {}), i(2), i(3), rep(1), rep(2), rep(1), i(4) }
    )
  ),
  s(
    "hook",
    fmt(
      "type Use{}Props = {{\n {}: {};\n}}\n\ntype Use{}Res = {{\n {}: {};\n}}\n\nexport function use{}({{ {} }}: Use{}Props): Use{}Res {{\n\treturn {}\n}}\n",
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
})
