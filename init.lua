if vim.env.PROF and not vim.g.vscode then require 'profiler' end

vim.g.is_windows = jit.os == 'Windows'
vim.g.is_linux = jit.os == 'Linux'

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local LazyNvim = require('bootstrap').LazyNvim
LazyNvim:Bootstrap()
LazyNvim:Setup()

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
