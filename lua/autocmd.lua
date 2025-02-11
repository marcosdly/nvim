--[[
  General auto commands.
--]]

-- Toggle relative numbers on insert mode enter/leave
vim.api.nvim_create_autocmd('InsertEnter', { pattern = '*', command = 'set relativenumber' })
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set norelativenumber' })
