--[[
  General auto commands.
--]]

local autocmd = vim.api.nvim_create_autocmd

-- Toggle relative numbers on insert mode enter/leave
autocmd('InsertEnter', { pattern = '*', command = 'set relativenumber' })
autocmd('InsertLeave', { pattern = '*', command = 'set norelativenumber' })

-- Only highlight search matches while searching
autocmd('CmdlineEnter', { pattern = '*', command = 'set hlsearch' })
autocmd('CmdlineLeave', { pattern = '*', command = 'set nohlsearch' })
