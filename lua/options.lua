
local o, g, go = vim.o, vim.g, vim.go
local M = {}

-- see statuscolumn
-- see statusline
-- see tab*
-- see tag*
-- see title*
-- see undo*
-- see winbar

o.number = true
o.relativenumber = true -- set default
o.numberwidth = 3
-- save on focus change
o.autowrite = true
-- save on exit, edit, new
-- o.autowriteall = true
o.background = 'dark'

-- region SOFT WRAP
o.linebreak = true
o.breakat = vim.o.breakat .. '_'
-- preserve indent level on soft wrap
o.breakindent = true
-- LIST: indent at column 88, show broken line indicator (text)
o.breakindentopt = 'column:88,sbr'
o.textwidth = 88
-- endregion

-- region CWD
--[[
  When on, :cd, :tcd and :lcd without an argument changes the
  current working directory to the $HOME directory like in Unix.
  When off, those commands just print the current directory name.
  On Unix this option has no effect.
  This option cannot be set from a modeline or in the sandbox, for
  security reasons.
--]]
o.cdhome = false
-- endregion

-- keep clipboard inside neovim only
o.clipboard = ''
o.cmdheight = 2
-- highlight column, equivalent to rulers in vscode
o.colorcolumn = '88'
o.cursorline = true
o.cursorlineopt = 'screenline,number'
-- o.cursorcolumn = true
o.display = 'uhex,lastline'
-- window height is to be made equal in this direction
o.eadirection = 'hor'
o.equalalways = true
-- insert tab width in spaces instead of \t
o.expandtab = true
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
-- Number of pixel lines inserted between characters.  Useful if the font
-- uses the full character cell height, making lines touch each other.
o.mouse = 'a'
o.mousemodel = 'popup'
o.scrolloff = 5
-- o.shell = 'pwsh.exe'
o.shiftround = true
o.shiftwidth = 2
o.smarttab = true
o.softtabstop = 2
o.tabstop = 4
o.showbreak = '->'
o.showcmdloc = 'statusline'
o.sidescroll = 4
o.smoothscroll = true
o.swapfile = false
-- o.syntax = 'on'
-- o.termguicolors = true
o.virtualedit = 'onemore'
o.wildignorecase = true

-- NOTE set soft minimum height/width before setting hard minimum to avoid the
-- 'win* cannot be smaller then winmin*' error since both values are 1 by default
o.winheight = 10
o.winwidth = 24
o.winminheight = 8
o.winminwidth = 16

-- Wheter window and the buffer it is displaying are paired.
-- Forces 2 buffer windows minimum.
-- o.winfixbuf = true

-- backup file before writing by creating a copy with a different name
o.backupcopy = 'no'

-- When a bracket is inserted, briefly jump to the matching one.  The
-- jump is only done if the match can be seen on the screen.
-- go.showmatch = true

-- key used to expand command-line completion
-- go.wildchar = '<tab>'
-- same as wildchar, but works inside macros and keymap commands
-- usually this key is only used in macros/keymaps that invoke completion mode
-- go.wildcharm = '<c-z>'

-- display 'wildmenu' without completing, then each full match. Sort by buffer
-- last used
go.wildmode = 'full'
-- 'fuzzy' option still not supported for file paths
go.wildoptions = 'pum,tagfile'

-- 0: never,  1: only if there are at least two tab pages, 2: always
go.showtabline = 1

-- SEE shortmess documentation
go.shortmess = 'laoOstIcF'

go.confirm = true

o.list = true
go.listchars = 'tab:> ,trail:.,lead:.'

-- go.errorbells = true
go.belloff = ''

-- region GUI only
-- letter space in pixels
-- o.linespace = 0
-- endregion

-- region wildcard file pattern priority
M.filepattern_opt = { ignore = {}, low_priority = {} }

function M.filepattern_opt.nvim_options_apply()
  -- NOTE vim.iter is null safe so arguments may be nil just fine

  -- set ignore
  local ignore_list = vim.iter(
    vim.gsplit(vim.go.wildignore or '', ','), -- current value
    self.ignore.default,
    self.ignore[vim.opt.filetype]
  )
  ignore_list:map(vim.trim):map(string.lower)
  vim.go.wildignore = ignore_list:join(',')

  -- set low priority
  local low_priority_list = vim.iter(
    vim.gsplit(vim.go.suffixes or '', ','), -- current value
    self.low_priority.default,
    self.low_priority[vim.opt.filetype]
  )
  low_priority_list:map(vim.trim):map(string.lower)
  vim.go.suffixes = low_priority_list:join(',')
end

-- altright ignore
M.filepattern_opt.ignore.default = {'**/*.bkp', '**/*.bkp.*', '**/*.db', '**/*.db.*'}
M.filepattern_opt.ignore.python = {'**/__pycache__/', '**/*.pyc'}

-- just show with lower priority
M.filepattern_opt.low_priority.default = {}
M.filepattern_opt.low_priority.python = {'**/.venv*/'}
-- endregion


if jit.os == 'Windows' then
  go.winaltkeys = 'no'
end

return M
