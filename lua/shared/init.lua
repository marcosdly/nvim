local global_state_namespace = {}

_G.shared = {
  const = require 'shared.constants',
  util = require'shared.util',
  state = global_state_namespace,
}

return _G.shared
