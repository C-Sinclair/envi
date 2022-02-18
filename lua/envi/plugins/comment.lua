local M = {}

M.setup = function()
  local present, nvim_comment = pcall(require, "Comment")
  if present then
    local config = {}
    nvim_comment.setup(config)
  end
end

return M
