local M = {}

local dashboard = require "dashboard"

--[[ dashboard.custom_header = { ]]
vim.cmd [[ let g:dashboard_custom_header = [
  \"",
  \"",
  \"",
  \"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
  \"⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀ ",
  \"⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀ ",
  \"⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀ ",
  \"⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀ ",
  \"⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀ ",
  \"⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀ ",
  \"⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀ ",
  \"⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀ ",
  \"⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿⠇⠀ ",
  \"⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿⡟⠀⠀ ",
  \"⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀ ",
  \"⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀ ",
  \"⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀ ",
  \"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
  \"",
  \"",
  \"",
\] ]]

dashboard.hide_statusline = true
dashboard.hide_tabline = true
dashboard.preview_file_height = 12
dashboard.preview_file_width = 80

-- dashboard.custom_header = {
--   [[                                                   /]],
--   [[                                                 .7 ]],
--   [[                                      \       , //  ]],
--   [[                                      |\.--._/|//   ]],
--   [[                                     /\ ) ) ).'/    ]],
--   [[                                    /(  \  // /     ]],
--   [[                                   /(   J`((_/ \    ]],
--   [[                                  / ) | _\     /    ]],
--   [[                                 /|)  \  eJ    L    ]],
--   [[                                |  \ L \   L   L    ]],
--   [[                               /  \  J  `. J   L    ]],
--   [[                               |  )   L   \/   \    ]],
--   [[                              /  \    J   (\   /    ]],
--   [[            _....___         |  \      \   \```     ]],
--   [[     ,.._.-'        '''--...-||\     -. \   \       ]],
--   [[   .'.=.'                    `         `.\ [ Y      ]],
--   [[  /   /                                  \]  J      ]],
--   [[ Y / Y                                    Y   L     ]],
--   [[ | | |          \                         |   L     ]],
--   [[ | | |           Y                        A  J      ]],
--   [[ |   I           |                       /I\ /      ]],
--   [[ |    \          I             \        ( |]/|      ]],
--   [[ J     \         /._           /        -tI/ |      ]],
--   [[  L     )       /   /'-------'J           `'-:.     ]],
--   [[  J   .'      ,'  ,' ,     \   `'-.__          \    ]],
--   [[   \ T      ,'  ,'   )\    /|        ';'---7   /    ]],
--   [[    \|    ,'L  Y...-' / _.' /         \   /   /     ]],
--   [[     J   Y  |  J    .'-'   /         ,--.(   /      ]],
--   [[      L  |  J   L -'     .'         /  |    /\      ]],
--   [[      |  J.  L  J     .-;.-/       |    \ .' /      ]],
--   [[      J   L`-J   L____,.-'`        |  _.-'   |      ]],
--   [[       L  J   L  J                  ``  J    |      ]],
--   [[       J   L  |   L                     J    |      ]],
--   [[        L  J  L    \                    L    \      ]],
--   [[        |   L  ) _.'\                    ) _.'\     ]],
--   [[        L    \('`    \                  ('`    \    ]],
--   [[         ) _.'\`-....'                   `-....'    ]],
--   [[        ('`    \                                    ]],
--   [[         `-.___/   schweeeeeeeeeeeeeeeeeeeeeeee     ]],
-- }

M.setup = function()
  dashboard.setup {
    theme = "hyper",
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        { desc = "  Find File  ", action = "Telescope find_files", key = "f" },
        { desc = "  Recents    ", action = "Telescope oldfiles", key = "o" },
        { desc = "  Find Word  ", action = "Telescope live_grep", key = "/" },
        { desc = "洛 New File   ", action = "new", key = "n" },
      },
    },
    packages = { enable = true },
    project = { enable = false },
    mru = {},
  }
end

return M
