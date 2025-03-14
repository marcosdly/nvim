--[[
  General auto commands.
--]]

local autocmd = vim.api.nvim_create_autocmd
local lib = require('lib')

-- TODO auto save timer
-- TODO per buffer title string
-- TODO set cmdheight per command line prefix
-- TODO show numbers at LOC, not blank nor clear comments, etc
-- TODO different data in statusline per mode
-- TODO color screenline with mode color (maybe color ruler as well)

-- Toggle relative numbers on insert mode enter/leave
autocmd('InsertEnter', { pattern = '*', command = 'set norelativenumber' })
autocmd('InsertLeave', { pattern = '*', command = 'set relativenumber' })

-- Only highlight search matches while searching
autocmd('CmdlineEnter', { pattern = '*', command = 'set hlsearch' })
autocmd('CmdlineLeave', { pattern = '*', command = 'set nohlsearch' })

-- Force buffers to be hard linked to their window
autocmd('WinNew', { pattern = '*', command = 'set winfixbuf' })

-- Set fold marker
autocmd({ 'BufEnter', 'FileType' }, {
  pattern = '*',
  callback = lib.autocmd.set_foldmarker_per_buf
})

