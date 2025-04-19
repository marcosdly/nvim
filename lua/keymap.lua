--[[
  Editor keymaps
--]]

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local set = vim.keymap.set

-- TODO toggle boolean value under cursor (code action? treeshitter?)
-- TODO merge, split lines both in normal and insert modes
-- TODO jump to syntax token
-- TODO jump to enclosing tokens (quotes, parentheses)

-- center cursor when scrolling half screen
set('n', '<c-d>', '<c-d>zz')
set('n', '<c-u>', '<c-u>zz')

-- no highlight
set('n', '<leader>/', '<cmd>nohl<cr>')

-- move up and down even between wrapped lines
-- SEE https://stackoverflow.com/a/60907908
-- >I have found another version of this solution that does more than
-- >moving through physical or virtual lines, it also adds jumps bigger
-- >than 5 lines to the jump list, allowing us to use Ctrl-o and Ctrl-i.
-- SOURCE: https://www.vi-improved.org/vim-tips/
set(
  'n',
  'j',
  [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']],
  { noremap = true, expr = true }
)
set(
  'n',
  'k',
  [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']],
  { noremap = true, expr = true }
)

-- Clear line without appending to any register, nor changing mode
set('n', 'dD', '0"_D')

-- Remap visual block mode
set('n', '<c-b>', '<c-v>')

-- Toggle keymap layout
function _G.toggle_keymap()
  if vim.o.keymap == '' then
    vim.o.keymap = 'portuguese-accents-abnt2'
  else
    vim.o.keymap = ''
  end
end
set('n', '<c-k>', toggle_keymap)
set('i', '<c-k>', '<esc><cmd>lua toggle_keymap()<cr>i')

-- region TERMINAL
set('t', '<esc>', '<c-\\><c-n>')
-- endregion

-- Switch window/buffer/tab
set('n', '<leader>bn', '<cmd>bnext<cr>')
set('n', '<leader>bp', '<cmd>bprevious<cr>')
set('n', '<leader>b[', '<cmd>bfirst<cr>') -- goto first buffer
set('n', '<leader>b]', '<cmd>blast<cr>') -- goto last buffer

-- Window
set('n', '<leader>wn', '<cmd>wincmd w<cr>') -- next (wrap around)
set('n', '<leader>wp', '<cmd>wincmd W<cr>') -- previous (wrap around)
set('n', '<leader>wj', '<cmd>wincmd j<cr>')
set('n', '<leader>wk', '<cmd>wincmd k<cr>')
set('n', '<leader>wh', '<cmd>wincmd h<cr>')
set('n', '<leader>wl', '<cmd>wincmd l<cr>')
set('n', '<leader>we', '<cmd>wincmd p<cr>') -- goto last accessed window
set('n', '<leader>wP', function() -- todo to preview window or error
  local ok, _ = pcall(vim.cmd '<cmd>wincmd P<cr>')
  if not ok then vim.print 'No preview window available.' end
end)
set('n', '<leader>wt', '<cmd>wincmd T<cr>') -- move current window to new tab
set('n', '<leader>w=', '<cmd>wincmd =<cr>') -- even height and width of all windows
set('n', '<leader>w[', '<cmd>wincmd +1<cr>') -- increase height
set('n', '<leader>w]', '<cmd>wincmd -1<cr>') -- decrease height
set('n', "<leader>w'", '<cmd>wincmd >1<cr>') -- increase width
set('n', '<leader>w;', '<cmd>wincmd <1<cr>') -- decrease width
set('n', '<leader>w\\', '<cmd>wincmd _<cr>') -- window height as high as possible
set('n', '<leader>w|', '<cmd>wincmd |<cr>') -- window width as wide as possible
set('n', '<leader>wf', '<cmd>wincmd _<cr><cmd>wincmd |<cr>') -- force full window

-- Tab
-- Open a new tab and edit the file under the cursor
set('n', '<leader>tf', '<ctrl-w>gf')
-- Open a new tab and edit the file under the cursor, include line number identiifers
set('n', '<leader>tF', '<ctrl-w>gF')
set('n', '<leader>tn', '<cmd>tabnext<cr>')
set('n', '<leader>tp', '<cmd>tabprevious<cr>')
set('n', '<leader>td', '<cmd>tabclose<cr>')
set('n', '<leader>t[', '<cmd>tabfirst<cr>') -- goto first tab
set('n', '<leader>t]', '<cmd>tablast<cr>') -- goto last tab
set('n', '<leader>te', '<ctrl-w>g<tab>') -- goto last accessed tab

-- save file in other modes
set('i', '<c-z>', '<cmd>write<cr>')
