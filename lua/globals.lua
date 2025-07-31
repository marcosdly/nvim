-- global state namespace
_G.state = {}

_G.util = require 'lib.util'
_G.const = require 'lib.helpful_constants'

_G.TRUE = 1
_G.FALSE = 0
_G.IS_WINDOWS = jit.os == 'Windows'
_G.IS_LINUX = jit.os == 'Linux'
