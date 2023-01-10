local exec = require "envi.core.exec"

local function view_master_file()
  -- get the current file path relative to the project
  local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":p:~:.")
  -- get the owner/repo
  local owner_repo = exec.gh([[ repo view --json nameWithOwner --jq .nameWithOwner]]):split("\n")[1]
  local tmp_file_path = "/tmp/" .. filepath:gsub("/", "_")
  exec.curl(
    "--silent $(gh api /repos/" .. owner_repo .. "/contents/" .. filepath .. " --jq .download_url) > " .. tmp_file_path
  )
  -- now just open the file in a vertical split
  vim.api.nvim_command("botright vsplit " .. tmp_file_path)
end

vim.api.nvim_create_user_command("ViewMasterFile", view_master_file, {})
