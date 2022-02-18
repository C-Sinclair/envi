local M = {}

M.setup = function()
	-- show harpoon marks
	vim.keymap.set('n', '<C-g><C-g>', function()
		require('telescope').extensions.harpoon.marks()
	end)

	-- drop a harpoon mark
	vim.keymap.set('n', '<C-g>d', function()
		require('harpoon.mark').add_file()
	end)
end

return M
