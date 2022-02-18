local M = {}

M.setup = function()
  local present, colorizer = pcall(require, "colorizer")
  if present then
    local config = {
      filetypes = {
        "*",
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

        -- Available modes: foreground, background
        mode = "background", -- Set the display mode.
      },
    }
    colorizer.setup(config["filetypes"], config["user_default_options"])
    vim.cmd "ColorizerReloadAllBuffers"
  end
end

return M
