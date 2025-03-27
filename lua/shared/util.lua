
local M = {}

function M.is_user_cmdline(mode)
  return vim.v.event.cmdlevel == 1 or vim.v.event.cmdtype == mode
end

function M.buf_is_normal(bufnr)
  return vim.api.nvim_buf_get_option(bufnr or 0, 'buftype') == ''
end

return M
