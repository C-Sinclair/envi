-- global print function
function P(args)
  print(vim.inspect(args))
end

-- reload modules, avoiding the lua cache
function R(module)
  package.loaded[module] = nil
  require(module)
end

--[[
-- Split a string by a delimiter 
-- @param string delimiter - what to split by
-- @returns table
--]]
function string:split(delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(self, delimiter, from, true)
  while delim_from do
    if delim_from ~= 1 then
      table.insert(result, string.sub(self, from, delim_from - 1))
    end
    from = delim_to + 1
    delim_from, delim_to = string.find(self, delimiter, from, true)
  end
  if from <= #self then
    table.insert(result, string.sub(self, from))
  end
  return result
end
