local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local user_config = require("telescope.config").values

local M = {}

local function is_liveview(filepath)
  return filepath:sub(-9) == "html.heex"
end

local function is_test(filepath)
  return filepath:match "test"
end

local function view_path_from_liveview(filepath)
  -- same directory, just .ex instead
  return filepath:gsub(".html.heex$", ".ex")
end

local function liveview_path_from_view(filepath)
  -- same directory, just .html.heex instead
  return filepath:gsub(".ex$", ".html.heex")
end

local function view_path_from_test(filepath)
  return filepath:gsub("^test", "lib"):gsub("_test.exs$", ".ex")
end

local function test_path_from_view(filepath)
  return filepath:gsub("^lib", "test"):gsub(".ex$", "_test.exs")
end

local function create_finder_table(options)
  local finder = finders.new_table {
    results = options,
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry[1],
        ordinal = entry[1],
      }
    end,
  }
  return finder
end

local function display_paths_picker(options)
  local finder = create_finder_table(options)
  pickers
    .new({}, {
      prompt_title = "Elixir SUPER NAVIGATION Picker",
      finder = finder,
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry, _status)
          return user_config.buffer_previewer_maker(entry.value[2], self.state.bufnr, {})
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        -- on selection
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filepath = selection.value[2]
          vim.cmd("e " .. filepath)
        end)
        -- open in a vertical split
        map("i", "<C-v>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filepath = selection.value[2]
          vim.cmd("vs " .. filepath)
        end)
        return true
      end,
    })
    :find()
end

M.setup = function(opts)
  local elixir = require "elixir"

  local cmd = opts["language_server_cmd"] or vim.fn.expand "%" .. "/bin/elixir-ls/language_server.sh"

  elixir.setup {
    cmd = cmd,

    settings = elixir.settings {
      dialyzerEnabled = true,
      fetchDeps = true,
      enableTestLenses = true,
      suggestSpecs = true,
    },
  }

  -- shortcuts to hop between file tree

  -- TODO: router?
  vim.api.nvim_create_user_command("ElixirNav", function()
    local current_type = "view"
    local options = {}

    -- relative to project root
    local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")
    -- mutable version
    local viewpath

    if is_liveview(filepath) then
      current_type = "liveview"

      view_path = view_path_from_liveview(filepath)
      table.insert(options, { "View", view_path })
      table.insert(options, { "Test", test_path_from_view(view_path) })
    elseif is_test(filepath) then
      current_type = "test"

      view_path = view_path_from_test(filepath)
      table.insert(options, { "View", view_path })
      table.insert(options, { "Liveview", liveview_path_from_view(view_path) })
    else
      current_type = "view"
      view_path = filepath

      table.insert(options, { "Liveview", liveview_path_from_view(view_path) })
      table.insert(options, { "Test", test_path_from_view(view_path) })
    end

    display_paths_picker(options)
  end, {})

  -- TODO: fuzzy list of modules
  -- TODO: send to iex for eval
end

return M
