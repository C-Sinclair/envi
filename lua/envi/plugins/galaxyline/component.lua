--[[
Just playing around with what a "component" framework would feel like with Galaxyline
--]]

local M = {}

local core_colours = require "galaxyline.colors"
local colours = require("catppuccin.palettes").get_palette()

local leftbracket = ""
local rightbracket = ""

local function highlight(group, fg, bg)
  vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg, bg))
end

M.Component = function(p)
  local name = p[1]

  local props = p[2]

  local border = props.bordered or false
  local leftpad = props.leftpad or false

  local bg = props.bg or core_colours.bg
  --[[ local fg = props.fg or colours.surface0 ]]
  local text_colour = props.text_colour or colours.text

  local content = props.content or function()
    return " "
  end

  local res = {}
  if leftpad then
    local leftpadItem = {}
    leftpadItem[name .. "Leftpad"] = {
      provider = function()
        return " "
      end,
    }
    table.insert(res, leftpadItem)
  end
  if border then
    local borderleftItem = {}
    borderleftItem[name .. "BorderLeft"] = {
      provider = function()
        highlight(name .. "BorderLeftHL", bg, core_colours.bg)
        return rightbracket
      end,
      highlight = name .. "BorderLeftHL",
    }
    table.insert(res, borderleftItem)
  end
  local contentItem = {}
  contentItem[name] = {
    provider = function()
      highlight(name .. "HL", text_colour, bg)
      return content()
    end,
    highlight = name .. "HL",
  }
  table.insert(res, contentItem)
  if border then
    local borderRightItem = {}
    borderRightItem[name .. "BorderRight"] = {
      provider = function()
        highlight(name .. "BorderRightHL", bg, core_colours.bg)
        return leftbracket
      end,
      highlight = name .. "BorderRightHL",
    }
    table.insert(res, borderRightItem)
  end

  return res
end

return M
