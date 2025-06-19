if vim.env.PROF then require 'profiler' end

-- global constants
_G.TRUE = 1
_G.FALSE = 0
_G.IS_WINDOWS = jit.os == 'Windows'
_G.IS_LINUX = jit.os == 'Linux'

-- global modules
_G.util = require 'lib.util'

require 'shared'
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require 'keymap'
require 'bootstrap'
require 'options'
require 'plugins'
require 'autocmd'
