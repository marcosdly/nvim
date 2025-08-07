local bootstrap = require 'bootstrap'
local vscode = require 'vscode'

local options_default = {
  ['editor.lineNumbers'] = 'relative',
}

vim.g.clipboard = vim.g.vscode_clipboard
vim.notify = vscode.notify

bootstrap.SetOptions {
  cdhome = false,
  hlsearch = true,
  scrolloff = 5,
  shortmess = 'laoOstIcF',
  smoothscroll = true,
  swapfile = false,
  errorbells = false,
  backupcopy = 'no',
  virtualedit = 'onemore',
  wildignorecase = true,
  ignorecase = true,
  smartcase = true,
  -- keep clipboard inside neovim only
  clipboard = '',
  undofile = true,
  undolevels = 1000,
  undoreload = 10000,
}

bootstrap.SetAutocmds {
  -- Toggle relative numbers on insert mode enter/leave
  {
    'InsertEnter',
    function()
      vscode.update_config('editor.lineNumbers', 'on', 'global')
    end,
    desc = 'ENABLE relativenumber',
  },
  {
    'InsertLeave',
    function()
      vscode.update_config('editor.lineNumbers', 'relative', 'global')
    end,
    desc = 'DISABLE relativenumber',
  },
  -- Set options back to default at startup
  {
    'VimEnter',
    function()
      local vscode = require 'vscode'
      for k, v in pairs(options_default) do
        vscode.update_config(k, v, 'global')
      end
    end,
    desc = 'Set options back to default on start',
  },
}
