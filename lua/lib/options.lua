
local M = {}

M.filepattern_opt = { ignore = {}, low_priority = {} }

-- altright ignore
M.filepattern_opt.ignore.default = {'**/*.bkp', '**/*.bkp.*', '**/*.db', '**/*.db.*'}
M.filepattern_opt.ignore.python = {'**/__pycache__/', '**/*.pyc'}

-- just show with lower priority
M.filepattern_opt.low_priority.default = {}
M.filepattern_opt.low_priority.python = {'**/.venv*/'}

function M.set_wildignore_by_filetype()
  -- NOTE vim.iter is null safe so arguments may be nil just fine

  -- set ignore
  local ignore_list = vim.iter(
    vim.gsplit(vim.go.wildignore or '', ','), -- current value
    self.ignore.default,
    self.ignore[vim.opt.filetype]
  )
  ignore_list:map(vim.trim):map(string.lower)
  vim.go.wildignore = ignore_list:join(',')

  -- set low priority
  local low_priority_list = vim.iter(
    vim.gsplit(vim.go.suffixes or '', ','), -- current value
    self.low_priority.default,
    self.low_priority[vim.opt.filetype]
  )
  low_priority_list:map(vim.trim):map(string.lower)
  vim.go.suffixes = low_priority_list:join(',')
end

return M
