
local M = {}

function M.is_user_cmdline(mode)
  return vim.v.event.cmdlevel == 1 or vim.v.event.cmdtype == mode
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
