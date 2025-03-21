--[[
  General auto commands.
--]]

local autocmd = vim.api.nvim_create_autocmd
local lib = require('lib')

-- TODO auto save timer
-- TODO per buffer title string
-- TODO show numbers at LOC, not blank nor clear comments, etc
-- TODO different data in statusline per mode
-- TODO color screenline with mode color (maybe color ruler as well)

-- Toggle relative numbers on insert mode enter/leave
autocmd({ 'InsertEnter', 'TermEnter', }, { pattern = '*', command = 'set norelativenumber' })
autocmd({ 'InsertLeave', 'TermLeave', }, { pattern = '*', command = 'set relativenumber' })

-- Only highlight search matches while searching
autocmd('CmdlineEnter', { pattern = '*', command = 'set hlsearch' })
autocmd('CmdlineLeave', { pattern = '*', command = 'set nohlsearch' })

-- Set cmdheight
autocmd('CmdlineEnter', {
  pattern = '*',
  callback = function(event)
    if vim.v.event.cmdlevel ~= 1 or vim.v.event.cmdtype ~= ':' then
      return
    end
    vim.schedule(function()
      vim.o.cmdheight = 2
      vim.api.nvim__redraw({
        buf = 0,
        valid = true,
        cursor = true,
        statuscolumn = true,
        -- statusline = true
      })
      require('lualine').refresh({
        scope = 'window',
        place = { 'statusline' }
      })
    end)
  end
})
autocmd('CmdlineLeave', { pattern = '*', command = 'set cmdheight=1' })

-- Set fold marker
autocmd({ 'BufEnter', 'FileType' }, {
  pattern = '*',
  callback = lib.autocmd.set_foldmarker_per_buf
})

-- Set cursorcolumn if buffer is terminal
autocmd({ 'BufEnter', 'TermOpen', 'TermEnter' }, {
  pattern = '*',
  callback = function()
    vim.o.cursorcolumn = vim.o.buftype == 'terminal'
  end
})

-- Format buffer
autocmd('BufWritePost', {
  pattern = '*',
  command = 'FormatWriteLock' -- safe
})
