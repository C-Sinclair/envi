local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local builtin = require "telescope.builtin"
local sorters = require "telescope.sorters"
local previewers = require "telescope.previewers"
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
  vim.keymap.set("n", "<C-p>", function()
    local opts = {}
    local ok = pcall(builtin.git_files, opts)
    if not ok then
      builtin.find_files(opts)
    end
  end)

  -- search by characters
  vim.keymap.set("n", "<C-f>", function()
    builtin.live_grep()
  end)

  -- reopen last search
  vim.keymap.set("n", "<C-t><C-t>", function()
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

  --[[
  -- @deprecated
  -- This was how I did it originally, but it requires a double smash (because of Tmux)
  --]]
  vim.keymap.set({ "n", "t" }, "<C-b>", buffers_picker)

  -- show diagnostic issues
  vim.keymap.set("n", "<C-t><C-d>", function()
    builtin.diagnostics()
  end)
end

return M
