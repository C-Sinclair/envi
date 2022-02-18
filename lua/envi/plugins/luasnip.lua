local M = {}

M.setup = function()
	local present, luasnip = pcall(require, 'luasnip')
	if present then
		local config = {
			history = true,
			updateevents = 'TextChanged,TextChangedI',
		}
		luasnip.config.set_config(config)
		require('luasnip/loaders/from_vscode').load()
	end
end

return M
