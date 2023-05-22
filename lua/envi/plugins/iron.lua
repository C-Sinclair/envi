local M = {}

function M.setup()
  local iron = require "iron.core"

  iron.setup {
    config = {
      -- Whether a repl should be discarded or not
      scratch_repl = true,
      -- Your repl definitions come here
      repl_definition = {
        haskell = {
          command = function(meta)
            local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
            return { "cabal", "v2-repl", filename }
          end,
        },
      },
      repl_open_cmd = require("iron.view").split.botright(40),
    },
    keymaps = {
      send_motion = "<space>sc",
      visual_send = "<space>sc",
      send_file = "<space>sf",
      send_line = "<space>sl",
      send_mark = "<space>sm",
      cr = "<space>s<cr>",
      interrupt = "<space>s<space>",
      exit = "<space>sq",
      clear = "<space>cl",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
      italic = true,
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  }

  -- iron also has a list of commands, see :h iron-commands for all available commands
  vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
  vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
  vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
  vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
end

return M
