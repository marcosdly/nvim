--[[
  Editor keymaps
--]]

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local set = vim.keymap.set

local default_opts = { nowait = true, silent = true }

-- center cursor when scrolling half screen
set( 'n', '<c-d>', '<c-d>zz', default_opts )
set( 'n', '<c-u>', '<c-u>zz', default_opts )

-- move up and down even between wrapped lines
-- SEE https://stackoverflow.com/a/60907908
-- >I have found another version of this solution that does more than
-- >moving through physical or virtual lines, it also adds jumps bigger
-- >than 5 lines to the jump list, allowing us to use Ctrl-o and Ctrl-i.
-- SOURCE: https://www.vi-improved.org/vim-tips/
set( 'n', 'j', [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']], { noremap = true, expr = true } )
set( 'n', 'k', [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']], { noremap = true, expr = true } )

