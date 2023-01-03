--[[
-- @usage 
-- local exec = require 'envi.core.exec'
-- exec.ls '../'
-- exec.cat 'README.md' 
--]]
local M = {}

local function exec(bin)
  return function(rest)
    local cmd = bin .. " " .. (rest or "")
    local handle = assert(io.popen(cmd))
    local result = handle:read "*a"
    handle:close()

    return result
  end
end

return setmetatable(M, {
  __index = function(_, index)
    return exec(index)
  end,
})
