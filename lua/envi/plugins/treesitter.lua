local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
  print "treesitter not present"
  return
end

local config = {
  ensure_installed = {
    "lua",
    "vim",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
}

local M = {}

M.setup = function()
  if present then
    ts_config.setup(config)
  end
end

return M
