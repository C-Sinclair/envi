local M = {}

M.setup = function()
  local lualine_present, lualine = pcall(require, "lualine")
  if lualine_present then
    lualine.setup {
      sections = {
        lualine_x = { "aerial" },
      },
      options = {
        theme = "catppuccin",
      },
    }
  end
end

return M
