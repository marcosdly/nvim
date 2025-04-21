-- Neovim profiler by snacks.nvim
-- SEE https://github.com/folke/snacks.nvim/blob/main/docs/profiler.md

local snacks = vim.fn.stdpath 'data' .. '/lazy/snacks.nvim'
vim.opt.rtp:append(snacks)

---@diagnostic disable-next-line: missing-fields
require('snacks.profiler').startup {
  -- Many options may be set to their default
  -- That is to be explicit on which I may find useful to toggle later
  autocmds = true,
  on_stop = {
    highlights = true,
    pick = true,
  },
  startup = {
    event = 'VeryLazy', -- stop profiler on this event. Defaults to `VimEnter`
    after = true, -- stop the profiler **after** the event. When false it stops **at** the event
    pattern = nil, -- pattern to match for the autocmd
    pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
  },
  pick = {
    picker = snacks,
  },
  globals = {
    -- vim globals
    'vim',
    'vim.api',
    'vim.keymap',
    'vim.iter',
    -- personal globals
    'shared',
  },
  filter_fn = {
    -- defaults
    default = true,
    ['^.*%._[^%.]*$'] = false,
    ['trouble.filter.is'] = false,
    ['trouble.item.__index'] = false,
    ['which-key.node.__index'] = false,
    ['smear_cursor.draw.wo'] = false,
    ['^ibl%.utils%.'] = false,
    -- personal
    ['^vim.tbl_'] = true,
  },
}
