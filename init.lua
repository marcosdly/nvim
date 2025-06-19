if vim.env.PROF then require 'profiler' end

require 'globals.flags'
require 'globals.constants'
_G.util = require 'shared.util'

require 'shared'
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require 'keymap'
require 'bootstrap'
require 'options'
require 'plugins'
require 'autocmd'
