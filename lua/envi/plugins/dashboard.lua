vim.g.dashboard_disable_at_vimenter = 0
vim.g.dashboard_disable_statusline = 1
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_header = {
	[[                                                   /]],
	[[                                                 .7 ]],
	[[                                      \       , //  ]],
	[[                                      |\.--._/|//   ]],
	[[                                     /\ ) ) ).'/    ]],
	[[                                    /(  \  // /     ]],
	[[                                   /(   J`((_/ \    ]],
	[[                                  / ) | _\     /    ]],
	[[                                 /|)  \  eJ    L    ]],
	[[                                |  \ L \   L   L    ]],
	[[                               /  \  J  `. J   L    ]],
	[[                               |  )   L   \/   \    ]],
	[[                              /  \    J   (\   /    ]],
	[[            _....___         |  \      \   \```     ]],
	[[     ,.._.-'        '''--...-||\     -. \   \       ]],
	[[   .'.=.'                    `         `.\ [ Y      ]],
	[[  /   /                                  \]  J      ]],
	[[ Y / Y                                    Y   L     ]],
	[[ | | |          \                         |   L     ]],
	[[ | | |           Y                        A  J      ]],
	[[ |   I           |                       /I\ /      ]],
	[[ |    \          I             \        ( |]/|      ]],
	[[ J     \         /._           /        -tI/ |      ]],
	[[  L     )       /   /'-------'J           `'-:.     ]],
	[[  J   .'      ,'  ,' ,     \   `'-.__          \    ]],
	[[   \ T      ,'  ,'   )\    /|        ';'---7   /    ]],
	[[    \|    ,'L  Y...-' / _.' /         \   /   /     ]],
	[[     J   Y  |  J    .'-'   /         ,--.(   /      ]],
	[[      L  |  J   L -'     .'         /  |    /\      ]],
	[[      |  J.  L  J     .-;.-/       |    \ .' /      ]],
	[[      J   L`-J   L____,.-'`        |  _.-'   |      ]],
	[[       L  J   L  J                  ``  J    |      ]],
	[[       J   L  |   L                     J    |      ]],
	[[        L  J  L    \                    L    \      ]],
	[[        |   L  ) _.'\                    ) _.'\     ]],
	[[        L    \('`    \                  ('`    \    ]],
	[[         ) _.'\`-....'                   `-....'    ]],
	[[        ('`    \                                    ]],
	[[         `-.___/   schweeeeeeeeeeeeeeeeeeeeeeee     ]],
}

vim.g.dashboard_custom_section = {
	a = { description = { '  Find File                 Ctrl p' }, command = 'Telescope find_files' },
	b = { description = { '  Recents                         ' }, command = 'Telescope oldfiles' },
	c = { description = { '  Find Word                 Ctrl f' }, command = 'Telescope live_grep' },
	d = { description = { '洛 New File                        ' }, command = 'DashboardNewFile' },
	e = { description = { '  Marks              Ctrl G Ctrl G' }, command = 'Telescope harpoon marks' },
}

vim.g.dashboard_custom_footer = {
	'   ',
}

local M = {}

M.setup = function() end

return M
