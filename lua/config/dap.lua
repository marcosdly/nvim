local M = {}

-- TODO telescope select set exception breakpoint
-- TODO telescope list breakpoints

M.util = {}

function M.util.refresh_config()
  require('dap.ext.vscode').load_launchjs()
  -- TODO load configs from neodev's config file
  -- TODO watch files for changes
end

M.lazyspec = {}

M.lazyspec.keys = {
  -- region Session
  {
    '<leader>dc',
    function()
      M.util.refresh_config()
      require('dap').continue()
    end,
  },
  {
    '<leader>dC',
    function()
      require('dap').reverse_continue()
    end,
  },
  {
    '<leader>dr',
    function()
      require('dap').restart()
    end,
  },
  {
    '<leader>dR',
    function()
      require('dap').restart_frame()
    end,
  },
  {
    '<leader>dp',
    function()
      require('dap').pause()
    end,
  },
  {
    '<leader>dt',
    function()
      require('dap').terminate()
    end,
  },
  {
    '<leader>di',
    function()
      M.util.refresh_config()
      require('dap').status()
    end,
  },
  {
    '<leader>dI',
    function()
      M.util.refresh_config()
      require('dap').sessions()
    end,
  },
  {
    '<leader>dD',
    function()
      require('dap').disconnect()
    end,
  },
  {
    '<leader>dg',
    function()
      require('dapui').toggle()
    end,
  },
  -- endregion

  -- region Breakpoints
  {
    '<leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
  },
  {
    '<leader>dB',
    function()
      M.util.refresh_config()
      require('dap').list_breakpoints()
    end,
  },
  {
    '<leader>dC',
    function()
      require('dap').clear_breakpoints()
    end,
  },
  -- endregion

  -- region Navigation
  {
    '<leader>dl',
    function()
      require('dap').step_over()
    end,
  },
  {
    '<leader>dh',
    function()
      require('dap').step_back()
    end,
  },
  {
    '<leader>dk',
    function()
      require('dap').step_out()
    end,
  },
  {
    '<leader>dj',
    function()
      require('dap').step_into()
    end,
  },
  {
    '<leader>dp',
    function()
      require('dap').up()
    end,
  },
  {
    '<leader>dn',
    function()
      require('dap').down()
    end,
  },
  {
    '<leader>df',
    function()
      require('dap').focus_frame()
    end,
  },
  {
    '<leader>du',
    function()
      require('dap').run_until_cursor()
    end,
  },
  -- endregion

  -- region REPL (Debug Console)
  {
    '<leader>dco',
    function()
      require('dap').repl.open()
    end,
  },
  {
    '<leader>dcc',
    function()
      require('dap').repl.close()
    end,
  },
  {
    '<leader>dce',
    function()
      -- TODO exec text from selection
      require('dap').repl.execute()
    end,
    mode = 'v',
  },
  -- endregion

  -- TODO goto line dap.goto_()
  -- TODO dap widgets
}

M.lazyspec.cmd = {
  -- Session management
  'DapContinue',
  'DapDisconnect',
  'DapNew',
  'DapTerminate',

  -- Stepping
  'DapRestartFrame',
  'DapStepInto',
  'DapStepOut',
  'DapStepOver',
  'DapPause',

  -- REPL
  'DapEval',
  'DapToggleRepl',

  -- Breakpoints
  'DapClearBreakpoints',
  'DapToggleBreakpoint',

  -- Diagnostics
  'DapSetLogLevel',
  'DapShowLog',
}

function M.lazyspec.config(lazyspec)
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
end

return M
