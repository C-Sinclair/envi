local M = {}

M.setup = function()
  require("mini.ai").setup()
  --[[ require("mini.surround").setup() ]]

  local MiniBuf = require "mini.bufremove"
  MiniBuf.setup {}
  -- hide the current buffer
  vim.keymap.set("n", "<leader>X", function()
    MiniBuf.unshow()
  end)
  -- close the current buffer
  vim.keymap.set("n", "<leader>x", function()
    MiniBuf.delete()
  end)
end

return M
