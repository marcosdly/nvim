--[[
  Editor keymaps
--]]

-- TODO toggle boolean value under cursor (code action? treeshitter?)
-- TODO merge, split lines both in normal and insert modes
-- TODO jump to syntax token
-- TODO jump to enclosing tokens (quotes, parentheses)

LazyNvim:SetKeys {
  { '<c-d>', '<c-d>zz', desc = 'Scroll half screen up' },
  { '<c-u>', '<c-u>zz', desc = 'Scroll half screen down' },
  { '<leader>/', '<cmd>nohl<cr>', desc = 'Clear search highlighting' },

  -- move up and down even between wrapped lines
  -- SEE https://stackoverflow.com/a/60907908
  -- >I have found another version of this solution that does more than
  -- >moving through physical or virtual lines, it also adds jumps bigger
  -- >than 5 lines to the jump list, allowing us to use Ctrl-o and Ctrl-i.
  -- SOURCE: https://www.vi-improved.org/vim-tips/
  {
    'j',
    [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']],
    noremap = true,
    expr = true,
  },
  {
    'k',
    [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']],
    noremap = true,
    expr = true,
  },

  -- Clear line without appending to any register, nor changing mode
  { 'dD', '0"_D', desc = 'Delete line without yanking' },
  -- Remap visual block mode
  { '<c-b>', '<c-v>', desc = 'Block select mode' },
  -- Switch buffer
  { '<leader>bn', '<cmd>bnext<cr>', desc = 'Buffer: Go to next' },
  { '<leader>bp', '<cmd>bprevious<cr>', desc = 'Buffer: Go to previous' },
  { '<leader>b[', '<cmd>bfirst<cr>', desc = 'Buffer: Go to first' },
  { '<leader>b]', '<cmd>blast<cr>', desc = 'Buffer: Go to last' },
}

LazyNvim:SetKeys {
  { '<esc>', '<c-\\><c-n>', mode = 't', desc = 'which_key_ignore' },

  -- Window
  { '<leader>wn', '<cmd>wincmd w<cr>', desc = 'Window: Go to next (wrap around)' },
  { '<leader>wp', '<cmd>wincmd W<cr>', desc = 'Window: Go to previous (wrap around)' },
  { '<leader>wj', '<cmd>wincmd j<cr>', desc = 'Window: Go to bottom' },
  { '<leader>wk', '<cmd>wincmd k<cr>', desc = 'Window: Go to top' },
  { '<leader>wh', '<cmd>wincmd h<cr>', desc = 'Window: Go to left' },
  { '<leader>wl', '<cmd>wincmd l<cr>', desc = 'Window: Go to right' },
  { '<leader>we', '<cmd>wincmd p<cr>', desc = 'Window: Go to last accessed' },
  {
    '<leader>wP',
    function() -- todo to preview window or error
      local ok, _ = pcall(vim.cmd '<cmd>wincmd P<cr>')
      if not ok then vim.print 'No preview window available.' end
    end,
    desc = 'Window: Go to preview window',
  },
  { '<leader>wt', '<cmd>wincmd T<cr>', desc = 'Window: Move to new tab' },
  {
    '<leader>w=',
    '<cmd>wincmd =<cr>',
    desc = 'Window: Even out dimensions of all windows',
  },
  { '<leader>w[', '<cmd>wincmd +1<cr>', desc = 'Window: Increase height' },
  { '<leader>w]', '<cmd>wincmd -1<cr>', desc = 'Window: Decrease height' },
  { "<leader>w'", '<cmd>wincmd >1<cr>', desc = 'Window: Increase width' },
  { '<leader>w;', '<cmd>wincmd <1<cr>', desc = 'Window: Decrease width' },
  { '<leader>w\\', '<cmd>wincmd _<cr>', desc = 'Window: Maximium height' },
  { '<leader>w|', '<cmd>wincmd |<cr>', desc = 'Window: Maximium width' },
  {
    '<leader>wf',
    '<cmd>wincmd _<cr><cmd>wincmd |<cr>',
    desc = 'Window: Maximum dimentions',
  },

  -- Tab
  -- Open a new tab and edit the file under the cursor
  { '<leader>tf', '<ctrl-w>gf', desc = 'Tab: Open this file (plain path)' },
  -- Open a new tab and edit the file under the cursor, include line number identiifers
  { '<leader>tF', '<ctrl-w>gF', desc = 'Tab: Open this file (editor string)' },
  { '<leader>tn', '<cmd>tabnext<cr>', desc = 'Tab: Go to next' },
  { '<leader>tp', '<cmd>tabprevious<cr>', desc = 'Tab: Go to previous' },
  { '<leader>td', '<cmd>tabclose<cr>', desc = 'Tab: Close current' },
  { '<leader>t[', '<cmd>tabfirst<cr>', desc = 'Tab: Go to first tab' },
  { '<leader>t]', '<cmd>tablast<cr>', desc = 'Tab: Go to last tab' },
  { '<leader>te', '<ctrl-w>g<tab>', desc = 'Tab: Go to last accessed' },

  -- save file in other modes
  { '<c-z>', '<cmd>write<cr>', mode = 't', desc = 'Write file' },
}
