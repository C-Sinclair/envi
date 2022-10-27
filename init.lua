require("envi").setup()

vim.api.nvim_create_user_command("EnviReload", function()
  R("envi").setup()
end, {})
