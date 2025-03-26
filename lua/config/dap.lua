local M = {}

-- TODO telescope select set exception breakpoint
-- TODO telescope list breakpoints

M.util = {}

function M.util.refresh_config()
  require('dap.ext.vscode').load_launchjs()
  -- TODO load configs from neodev's config file
  -- TODO watch files for changes
end

M.lazyspec_keys = {
  -- region Session
  {
    'n',
    '<leader>dc',
    function()
      M.util.refresh_config()
      require('dap').continue()
    end,
  },
  {
    'n',
    '<leader>dC',
    function()
      require('dap').reverse_continue()
    end,
  },
  {
    'n',
    '<leader>dr',
    function()
      require('dap').restart()
    end,
  },
  {
    'n',
    '<leader>dR',
    function()
      require('dap').restart_frame()
    end,
  },
  {
    'n',
    '<leader>dp',
    function()
      require('dap').pause()
    end,
  },
  {
    'n',
    '<leader>dt',
    function()
      require('dap').terminate()
    end,
  },
  {
    'n',
    '<leader>di',
    function()
      M.util.refresh_config()
      require('dap').status()
    end,
  },
  {
    'n',
    '<leader>dI',
    function()
      M.util.refresh_config()
      require('dap').sessions()
    end,
  },
  {
    'n',
    '<leader>dD',
    function()
      require('dap').disconnect()
    end,
  },
  -- endregion

  -- region Breakpoints
  {
    'n',
    '<leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
  },
  {
    'n',
    '<leader>dB',
    function()
      M.util.refresh_config()
      require('dap').list_breakpoints()
    end,
  },
  {
    'n',
    '<leader>dC',
    function()
      require('dap').clear_breakpoints()
    end,
  },
  -- endregion

  -- region Navigation
  {
    'n',
    '<leader>dl',
    function()
      require('dap').step_over()
    end,
  },
  {
    'n',
    '<leader>dh',
    function()
      require('dap').step_back()
    end,
  },
  {
    'n',
    '<leader>dk',
    function()
      require('dap').step_out()
    end,
  },
  {
    'n',
    '<leader>dj',
    function()
      require('dap').step_into()
    end,
  },
  {
    'n',
    '<leader>dp',
    function()
      require('dap').up()
    end,
  },
  {
    'n',
    '<leader>dn',
    function()
      require('dap').down()
    end,
  },
  {
    'n',
    '<leader>df',
    function()
      require('dap').focus_frame()
    end,
  },
  {
    'n',
    '<leader>du',
    function()
      require('dap').run_until_cursor()
    end,
  },
  -- endregion

  -- region REPL (Debug Console)
  {
    'n',
    '<leader>dco',
    function()
      require('dap').repl.open()
    end,
  },
  {
    'n',
    '<leader>dcc',
    function()
      require('dap').repl.close()
    end,
  },
  {
    'v',
    '<leader>dce',
    function()
      -- TODO exec text from selection
      require('dap').repl.execute()
    end,
  },
  -- endregion

  -- TODO goto line dap.goto_()
  -- TODO other dap functions
  -- TODO dap widgets
}

M.lazyspec_cmd = {
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

return M
