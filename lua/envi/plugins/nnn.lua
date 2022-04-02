local M = {}

M.setup = function()
  require("nnn").setup {
    picker = {
      cmd = "tmux new-session nnn ",
      style = { border = "rounded" },
    },
    explorer = {
      width = 48, -- width of the vertical split
      side = "botright", -- or "botright", location of the explorer window
      session = "shared",
    },
    replace_netrw = "explorer",
    auto_close = true,
    mappings = {
      { "<ESC>", require("nnn").builtin.close },
    },
  }

  -- open at directory of current file
  vim.keymap.set({ "n", "t" }, "<C-n>", "<cmd>NnnExplorer %:h<cr>")
  vim.keymap.set("n", "<leader>n", "<cmd>NnnPicker .<cr>")
end

return M
