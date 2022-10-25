local M = {}

local lineLengthWarning = 80
local lineLengthError = 120

local leftbracket = "" -- Curve.
local rightbracket = "" -- Curve.

local function highlight(group, fg, bg)
  vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg, bg))
end

M.setup = function()
  local gl = require "galaxyline"
  local condition = require "galaxyline.condition"
  local diagnostic = require "galaxyline.provider_diagnostic"
  local vcs = require "galaxyline.provider_vcs"
  local fileinfo = require "galaxyline.provider_fileinfo"
  local extension = require "galaxyline.provider_extensions"
  local colors = require "galaxyline.colors"
  local buffer = require "galaxyline.provider_buffer"
  local whitespace = require "galaxyline.provider_whitespace"
  local lspclient = require "galaxyline.provider_lsp"

  local colours = require("catppuccin.palettes").get_palette()

  local section = gl.section

  local mode_map = {
    ["n"] = { "#569CD6", "NORMAL" },
    ["i"] = { "#D16969", "INSERT" },
    ["R"] = { "#D16969", "REPLACE" },
    ["c"] = { "#608B4E", "COMMAND" },
    ["v"] = { "#C586C0", "VISUAL" },
    ["V"] = { "#C586C0", "VIS-LN" },
    [""] = { "#C586C0", "VIS-BLK" },
    ["s"] = { "#FF8800", "SELECT" },
    ["S"] = { "#FF8800", "SEL-LN" },
    [""] = { "#DCDCAA", "SEL-BLK" },
    ["t"] = { "#569CD6", "TERMINAL" },
    ["Rv"] = { "#D16D69", "VIR-REP" },
    ["rm"] = { "#FF0000", "- More -" },
    ["r"] = { "#FF0000", "- Hit-Enter -" },
    ["r?"] = { "#FF0000", "- Confirm -" },
    ["cv"] = { "#569CD6", "Vim Ex Mode" },
    ["ce"] = { "#569CD6", "Normal Ex Mode" },
    ["!"] = { "#569CD6", "Shell Running" },
  }

  local function setLineWidthColours()
    local colbg = colours.blue
    local linebg = colours.blue

    if vim.fn.col "." > lineLengthError then
      colbg = colours.red
    elseif vim.fn.col "." > lineLengthWarning then
      colbg = colours.yellow
    end

    if vim.fn.strwidth(vim.fn.getline ".") > lineLengthError then
      linebg = colours.red
    elseif vim.fn.strwidth(vim.fn.getline ".") > lineLengthWarning then
      linebg = colours.yellow
    end

    highlight("LinePosHlBorder", linebg, colors.bg)
    highlight("LinePosHighlightColNum", colours.mantle, colbg)
    highlight("LineLenHighlightLenNum", colours.mantle, linebg)
  end

  -- LEFT
  section.left = {}

  -- Vim mode
  table.insert(section.left, {
    ViModeSpaceOnFarLeft = {
      provider = function()
        return " "
      end,
      highlight = { colours.green, colors.bg },
    },
  })
  table.insert(section.left, {
    ViModeLeft = {
      provider = function()
        highlight("ViModeHighlight", mode_map[vim.fn.mode()][1], colors.bg)
        return leftbracket
      end,
      highlight = "ViModeHighlight",
    },
  })
  table.insert(section.left, {
    ViModeIconAndText = {
      provider = function()
        highlight("GalaxyViMode", colors.modetext, mode_map[vim.fn.mode()][1])

        return " " .. mode_map[vim.fn.mode()][2]
      end,
      highlight = "GalaxyViMode",
    },
  })
  table.insert(section.left, {
    ViModeRight = {
      provider = function()
        return rightbracket
      end,
      separator = " ",
      separator_highlight = "ViModeHighlight",
      highlight = "ViModeHighlight",
    },
  })

  -- Git Branch Name
  table.insert(section.left, {
    GitStart = {
      provider = function()
        return leftbracket
      end,
      condition = condition.check_git_workspace,
      highlight = { colours.green, colors.bg },
    },
  })
  table.insert(section.left, {
    GitIcon = {
      provider = function()
        return "  "
      end,
      condition = condition.check_git_workspace,
      separator = "",
      separator_highlight = { "NONE", colours.green },
      highlight = { colours.crust, colours.green },
    },
  })
  table.insert(section.left, {
    GitBranch = {
      provider = "GitBranch",
      condition = condition.check_git_workspace,
      separator_highlight = { "NONE", colours.green },
      highlight = { colours.crust, colours.green },
    },
  })
  table.insert(section.left, {
    GitEnd = {
      provider = function()
        return rightbracket .. " "
      end,
      condition = condition.check_git_workspace,
      highlight = { colours.green, colours.green },
    },
  })

  -- Git Changes
  table.insert(section.left, {
    DiffAdd = {
      provider = "DiffAdd",
      condition = condition.check_git_workspace,
      icon = "  ",
      highlight = { colors.green, colours.green },
    },
  })
  table.insert(section.left, {
    DiffModified = {
      provider = "DiffModified",
      condition = condition.check_git_workspace,
      icon = "  ",
      highlight = { colors.blue, colours.green },
    },
  })
  table.insert(section.left, {
    DiffRemove = {
      provider = "DiffRemove",
      condition = condition.check_git_workspace,
      icon = "  ",
      highlight = { colors.red, colours.green },
    },
  })
  table.insert(section.left, {
    EndGit = {
      provider = function()
        return rightbracket
      end,
      condition = condition.check_git_workspace,
      separator = " ",
      separator_highlight = { colours.green, colors.bg },
      highlight = { colours.green, colors.bg },
    },
  })

  -- Lsp Client
  table.insert(section.left, {
    LspStart = {
      provider = function()
        return leftbracket
      end,
      highlight = { colours.teal, colors.bg },
    },
  })
  table.insert(section.left, {
    LspIcon = {
      provider = function()
        highlight("LspNameHl", colours.mantle, colours.teal)
        local name = ""
        if gl.lspclient ~= nil then
          name = gl.lspclient()
        end
        return "" .. name
      end,
      separator = " ",
      separator_highlight = "LspNameHl",
      highlight = "LspNameHl",
    },
  })
  table.insert(section.left, {
    ShowLspClient = {
      provider = "GetLspClient",
      highlight = "LspNameHl",
    },
  })
  table.insert(section.left, {
    LspEnd = {
      provider = function()
        return rightbracket .. " "
      end,
      highlight = { colours.teal, colours.bg },
    },
  })

  -- Diagnostics
  table.insert(section.left, {
    DiagnosticError = {
      provider = "DiagnosticError",
      icon = "  ",
      separator_highlight = { colours.red, colors.bg },
      highlight = { colors.red, colours.bg },
    },
  })
  table.insert(section.left, {
    DiagnosticWarn = {
      provider = "DiagnosticWarn",
      icon = "  ",
      highlight = { colors.yellow, colours.bg },
    },
  })
  table.insert(section.left, {
    DiagnosticHint = {
      provider = "DiagnosticHint",
      icon = "  ",
      highlight = { colors.blue, colours.bg },
    },
  })
  table.insert(section.left, {
    DiagnosticInfo = {
      provider = "DiagnosticInfo",
      icon = "  ",
      highlight = { colors.sapphire, colours.bg },
    },
  })

  section.right = {}

  table.insert(section.right, {
    TypeSectionStart = {
      provider = function()
        highlight("BufferSectionHlBorder", colours.surface0, colors.bg)
        return leftbracket
      end,
      highlight = "BufferSectionHlBorder",
    },
  })
  table.insert(section.right, {
    FileIcon = {
      provider = "FileIcon",
      highlight = { colors.typeicon, colours.surface0 },
    },
  })
  table.insert(section.right, {
    BufferType = {
      provider = "FileTypeName",
      highlight = { colors.typetext, colours.surface0 },
    },
  })
  table.insert(section.right, {
    TypeSectionEnd = {
      provider = function()
        return rightbracket
      end,
      highlight = "BufferSectionHlBorder",
    },
  })

  -- Cursor Position Section
  table.insert(section.right, {
    VerticlePosStart = {
      provider = function()
        highlight("VerticalPosBorderHl", colours.teal, colors.bg)
        return leftbracket
      end,
      separator = "  ",
      separator_highlight = { colours.teal, colors.bg },
      highlight = "VerticalPosBorderHl",
    },
  })
  table.insert(section.right, {
    VerticalPosAndSize = {
      provider = function()
        highlight("VerticalPosAndSizeHl", colours.mantle, colours.teal)
        return string.format(" %s /%4i ", vim.fn.line ".", vim.fn.line "$")
      end,
      highlight = "VerticalPosAndSizeHl",
    },
  })
  table.insert(section.right, {
    VerticlePosEnd = {
      provider = function()
        return rightbracket
      end,
      highlight = "VerticalPosBorderHl",
    },
  })
  table.insert(section.right, {
    CursorColumnStart = {
      provider = function()
        return leftbracket
      end,
      separator = "  ",
      separator_highlight = { colours.blue, colors.bg },
      highlight = "LinePosHlBorder",
    },
  })
  table.insert(section.right, {
    CursorColumn = {
      provider = function()
        setLineWidthColours()
        return "" .. string.format("%3i", vim.fn.col ".") .. " /"
      end,
      highlight = "LinePosHighlightColNum",
    },
  })
  table.insert(section.right, {
    LineLength = {
      provider = function()
        return " " .. string.format("%3i", string.len(vim.fn.getline "."))
      end,
      highlight = "LineLenHighlightLenNum",
    },
  })
  table.insert(section.right, {
    CursorColumnEnd = {
      provider = function()
        return rightbracket
      end,
      highlight = "LinePosHlBorder",
    },
  })

  -- Left Short
  section.short_line_left = {}

  table.insert(section.short_line_left, {
    LeftShortName = {
      provider = "FileTypeName",
      highlight = { colors.shorttext, colors.shortbg },
    },
  })
  table.insert(section.short_line_left, {
    LeftShortFileName = {
      provider = "SFileName",
      condition = condition.buffer_not_empty,
      separator_highlight = { colors.shorttext, colors.shortbg },
      highlight = { colors.shorttext, colors.shortbg },
    },
  })

  -- Right Short
  section.short_line_right = {}

  table.insert(section.short_line_right, {
    BufferIcon = {
      provider = "BufferIcon",
      separator_highlight = { colors.shorttext, colors.bg },
      highlight = { colors.shortrighttext, colors.bg },
    },
  })

  -- only have a single status line
  vim.go.laststatus = 3
end

return M
