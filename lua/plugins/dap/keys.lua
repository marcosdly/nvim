local set = vim.keymap.set
local dap = require("dap")
local dapui = require("dapui")
local helper = require("plugins.dap.helper")

-- region Session
set("n", "<leader>dc", function()
  helper.refresh_config()
  dap.continue()
end)
set("n", "<leader>dC", dap.reverse_continue)
set("n", "<leader>dr", dap.restart)
set("n", "<leader>dR", dap.restart_frame)
set("n", "<leader>dp", dap.pause)
set("n", "<leader>dt", dap.terminate)
set("n", "<leader>di", function()
  helper.refresh_config()
  dap.status()
end)
set("n", "<leader>dI", function()
  helper.refresh_config()
  dap.sessions()
end)
set("n", "<leader>dD", dap.disconnect)
set("n", "<leader>dg", dapui.toggle)
-- endregion

-- region Breakpoints
set("n", "<leader>db", dap.toggle_breakpoint)
set("n", "<leader>dB", function()
  helper.refresh_config()
  dap.list_breakpoints()
end)
set("n", "<leader>dC", dap.clear_breakpoints)
-- endregion

-- region Navigation
set("n", "<leader>dl", dap.step_over)
set("n", "<leader>dh", dap.step_back)
set("n", "<leader>dk", dap.step_out)
set("n", "<leader>dj", dap.step_into)
set("n", "<leader>dp", dap.up)
set("n", "<leader>dn", dap.down)
set("n", "<leader>df", dap.focus_frame)
set("n", "<leader>du", dap.run_to_cursor)
-- endregion

-- region REPL (Debug Console)
set("n", "<leader>dco", dap.repl.open)
set("n", "<leader>dcc", dap.repl.close)

set(
  "v",
  "<leader>dce",
  -- TODO exec text from selection
  dap.repl.execute
)
-- endregion

-- TODO goto line dap.goto_()
-- TODO dap widgets
