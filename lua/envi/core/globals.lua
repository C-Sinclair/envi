-- global print function
function P(args)
  print(vim.inspect(args))
end

-- reload modules, avoiding the lua cache
function R(module)
  package.loaded[module] = nil
  return require(module)
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

-- [[
-- Coverts a string to snake_case
-- @type string
-- @returns string
-- ]]
function string:snake_case()
  return string
    .gsub(self, "%f[^%l]%u", "_%1")
    :gsub("%f[^%a]%d", "_%1")
    :gsub("%f[^%d]%a", "_%1")
    :gsub("(%u)(%u%l)", "%1_%2")
    :lower()
end
