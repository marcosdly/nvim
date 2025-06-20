if vim.env.PROF and not vim.g.vscode then require 'profiler' end

require 'globals'

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require 'bootstrap'

require '_general.keymap'

if vim.g.vscode then
  require '_vscode.options'
  require '_vscode.autocmd'
else
  require 'options'
  require 'keymap'
  require 'autocmd'
end

if vim.g.vscode then
  local vscode = require 'vscode'
  vim.notify = vscode.notify
end
