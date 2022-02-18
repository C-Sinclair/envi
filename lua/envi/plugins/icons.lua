local present, icons = pcall(require, "nvim-web-devicons")
if not present then
  print "nvim-web-devicons not found, icons will not be available"
  return
end

local colours = require("catppuccin.api.colors").get_colors()

local config = {
  c = {
    icon = "",
    color = colours.blue,
    name = "c",
  },
  css = {
    icon = "",
    color = colours.blue,
    name = "css",
  },
  deb = {
    icon = "",
    color = colours.cyan,
    name = "deb",
  },
  Dockerfile = {
    icon = "",
    color = colours.cyan,
    name = "Dockerfile",
  },
  html = {
    icon = "",
    color = colours.baby_pink,
    name = "html",
  },
  jpeg = {
    icon = "",
    color = colours.dark_purple,
    name = "jpeg",
  },
  jpg = {
    icon = "",
    color = colours.dark_purple,
    name = "jpg",
  },
  js = {
    icon = "",
    color = colours.sun,
    name = "js",
  },
  kt = {
    icon = "󱈙",
    color = colours.orange,
    name = "kt",
  },
  lock = {
    icon = "",
    color = colours.red,
    name = "lock",
  },
  lua = {
    icon = "",
    color = colours.blue,
    name = "lua",
  },
  mp3 = {
    icon = "",
    color = colours.white,
    name = "mp3",
  },
  mp4 = {
    icon = "",
    color = colours.white,
    name = "mp4",
  },
  out = {
    icon = "",
    color = colours.white,
    name = "out",
  },
  png = {
    icon = "",
    color = colours.dark_purple,
    name = "png",
  },
  py = {
    icon = "",
    color = colours.cyan,
    name = "py",
  },
  ["robots.txt"] = {
    icon = "ﮧ",
    color = colours.red,
    name = "robots",
  },
  toml = {
    icon = "",
    color = colours.blue,
    name = "toml",
  },
  ts = {
    icon = "ﯤ",
    color = colours.teal,
    name = "ts",
  },
  ttf = {
    icon = "",
    color = colours.white,
    name = "TrueTypeFont",
  },
  rb = {
    icon = "",
    color = colours.pink,
    name = "rb",
  },
  rpm = {
    icon = "",
    color = colours.orange,
    name = "rpm",
  },
  vue = {
    icon = "﵂",
    color = colours.vibrant_green,
    name = "vue",
  },
  woff = {
    icon = "",
    color = colours.white,
    name = "WebOpenFontFormat",
  },
  woff2 = {
    icon = "",
    color = colours.white,
    name = "WebOpenFontFormat2",
  },
  xz = {
    icon = "",
    color = colours.sun,
    name = "xz",
  },
  zip = {
    icon = "",
    color = colours.sun,
    name = "zip",
  },
}

local M = {}

M.setup = function()
  if present then
    icons.setup(config)
  end
end

return M
