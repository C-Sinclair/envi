local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local builtin = require "telescope.builtin"
local sorters = require "telescope.sorters"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local exec = require "envi.core.exec"
local easypick = require "easypick"

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
    file_sorter = sorters.get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = sorters.get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    -- winblend = 0,
    -- border = {},
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    -- use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = previewers.buffer_previewer_maker,
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
  vim.keymap.set("n", "<leader>/", function()
    builtin.find_files {}
  end)
  ---@deprecated This was how I did it originally, but it requires a double smash (because of Tmux)
  vim.keymap.set("n", "<C-p>", function()
    -- TODO: add custom language type filters
    builtin.find_files {}
  end)

  -- show recent files
  vim.keymap.set("n", "<leader>to", function()
    builtin.oldfiles {}
  end)

  -- search by characters
  vim.keymap.set("n", "<leader>f", function()
    builtin.live_grep()
  end)

  -- reopen last search
  vim.keymap.set("n", "<leader>tt", function()
    builtin.resume()
  end)

  local function buffers_picker()
    builtin.buffers {
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<C-r>", function()
          local selection = action_state.get_selected_entry()
          vim.cmd("bd " .. selection.bufnr)

          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:refresh(buffers_picker())
        end)
        return true
      end,
    }
  end

  -- show open buffers
  vim.keymap.set({ "n", "t" }, "<leader>b", buffers_picker)

  -- show diagnostic issues
  vim.keymap.set("n", "<leader>td", function()
    builtin.diagnostics()
  end)

  local base_branch = exec.git [[ symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@' ]]

  easypick.setup {
    pickers = {
      -- diff current branch with base_branch and show files that changed with respective diffs in preview
      {
        name = "changed_files",
        command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
        previewer = easypick.previewers.branch_diff { base_branch = base_branch },
      },

      -- list files that have conflicts with diffs in preview
      {
        name = "conflicts",
        command = "git diff --name-only --diff-filter=U --relative",
        previewer = easypick.previewers.file_diff(),
      },
    },
  }

  vim.keymap.set("n", "<leader>tg", "<cmd>Easypick changed_files<cr>")
  vim.keymap.set("n", "<leader>tc", "<cmd>Easypick conflicts<cr>")
end

return M
