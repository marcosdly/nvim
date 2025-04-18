
local M = {}

function M.is_user_cmdline(mode)
  return vim.v.event.cmdlevel == 1 and vim.v.event.cmdtype == mode
end

function M.is_user_sub_cmdline(mode, prefix)
  if not M.is_user_cmdline(mode) then return false end
  vim.print('here')
  local reg_content = vim.fn.getreg(mode)
  if reg_content == '' then return false end
  prefix = vim.trim(prefix)
  if reg_content:len() < prefix:len() then return false end
  if reg_content:len() == prefix:len() and reg_content == prefix then return true end
  return vim.startswith(reg_content, prefix .. ' ')
end

function M.buf_is_normal(bufnr)
  return vim.api.nvim_buf_get_option(bufnr or 0, 'buftype') == ''
end

function M.pure_math_int_string_length(n)
  -- pure math string length of integer, which seems faster
  -- source: voices in my head
  -- SEE https://stackoverflow.com/a/10952773
  return math.ceil(math.log10(n + 1))
end

return M
