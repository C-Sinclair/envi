local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local user_config = require("telescope.config").values
local lspconfig = require "lspconfig"
local exec = require "envi.core.exec"
local capabilities = require "envi.lsp.capabilities"

local M = {}
M.__cache = {}

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

function M.elixir_nav()
  local options = {}
  -- relative to project root
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")

  if is_liveview(filepath) then
    local view_path = view_path_from_liveview(filepath)
    table.insert(options, { "View", view_path })
    table.insert(options, { "Test", test_path_from_view(view_path) })
  elseif is_test(filepath) then
    local view_path = view_path_from_test(filepath)
    table.insert(options, { "View", view_path })
    table.insert(options, { "Liveview", liveview_path_from_view(view_path) })
  else
    local view_path = filepath
    table.insert(options, { "Liveview", liveview_path_from_view(view_path) })
    table.insert(options, { "Test", test_path_from_view(view_path) })
  end

  -- TODO: nearest router

  display_paths_picker(options)
end

function M.elixir_nav_to_test()
  -- relative to project root
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")

  if is_liveview(filepath) then
    local view_path = view_path_from_liveview(filepath)
    local test_path = test_path_from_view(view_path)
    vim.cmd.e(test_path)
  else
    local test_path = test_path_from_view(filepath)
    vim.cmd.e(test_path)
  end
end

function M.elixir_nav_to_view()
  -- relative to project root
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")

  if is_liveview(filepath) then
    local view_path = view_path_from_liveview(filepath)
    vim.cmd.e(view_path)
  else
    local view_path = view_path_from_test(filepath)
    vim.cmd.e(view_path)
  end
end

function M.elixir_nav_to_liveview()
  -- relative to project root
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")

  if is_test(filepath) then
    local view_path = view_path_from_test(filepath)
    local live_path = liveview_path_from_view(view_path)
    vim.cmd.e(live_path)
  else
    local live_path = liveview_path_from_view(filepath)
    vim.cmd.e(live_path)
  end
end

local function get_tmux_beam_window()
  local result = exec.tmux "list-windows -a | rg 'beam.smp' | rg '(.*):(.*):.*' -or '$1:$2'"
  if not result then
    error "No IEX window running"
  end
  local spl = string.split(result, ":")
  local session = spl[1]
  local window = tonumber(spl[2])
  return session .. ":" .. window
end

function M.get_all_modules_list()
  if M.__cache.all_modules then
    return M.__cache.all_modules
  end
  local result = exec.elixir [[ --sname ping --cookie foo --rpc-eval "app@Conors-MBP-2"  '
    Application.load(:platform) # not actually necessary
    {:ok, mod} = :application.get_key(:platform, :modules)
    IO.puts(mod |>Enum.map(& &1 |> to_string |> String.replace("Elixir.", "")) |> Enum.join("\n"))'
  ]]
  local t = string.split(result, "\n")
  M.__cache.all_modules = t
  return t
end

function M.path_from_module(mod)
  return "lib/" .. mod:gsub("%.", "/"):snake_case() .. ".ex"
end

function M.get_all_modules()
  -- TODO: filter out non modules
  local mods = M.get_all_modules_list()

  pickers
    .new({}, {
      prompt_title = "Application Elixir Modules",
      finder = finders.new_table {
        results = mods,
      },
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          return { "bat", M.path_from_module(entry.value) }
        end,
      },
      --[[ previewer = previewers.new_buffer_previewer {
        define_preview = function(_, entry)
          local filepath = M.path_from_module(entry[1])
          return filepath
        end,
      }, ]]
      attach_mappings = function(prompt_bufnr, map)
        -- on selection
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filepath = M.path_from_module(selection.value[2])
          vim.cmd.e(filepath)
        end)
        -- open in a vertical split
        map("i", "<C-v>", function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filepath = M.path_from_module(selection.value[2])
          vim.cmd.vs(filepath)
        end)
        return true
      end,
    })
    :find()
end

M.setup = function(opts)
  local cmd = opts["language_server_cmd"] or vim.fn.expand "~" .. "/bin/elixir-ls"

  lspconfig.elixirls.setup {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = { cmd },
  }

  -- shortcuts to hop between file tree
  vim.api.nvim_create_user_command("ElixirNav", M.elixir_nav, {})
  vim.keymap.set("n", "<leader>tg", M.elixir_nav, {})
  vim.keymap.set("n", "<leader>nt", M.elixir_nav_to_test, {})
  vim.keymap.set("n", "<leader>nv", M.elixir_nav_to_view, {})
  vim.keymap.set("n", "<leader>nl", M.elixir_nav_to_liveview, {})

  vim.keymap.set("n", "<leader>tm", M.get_all_modules, {})
end

return M
