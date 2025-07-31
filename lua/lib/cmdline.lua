local M = {}

function M.cmdline_lua_output_to_new_buf(direction)
  if not shared.util.is_user_sub_cmdline(":", "==") then
    error("cmdline register : does not start with ==")
  end
  local lua_cmd = vim.trim(vim.fn.getreg(":"):sub(3))
  if lua_cmd == "" then
    error("lua command is empty")
  end
  local vim_cmd_metadata = vim.api.nvim_parse_cmd(":= " .. lua_cmd, {})
  local parsed_cmd = vim.empty_dict()
  for key, value in pairs(vim_cmd_metadata) do
    parsed_cmd[key] = value
  end
  local output = vim.api.nvim_cmd(parsed_cmd, { output = true })
  local bufnr = vim.api.nvim_create_buf(true, true)
  if bufnr == 0 then
    error("error while creating scratchpad buffer")
  end
  vim.api.nvim_buf_call(bufnr, function()
    vim.bo.modifiable = false
    vim.bo.readonly = true
    vim.bo.swapfile = false
    vim.bo.autoread = false
    vim.bo.autowrite = false
    vim.bo.autowriteall = false
    vim.bo.bufhidden = "delete"
    vim.bo.buftype = "luaoutput"
    vim.bo.endoffile = true
    vim.bo.expandtab = true
    vim.bo.fileencoding = "utf-8"
    vim.bo.filetype = "lua"
  end)
  local lines = vim.iter(vim.gsplit(output, "\n")):map(vim.trim):totable()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  if direction == "horizontal" then
    vim.cmd("hsplit")
  elseif direction == "vertical" then
    vim.cmd("vsplit")
  end
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
end

return M
