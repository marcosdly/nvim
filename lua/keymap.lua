--[[
  Editor keymaps
--]]

local set = vim.keymap.set

-- TODO toggle boolean value under cursor (code action? treeshitter?)
-- TODO merge, split lines both in normal and insert modes
-- TODO jump to syntax token
-- TODO jump to enclosing tokens (quotes, parentheses)

-- region TERMINAL
set('t', '<esc>', '<c-\\><c-n>', { desc = 'which_key_ignore' })
-- endregion

-- Switch window/tab

-- Window
set(
  'n',
  '<leader>wn',
  '<cmd>wincmd w<cr>',
  { desc = 'Window: Go to next (wrap around)' }
)
set(
  'n',
  '<leader>wp',
  '<cmd>wincmd W<cr>',
  { desc = 'Window: Go to previous (wrap around)' }
)
set('n', '<leader>wj', '<cmd>wincmd j<cr>', { desc = 'Window: Go to bottom' })
set('n', '<leader>wk', '<cmd>wincmd k<cr>', { desc = 'Window: Go to top' })
set('n', '<leader>wh', '<cmd>wincmd h<cr>', { desc = 'Window: Go to left' })
set('n', '<leader>wl', '<cmd>wincmd l<cr>', { desc = 'Window: Go to right' })
set('n', '<leader>we', '<cmd>wincmd p<cr>', { desc = 'Window: Go to last accessed' })
set('n', '<leader>wP', function() -- todo to preview window or error
  local ok, _ = pcall(vim.cmd '<cmd>wincmd P<cr>')
  if not ok then vim.print 'No preview window available.' end
end, { desc = 'Window: Go to preview window' })
set('n', '<leader>wt', '<cmd>wincmd T<cr>', { desc = 'Window: Move to new tab' })
set(
  'n',
  '<leader>w=',
  '<cmd>wincmd =<cr>',
  { desc = 'Window: Even out dimensions of all windows' }
)
set('n', '<leader>w[', '<cmd>wincmd +1<cr>', { desc = 'Window: Increase height' })
set('n', '<leader>w]', '<cmd>wincmd -1<cr>', { desc = 'Window: Decrease height' })
set('n', "<leader>w'", '<cmd>wincmd >1<cr>', { desc = 'Window: Increase width' })
set('n', '<leader>w;', '<cmd>wincmd <1<cr>', { desc = 'Window: Decrease width' })
set('n', '<leader>w\\', '<cmd>wincmd _<cr>', { desc = 'Window: Maximium height' })
set('n', '<leader>w|', '<cmd>wincmd |<cr>', { desc = 'Window: Maximium width' })
set(
  'n',
  '<leader>wf',
  '<cmd>wincmd _<cr><cmd>wincmd |<cr>',
  { desc = 'Window: Maximum dimentions' }
)

-- Tab
-- Open a new tab and edit the file under the cursor
set('n', '<leader>tf', '<ctrl-w>gf', { desc = 'Tab: Open this file (plain path)' })
-- Open a new tab and edit the file under the cursor, include line number identiifers
set('n', '<leader>tF', '<ctrl-w>gF', { desc = 'Tab: Open this file (editor string)' })
set('n', '<leader>tn', '<cmd>tabnext<cr>', { desc = 'Tab: Go to next' })
set('n', '<leader>tp', '<cmd>tabprevious<cr>', { desc = 'Tab: Go to previous' })
set('n', '<leader>td', '<cmd>tabclose<cr>', { desc = 'Tab: Close current' })
set('n', '<leader>t[', '<cmd>tabfirst<cr>', { desc = 'Tab: Go to first tab' })
set('n', '<leader>t]', '<cmd>tablast<cr>', { desc = 'Tab: Go to last tab' })
set('n', '<leader>te', '<ctrl-w>g<tab>', { desc = 'Tab: Go to last accessed' })

-- save file in other modes
set('i', '<c-z>', '<cmd>write<cr>', { desc = 'Write file' })
