local dap = require 'dap'

-- TODO telescope select set exception breakpoint
-- TODO telescope list breakpoints

local dap, dapui = require 'dap', require 'dapui'
local dap_vscode = require 'dap.ext.vscode'

-- Listeners
dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

-- Config
dap_vscode.json_decode = require('json5').parse
dapui.setup {}
