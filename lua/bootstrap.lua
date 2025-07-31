--[[
  Bootstrap lazy.nvim
--]]

local M = {}

local LazyNvim = {
  path = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim',
  repo = 'https://github.com/folke/lazy.nvim.git',
}
M.LazyNvim = LazyNvim

function LazyNvim:Bootstrap()
  if not (vim.uv or vim.loop).fs_stat(self.path) then
    local out = vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--depth=1',
      '--single-branch',
      self.path,
      self.path,
    }
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(self.path)
end

function LazyNvim:Setup()
  require('lazy').setup {
    defaults = {
      lazy = false,
    },
    spec = {
      { import = 'plugins' },
    },
    checker = {
      -- automatically check for plugin updates
      enabled = false,
      concurrency = 4,
      check_pinned = true,
      frequency = 3600 * 24, -- 1 day (seconds)
    },
    ui = { border = 'rounded', title = 'Plugins', title_pos = 'center' },
    change_detection = { notify = false },
    sources = {
      'lazy',
      'rockspec',
    },
    rocks = {
      enabled = true,
      root = vim.fn.stdpath 'data' .. '/lazy-rocks',
      server = 'https://nvim-neorocks.github.io/rocks-binaries/',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          -- "matchit",
          -- "matchparen",
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }
end

LazyNvim._priority_counter = 10000

function LazyNvim:_getNextPriorityInt()
  local p = self._priority_counter
  self._priority_counter = p - 10
  return p
end

function LazyNvim:SetPriority(plugins, id_list)
  if plugins == nil or vim.tbl_count(plugins) == 0 then return end
  local dont_check = id_list == nil -- always assign priority
  for i, it in ipairs(plugins) do
    if type(it) == 'string' and (dont_check or vim.tbl_contains(id_list, it)) then
      plugins[i] = { it, priority = self:_getNextPriorityInt() }
    elseif type(it) == 'table' and (dont_check or vim.tbl_contains(id_list, it[1])) then
      it.priority = self:_getNextPriorityInt()
    end
  end
end

local Snacks = {
  path = vim.fn.stdpath 'data' .. '/lazy/snacks.nvim',
}
M.Snacks = Snacks

function Snacks:Bootstrap()
  vim.opt.rtp:append(self.path)
end

function Snacks:SetupProfiler()
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
end

return M
