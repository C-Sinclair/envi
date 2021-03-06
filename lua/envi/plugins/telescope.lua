local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local action_state = require "telescope.actions.state"

local config = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    -- winblend = 0,
    -- border = {},
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    -- use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  },
}

local M = {}

M.setup = function()
  telescope.setup(config)

  local extensions = { "emoji", "node_modules" }

  pcall(function()
    for _, ext in ipairs(extensions) do
      telescope.load_extension(ext)
    end
  end)

  --[[
  Keymaps
  --]]

  -- show project files
  vim.keymap.set("n", "<C-p>", function()
    require("telescope.builtin").find_files {}
  end)

  -- search by characters
  vim.keymap.set("n", "<C-f>", function()
    require("telescope.builtin").live_grep()
  end)

  -- reopen last search
  vim.keymap.set("n", "<C-t><C-t>", function()
    require("telescope.builtin").resume()
  end)

  -- show open buffers
  vim.keymap.set({ "n", "t" }, "<C-b>", "<cmd>Telescope buffers<cr>")

  -- show git worktrees
  vim.keymap.set("n", "<leader>gb", function()
    require("telescope").extensions.git_worktree.git_worktrees()
  end)

  -- create new worktree branch
  vim.keymap.set("n", "<leader>gn", function()
    require("telescope").extensions.git_worktree.create_git_worktree()
  end)
end

return M
