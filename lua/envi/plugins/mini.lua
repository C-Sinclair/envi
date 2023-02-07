local M = {}

M.setup = function()
  require("mini.ai").setup()
  require("mini.move").setup()
  --[[ require("mini.surround").setup() ]]
  local MiniBuf = require "mini.bufremove"
  MiniBuf.setup {}
  -- hide the current buffer
  vim.keymap.set("n", "<leader>X", function()
    MiniBuf.unshow(0)
  end)
  -- close the current buffer
  vim.keymap.set("n", "<leader>x", function()
    MiniBuf.delete(0, false)
  end)
end

return M
