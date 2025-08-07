if vim.env.PROF and not vim.g.vscode then require 'profiler' end

vim.g.is_windows = jit.os == 'Windows'
vim.g.is_linux = jit.os == 'Linux'

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

_G.LazyNvim = require('bootstrap').LazyNvim
LazyNvim:Bootstrap()

if vim.g.vscode then
  LazyNvim:Setup(require '_vscode.plugins')
  require '_vscode'
  return
end

LazyNvim:Setup(require 'plugins')

require 'keymap'
require 'options'
require 'autocmd'
