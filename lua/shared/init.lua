local global_state_namespace = {}

_G.shared = {
  const = require 'shared.constants',
  state = global_state_namespace,
}

return _G.shared
