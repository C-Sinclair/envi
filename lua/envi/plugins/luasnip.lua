local present, ls = pcall(require, "luasnip")
if not present then
  return
end

local M = {}

local types = require "luasnip.util.types"

M.setup = function()
  local config = {
    -- Remember the last snippet I was in
    history = true,

    -- Update snippet text in _real time_
    updateevents = "TextChanged,TextChangedI",

    -- Show virtual text hints for node types
    ext_opts = {
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "Operator" } },
        },
      },
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "Constant" } },
        },
      },
    },
  }
  ls.config.set_config(config)

  ---#Mappings
  -- Previous snippet region
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  -- Next snippet region
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(1) then
      ls.jump(1)
    end
  end, { silent = true })

  -- Cycle "choices" for current snippet region
  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
end

return M
