--[[
-- Heavily inspired by https://github.com/ThePrimeagen/git-worktree.nvim/
--]]

local utils = require "telescope.utils"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local conf = require("telescope.config").values
local Job = require "plenary.job"
local Log = require "plenary.log"

local M = {}

--[[
@usage 
logger.info(foo)
logger.error(bar)
--]]
local logger = Log:new {
  name = "envi.worktree",
  level = Log.DEBUG,
}

--[[
Executes a CLI command synchronously and returns stdout
@param table cmd -- list of cli args
@returns string result
@usage local result = exec {'git', 'rev-parse', '--show-toplevel'}
--]]
local exec = function(args)
  local cwd = vim.loop.cwd()
  local command = table.remove(args, 1)
  local result, code = Job
    :new({
      command = command,
      args = args,
      cwd = cwd,
    })
    :sync()
  if code ~= 0 then
    logger("Error in cmd running: " .. table.concat(args, " "))
    return
  end
  return result
end

--[[
Checks if currently open repo is a git worktree 
--]]
local is_worktree_dir = function()
  local is_worktree = exec {
    "git",
    "rev-parse",
    "--is-inside-work-tree",
  } -- { "true" }
  return is_worktree[1] == "true"
end

local get_absolute_git_root = function()
  local local_dir = exec({
    "git",
    "rev-parse",
    "--show-toplevel",
  })[1]
  if not local_dir then
    return nil
  end
  local start = local_dir:find "%.git"
  if not start then
    return nil
  end
  return local_dir:sub(1, start + 3)
end

--[[
Checks open tmux windows 
@param string name - name of the window to search by 
@returns boolean -- whether the tmux window exists 
--]]
local lookup_tmux_window = function(name)
  local window_names = exec { "tmux", "list-windows", "-F", "#{window_name}" }
  for _, window_name in ipairs(window_names) do
    if window_name == name then
      return true
    end
  end
  return false
end

--[[
@returns true if the current directory is a node project
--]]
local has_package_json = function()
  local package_json = io.open "package.json"
  if package_json then
    package_json:close()
    return true
  end
  return false
end

--[[
Switch to a new or existing tmux window
--]]
local switch_to_tmux_window = function(branch)
  local window_exists = lookup_tmux_window(branch)
  if not window_exists then
    local path = get_absolute_git_root() .. "/" .. branch
    exec { "tmux", "new-window", "-n", branch, "-c", path }
    if has_package_json() then
      exec { "tmux", "split-window", "-t", branch, "-l", 50, "-dh", "-c", path }
      exec { "tmux", "send-keys", "-t", 2, "yarn install", "Enter" }
    end
  end
  exec { "tmux", "select-window", "-t", branch }
end

--[[
Switch to an existing worktree 
--]]
local switch_to_worktree = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local branch = selection.value.branch
  switch_to_tmux_window(branch)
end

--[[
Checks local git branches
@returns true if git branch exists
--]]
local has_branch = function(branch)
  local found = false
  local cwd = vim.loop.cwd()
  local job = Job:new {
    "git",
    "branch",
    on_stdout = function(_, data)
      -- remove  markere on current branch
      data = data:gsub("*", "")
      data = vim.trim(data)
      found = found or data == branch
    end,
    cwd = cwd,
  }
  local _, code = job:sync()
  if code ~= 0 then
    logger.error "Error in checking branches"
    return
  end
  return found
end

--[[
Create a new worktree 
--]]
local create_worktree = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local branch = action_state.get_current_line()

  exec { "git", "fetch", "--all" }

  local path = get_absolute_git_root() .. "/" .. branch
  local worktree_cmd = { "git", "worktree", "add" }
  if not has_branch(branch) then
    -- need to create the branch with this flag
    table.insert(worktree_cmd, "-b")
    table.insert(worktree_cmd, branch)
    table.insert(worktree_cmd, path)
  else
    table.insert(worktree_cmd, path)
    table.insert(worktree_cmd, branch)
  end

  exec(worktree_cmd)
  logger.info("Created worktree: " .. branch)
  switch_to_tmux_window(branch)
end

--[[
Deletes the currently selected worktree 
--]]
local delete_worktree = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local branch = selection.value.branch
  logger.info("Deleting worktree: " .. branch)
  local window_exists = lookup_tmux_window(branch)
  if window_exists then
    logger.info("worktree: " .. branch .. " exists, removing it!")
    exec { "tmux", "kill-window", "-t", branch }
  end
  exec { "git", "worktree", "remove", branch }
  logger.info("Removed worktree: " .. branch)
end

--[[
Remove the square brackets
@param str: string
--]]
local strip_square_brackets = function(str)
  if not str then
    return
  end
  return str:gsub("^%[(.*)%]$", "%1")
end

--[[
Cut apart the relevant parts from the CLI returned string 
@param str: string
--]]
local parse_line = function(line)
  local fields = vim.split(string.gsub(line, "%s+", " "), " ")
  local branch = strip_square_brackets(fields[3])
  if not branch then
    return nil
  end
  local entry = {
    path = fields[1],
    sha = fields[2],
    branch = branch,
  }
  return entry
end

--[[
Open a Telescope dropdown to select or create a git worktree
@usage require('envi.worktrees').worktrees()
--]]
M.worktrees = function()
  if not is_worktree_dir() then
    logger.error "this is not a worktree project"
    return
  end
  local worktrees = utils.get_os_command_output { "git", "worktree", "list" }
  local results = {}
  for _, line in ipairs(worktrees) do
    local index = #results + 1
    local entry = parse_line(line)
    table.insert(results, index, entry)
  end

  pickers.new(themes.get_dropdown(), {
    prompt = "Worktrees",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.branch,
          ordinal = entry.branch,
        }
      end,
    },
    sorter = conf.generic_sorter(),
    attach_mappings = function(_, map)
      -- this overwrites the select a row functionality
      action_set.select:replace(switch_to_worktree)

      -- here we can set any additional attach_mappings
      map("i", "<c-n>", create_worktree)
      map("i", "<c-d>", delete_worktree)

      return true
    end,
  }):find()
end

return M
