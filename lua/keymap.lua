--[[
  Editor keymaps
--]]

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local set = vim.keymap.set

-- TODO toggle boolean value under cursor (code action? treeshitter?)
-- TODO change window, change tab, change buffer
-- TODO merge, split lines both in normal and insert modes
-- TODO jump to syntax token
-- TODO jump to enclosing tokens (quotes, parentheses)

-- center cursor when scrolling half screen
set( 'n', '<c-d>', '<c-d>zz' )
set( 'n', '<c-u>', '<c-u>zz' )

-- no highlight
set( 'n', '<leader>/', '<cmd>nohl<cr>' )

-- move up and down even between wrapped lines
-- SEE https://stackoverflow.com/a/60907908
-- >I have found another version of this solution that does more than
-- >moving through physical or virtual lines, it also adds jumps bigger
-- >than 5 lines to the jump list, allowing us to use Ctrl-o and Ctrl-i.
-- SOURCE: https://www.vi-improved.org/vim-tips/
set( 'n', 'j', [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']], { noremap = true, expr = true } )
set( 'n', 'k', [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']], { noremap = true, expr = true } )

-- Clear line without appending to any register, nor changing mode
set( 'n', 'dD', '0"_D' )

-- Remap visual block mode
set( 'n', '<c-b>', '<c-v>' )

-- Toggle keymap layout
function _G.toggle_keymap()
  if vim.o.keymap == '' then
    vim.o.keymap = 'portuguese-accents-abnt2'
  else
    vim.o.keymap = ''
  end
end
set( 'n', '<c-k>', toggle_keymap )
set( 'i', '<c-k>', '<esc><cmd>lua toggle_keymap()<cr>i' )
