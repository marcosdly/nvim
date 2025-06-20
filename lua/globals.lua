-- global state namespace
_G.state = {
  -- region LSP
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  lsp_progress = vim.defaulttable(),
  ---@type table<string, boolean>
  lsp_done = {},
  lsp_is_all_progress_done = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if not state.lsp_done[client.name] then return false end
    end
    return true
  end,
  -- endregion
}

_G.util = require 'lib.util'
_G.const = require 'lib.helpful_constants'

_G.TRUE = 1
_G.FALSE = 0
_G.IS_WINDOWS = jit.os == 'Windows'
_G.IS_LINUX = jit.os == 'Linux'
