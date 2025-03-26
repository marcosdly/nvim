--[[
  General auto commands.
--]]

local autocmd = vim.api.nvim_create_autocmd
local lib = require 'lib'

-- TODO auto save timer
-- TODO per buffer title string
-- TODO show numbers at LOC, not blank nor clear comments, etc
-- TODO different data in statusline per mode
-- TODO color screenline with mode color (maybe color ruler as well)

-- Toggle relative numbers on insert mode enter/leave
autocmd('InsertEnter', {
  buffer = 0,
  desc = 'ENABLE relativenumber',
  callback = function()
    if vim.bo.buftype == '' then vim.wo.relativenumber = false end
  end,
})
autocmd('InsertLeave', {
  buffer = 0,
  desc = 'DISABLE relativenumber',
  callback = function()
    if vim.bo.buftype == '' then vim.wo.relativenumber = true end
  end,
})

-- Only highlight search matches while searching
autocmd('CmdlineEnter', {
  buffer = 0,
  desc = 'ENABLE hlsearch according to commadn line mode',
  command = 'set hlsearch',
})
autocmd('CmdlineLeave', {
  buffer = 0,
  desc = 'DISABLE hlsearch according to commadn line mode',
  command = 'set nohlsearch',
})

-- Set cmdheight
autocmd('CmdlineEnter', {
  desc = 'Check type of command line, then set cmdheight',
  callback = function(event)
    if vim.v.event.cmdlevel ~= 1 or vim.v.event.cmdtype ~= ':' then return end
    vim.schedule(function()
      vim.o.cmdheight = 2
      vim.api.nvim__redraw {
        buf = 0,
        valid = true,
        cursor = true,
        statuscolumn = true,
        -- statusline = true
      }
      require('lualine').refresh {
        scope = 'window',
        place = { 'statusline' },
      }
    end)
  end,
})
autocmd('CmdlineLeave', {
  desc = 'Set default cmdheight',
  command = 'set cmdheight=1',
})

-- Set fold marker
autocmd({ 'BufEnter', 'FileType' }, {
  buffer = 0,
  desc = 'Set custom foldmarker per buffer',
  callback = lib.autocmd.set_foldmarker_per_buf,
})

-- Set cursorcolumn if buffer is terminal
autocmd({ 'BufEnter', 'TermOpen', 'TermEnter' }, {
  buffer = 0,
  desc = 'Set cursorcolumn according to buftype',
  callback = function()
    vim.o.cursorcolumn = vim.o.buftype == 'terminal'
  end,
})

-- Format buffer
autocmd('BufWritePost', {
  buffer = 0,
  desc = 'Format and write buffer (blocking)',
  command = 'FormatWriteLock', -- safe
})
