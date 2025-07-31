local M = {}

function M.set_foldmarker_per_buf(event)
  -- NOTE global option is the fallback value
  if not vim.api.nvim_buf_is_loaded(event.buf) then
    return
  end
  local pattern
  if vim.o.commentstring ~= "" then
    pattern = vim.o.commentstring
  elseif vim.go.commentstring ~= "" then
    pattern = vim.go.commentstring
  else
    -- no comment string set
    return
  end
  -- set locally only
  vim.o.foldmarker = string.format("%s,%s", string.format(pattern, "region"), string.format(pattern, "endregion"))
end

return M
