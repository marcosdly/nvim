local M = {}

-- TODO telescope select set exception breakpoint
-- TODO telescope list breakpoints

M.lazyspec_keys = {
  -- region Session
  {
    'n',
    '<leader>dr',
    function()
      require('dap').continue()
    end,
  },
  {
    'n',
    '<leader>dR',
    function()
      require('dap').restart()
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
  -- endregion

  -- TODO goto line dap.goto_()
  -- TODO focus frame dap.focus_frame()
  -- TODO run until cusor dap.run_to_cursor()
  -- TODO dap.repl
  -- TODO other dap functions
  -- TODO dap widgets
  -- TODO dap launch config
}

return M
