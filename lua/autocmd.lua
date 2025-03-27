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
    if shared.util.buf_is_normal() then vim.wo.relativenumber = false end
  end,
})
autocmd('InsertLeave', {
  buffer = 0,
  desc = 'DISABLE relativenumber',
  callback = function()
    if shared.util.buf_is_normal() then vim.wo.relativenumber = true end
  end,
})

-- Only highlight search matches while searching
autocmd('CmdlineEnter', {
  buffer = 0,
  desc = 'ENABLE hlsearch according to command line mode',
  callback = function()
    if not shared.util.is_user_cmdline '/' then return end
    vim.go.hlsearch = true
  end,
})
autocmd('CmdlineLeave', {
  buffer = 0,
  desc = 'DISABLE hlsearch according to command line mode',
  callback = function()
    if vim.go.hlsearch then vim.go.hlsearch = false end
  end,
})

-- Set cmdheight
autocmd('CmdlineEnter', {
  desc = 'Check type of command line, then set cmdheight',
  callback = function(event)
    if not shared.util.is_user_cmdline ':' then return end
    vim.schedule(function()
      vim.go.cmdheight = 2
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
  callback = function()
    if not shared.util.is_user_cmdline ':' then return end
    vim.go.cmdheight = 1
  end,
})

-- Set fold marker
autocmd({ 'BufEnter', 'FileType' }, {
  buffer = 0,
  desc = 'Set custom foldmarker per buffer',
  callback = function(event)
    if shared.util.buf_is_normal() then lib.autocmd.set_foldmarker_per_buf(event) end
  end,
})

-- Set cursorcolumn if buffer is terminal
autocmd({ 'BufEnter', 'TermOpen', 'TermEnter' }, {
  buffer = 0,
  desc = 'Set cursorcolumn according to buftype',
  callback = function()
    vim.wo.cursorcolumn = vim.bo.buftype == 'terminal'
  end,
})

-- Format buffer
autocmd('BufWritePost', {
  buffer = 0,
  desc = 'Format and write buffer (blocking)',
  callback = function()
    if shared.util.buf_is_normal() then vim.cmd 'FormatWriteLock' end
  end,
})

-- Trach file with lazygit
autocmd('BufEnter', {
  desc = 'Keep track of file with lazygit',
  callback = function()
    if not shared.util.buf_is_normal() then return end
    require'lazygit.utils'.project_root_dir()
  end,
})
