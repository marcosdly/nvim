--[[
  General auto commands.
--]]

local bootstrap = require 'bootstrap'
local autocmd = vim.api.nvim_create_autocmd
local __autocmd = require 'lib.autocmd'
local util = require 'lib.util'

-- TODO auto save timer
-- TODO per buffer title string
-- TODO show numbers at LOC, not blank nor clear comments, etc
-- TODO different data in statusline per mode
-- TODO color screenline with mode color (maybe color ruler as well)

bootstrap.SetAutocmds {
  -- Toggle relative numbers on insert mode enter/leave
  {
    'InsertEnter',
    function()
      if util.buf_is_normal() then vim.wo.relativenumber = false end
    end,
    desc = 'ENABLE relativenumber',
  },
  {
    'InsertLeave',
    function()
      if util.buf_is_normal() then vim.wo.relativenumber = true end
    end,
    desc = 'DISABLE relativenumber',
  },

  -- Only highlight search matches while searching
  {
    'CmdlineEnter',
    function()
      if not util.is_user_cmdline '/' then return end
      vim.go.hlsearch = true
    end,
    desc = 'ENABLE hlsearch according to command line mode',
  },
  {
    'CmdlineLeave',
    function()
      if vim.go.hlsearch then vim.go.hlsearch = false end
    end,
    desc = 'DISABLE hlsearch according to command line mode',
  },

  -- Set cmdheight
  {
    'CmdlineEnter',
    function(event)
      if not util.is_user_cmdline ':' then return end
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
    desc = 'Check type of command line, then set cmdheight',
  },
  {
    'CmdlineLeave',
    function()
      if not util.is_user_cmdline ':' then return end
      vim.go.cmdheight = 1
    end,
    desc = 'Set default cmdheight',
  },

  -- Set fold marker
  {
    { 'BufEnter', 'FileType' },
    function(event)
      if util.buf_is_normal() then __autocmd.set_foldmarker_per_buf(event) end
    end,
    desc = 'Set custom foldmarker per buffer',
  },

  -- Set cursorcolumn if buffer is terminal
  {
    { 'BufEnter', 'TermOpen', 'TermEnter' },
    function()
      vim.wo.cursorcolumn = vim.bo.buftype == 'terminal'
    end,
    desc = 'Set cursorcolumn according to buftype',
  },

  -- Format buffer
  {
    'BufWritePost',
    function()
      if util.buf_is_normal() then vim.cmd 'FormatWriteLock' end
    end,
    desc = 'Format and write buffer (blocking)',
  },
}
