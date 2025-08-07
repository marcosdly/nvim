local M = {}

local bootstrap = require 'bootstrap'
local const = require 'lib.helpful_constants'

local o, g, go = vim.o, vim.g, vim.go

-- see statuscolumn
-- see statusline
-- see tab*
-- see tag*
-- see winbar

-- TODO quickfix menu
-- TODO native completion menu
-- TODO implement fold text and fold behavior
-- TODO choose search pattern syntax between regex and glob

-- custom things
-- TODO documentation menu
-- TODO definition cursor
-- global editorconfig
-- vscode-like ignore files and dirs per project
-- inspect editorconfig hierarchy
-- run shell command and show output as buffer (like tsoding's emacs thing)

bootstrap.SetOptions {
  -- region CWD
  --[[
    When on, :cd, :tcd and :lcd without an argument changes the
    current working directory to the $HOME directory like in Unix.
    When off, those commands just print the current directory name.
    On Unix this option has no effect.
    This option cannot be set from a modeline or in the sandbox, for
    security reasons.
  ]]
  cdhome = false,
  -- endregion

  -- region INTERFACE
  -- theme (color group) to prefer given colorscheme
  background = 'dark',
  colorscheme = 'default',
  -- show current mode
  showmode = false,
  -- show line number
  number = true,
  -- show line numbers relative to cursor position
  relativenumber = true,
  -- minimum character width of line number column
  numberwidth = 3,
  -- height in lines of command line
  cmdheight = 1,
  -- always highlight columns, equivalent to rulers in vscode
  colorcolumn = '88',
  -- highlight line the cursor is at
  cursorline = true,
  -- configuration of how the cursor's line should be highlighted
  cursorlineopt = 'screenline,number',
  -- force every window's size to be equal
  equalalways = true,
  -- direction in which to make window's size equal
  -- hor: width, ver: height, both: height and width
  eadirection = 'hor',
  -- hightlight visible results of search
  hlsearch = true,
  -- NOTE win*(width|height) must set soft limit before hard limit to avoid error
  -- NOTE skip those becuase they are problematic, this error is dumb
  -- winheight = 10, -- soft
  -- winminheight = 8, -- hard
  -- winwidth = 24, -- soft
  -- winminwidth = 16, -- hard
  -- method to use when defining visual folds
  -- o.foldmethod = 'marker'
  -- go.foldmethod = 'marker'
  foldmethod = 'marker',
  -- keywords used to identify beginning and ending of visual fold
  -- o.foldmarker = '#region,#endregion'
  -- go.foldmarker = '#region,#endregion'
  foldmarker = '#region,#endregion',
  -- TODO o.foldtext
  -- whether to show tab page labels
  -- 0: never,  1: only if there are at least two tab pages, 2: always
  showtabline = 1,
  -- string to prepend to a screenline representing a line soft wrapped
  showbreak = '->  ',
  -- location to show typed commands (character combinations)
  showcmdloc = 'statusline',
  -- minimal number of columns to scroll horizontally
  sidescroll = 4,
  -- change way some text is displayed
  display = 'uhex,lastline',
  -- minimal number of screen lines to keep above and below the cursor
  scrolloff = 5,
  -- visually replace some blank-character sequences
  list = true,
  -- strings to replace whose blank characters with
  listchars = string.format('trail:%s', const.icons.misc.center_small_dot),
  -- single character flags indicating UI messages/errors to ignore or shorten
  shortmess = 'laoOstIcF',
  -- scrolling works with screen lines, not implemented for gj/gk as of nvim v0.10.4
  smoothscroll = true,
  -- letter space in pixels
  linespace = 0,
  -- allow nvim to set window title
  title = true,
  -- title string (statusline syntax)
  titlestring = 'nvim',
  -- break lines at specific characters instead of whatever is the last character
  linebreak = true,
  -- break lines at these characters
  breakat = o.breakat .. '_',
  -- preserve indent level at soft wrapped lines
  breakindent = false,
  -- brakeindent settings: indent at column 88, show broken line indicator (text)
  -- FIX remove column option, which is a hard column value
  -- o.breakindentopt = 'column:88,sbr'
  breakindentopt = '',
  -- maximum width of text being inserted; line will be broken at white space to match this width
  textwidth = 0,
  -- endregion

  -- region EDITOR FUNCTIONALITY
  -- mouse button behavior
  mousemodel = 'popup',
  -- modes/situations (single character flags) in which mouse support is enabled
  mouse = 'a',
  -- swapfile for the buffer
  -- NOTE let swapfile=false because otherwise auto-write plugins are unsafe
  -- TODO study about swap files and how it works more specifically
  swapfile = false,
  -- allows for sound/visual bells to be rang on errors
  -- NOTE only affects error *with* messages, many errors *without* messages ignore this
  errorbells = false,
  -- events at which bell will *not* be rang
  belloff = 'all',
  -- backup file before writing buffer to disk
  -- yes: make a copy of the file and overwrite the original one
  -- no: rename the file and write a new one
  -- auto: one of the previous, what works best
  backupcopy = 'no',
  -- completion behavior when pressing character specified by wildchar
  wildmode = 'full',
  -- how command line completion is done
  wildoptions = 'pum,tagfile',
  -- how the cursor can be positioned where there is no actual character
  virtualedit = 'onemore',
  -- whether case is ignored when completing file names and directories
  wildignorecase = true,
  -- ignore case in search patterns, cmdline-completion, tag search, and expr-==
  ignorecase = true,
  -- override ignorecase search pattern contains upper case characters
  -- only used when the search pattern is typed and ignorecase is true
  smartcase = true,
  -- round indent to multiple of shiftwidth
  shiftround = true,
  -- number of spaces to use for each step of (auto)indent
  shiftwidth = 2,
  -- a <Tab> in front of a line inserts blanks according to shiftwidth
  smarttab = true,
  -- number of spaces a <Tab> counts for during editing operations (\t, <BS>, etc)
  -- it "feels" like \t are being inserted, while in fact they're mixed with spaces
  softtabstop = 2,
  -- number of spaces that a \t in the file counts for
  -- NOTE sounds innofensive, SEE tabstop documentation
  tabstop = 4,
  -- insert tab width in spaces instead of \t
  expandtab = true,
  -- keep clipboard inside neovim only
  clipboard = '',
  -- wheter window and the buffer it is displaying are paired
  -- NOTE if set when only 1 window exists, another window is created
  winfixbuf = false,
  -- operations that would fail because of unsaved changes (:q and :e, etc),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- using a ! to unconditionally abandon a buffer will is still be allowed
  confirm = true,
  -- key used to expand command-line completion
  -- NOTE lua value is number, use literal vim command to allow keycode value
  -- SEE documentation
  wildchar = '<tab>',
  -- same as wildchar, but works inside macros and keymap commands
  -- usually this key is only used in macros/keymaps that invoke completion mode
  wildcharm = '<c-z>',
  -- When a bracket is inserted, briefly jump to the matching one
  -- jump is only done if the match can be seen on the screen.
  showmatch = false,
  -- save on focus change
  autowrite = true,
  -- save on exit, edit, new
  autowriteall = false,
  -- save undo history
  undofile = true,
  -- how many changes are save in the undofile
  undolevels = 1000,
  -- allow files to be stored in RAM so the undo action can restore
  -- reloaded buffer's (files changed outsife vim) pre-reload content
  -- files will be saved if this value is negative of buffer's number of lines is smaller
  undoreload = 10000,
  -- o.shell = 'pwsh.exe'
  winaltkeys = 'no',
  -- endregion
}

return M
