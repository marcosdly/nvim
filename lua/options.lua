
local o, g, go = vim.o, vim.g, vim.go

-- see belloff
-- see showmatch
-- see showtabline
-- see statuscolumn
-- see statusline
-- see tab*
-- see tag*
-- see title*
-- see undo*
-- see wildcharm
-- see wildignore
-- see wildmode
-- see wildoptions
-- see winbar
-- see linespace
-- see list
-- see confirm
-- see fixendofline
-- see shortmess

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

if jit.os == 'Windows' then
  g.winaltkeys = 'no'
end
