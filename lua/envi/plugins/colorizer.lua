local M = {}

M.setup = function()
  local present, colorizer = pcall(require, "colorizer")
  if present then
    colorizer.setup {}
  end
end

return M
