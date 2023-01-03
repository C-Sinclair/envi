require("envi").setup()

vim.api.nvim_create_user_command("EnviReload", function()
  -- clear any loaded packages, so submodules refresh with config refresh.
  for name, _ in pairs(package.loaded) do
    if name:match "^envi" then
      package.loaded[name] = nil
    end
  end
  R("envi").setup()
end, {})
