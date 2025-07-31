local const = require 'lib.helpful_constants'

---@type snacks.Config
require('snacks').setup {
  -- TODO custom styles
  bigfile = {
    enabled = true,
    notify = true,
    size = 2 * 1024 * 1024,
    line_lenght = 5000,
  },
  notifier = {
    enabled = true,
    timeout = 2000,
    width = { min = 32, max = 0.4 },
    height = { min = 1, max = 0.5 },
    margin = { top = 1, right = 1 },
    padding = true,
    sort = { 'added', 'level' },
    level = vim.log.levels.INFO,
    style = 'compact',
    top_down = true,
    refresh = 100, -- ms
  },
  indent = {
    indent = {
      enabled = true,
      priority = 1,
      char = const.icons.misc.bottom_small_dot,
      only_scope = true,
      only_current = false,
    },
    animate = { enabled = false },
    scope = { enabled = true, priority = 10, only_current = false },
    chunk = { enabled = true, priority = 100, only_current = false },
  },
  lazygit = {
    -- TODO style: better hl groups
    configure = true,
    config = {
      os = { editPreset = 'nvim-remote' },
      gui = {
        -- set to an empty string "" to disable icons
        nerdFontsVersion = '3',
      },
    },
  },
  quickfile = { enabled = true },
  scratch = {
    autowrite = true,
    filekey = { cwd = true, branch = true, count = false },
  },
  statuscolumn = {
    enabled = true,
    left = { 'sign', 'fold' },
    right = { 'mark' },
    folds = { open = true, git_hl = true },
    git = {
      patterns = {
        'GitSign',
        'MiniDiffSign',
        'MiniDiffOverAdd',
        'MiniDiffOverDelete',
        'MiniDiffOverAdd',
      },
    },
    refresh = 100,
  },
  dim = {
    scope = {
      min_size = 5,
      max_size = 50,
      siblings = true,
    },
    animate = { enabled = false },
  },
  words = {
    debounce = 100,
  },
  -- TODO terminal
  -- TODO toggle
}
