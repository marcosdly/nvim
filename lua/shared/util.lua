local M = {}

function M.is_user_cmdline(mode)
  return vim.v.event.cmdlevel == 1 and vim.v.event.cmdtype == mode
end

function M.is_user_sub_cmdline(mode, prefix)
  if not M.is_user_cmdline(mode) then return false end
  vim.print 'here'
  local reg_content = vim.fn.getreg(mode)
  if reg_content == '' then return false end
  prefix = vim.trim(prefix)
  if reg_content:len() < prefix:len() then return false end
  if reg_content:len() == prefix:len() and reg_content == prefix then return true end
  return vim.startswith(reg_content, prefix .. ' ')
end

function M.is_mode_cmdline()
  return vim.fn.getcmdpos() > 0
end

function M.buf_local_option(name, bufnr)
  return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

function M.buf_is_normal(bufnr)
  return vim.api.nvim_get_option_value('buftype', { buf = bufnr or 0 }) == ''
end

function M.pure_math_int_string_length(n)
  -- pure math string length of integer, which seems faster
  -- source: voices in my head
  -- SEE https://stackoverflow.com/a/10952773
  return math.ceil(math.log10(n + 1))
end

function M.is_headless()
  if not FLAG.CAN_TEST_UI_RELATED then return false end
  return #vim.api.nvim_list_uis() == 0
end

function M.is_vscode_extension()
  return M.is_headless() and vim.g.vscode == true -- force cast to boolean
end

function M.is_gui_formal_nvim_wrapper()
  if not FLAG.CAN_TEST_UI_RELATED then return false end
  return vim.fn.has 'gui_running' and #vim.api.nvim_list_uis() > 0
end

function M.is_gui()
  return M.is_gui_formal_nvim_wrapper() or not M.is_headless()
end

return M
