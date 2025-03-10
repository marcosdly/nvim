
local M = {}

function M.set_foldmarker_by_filetype_per_buf(event)
  -- NOTE global option is the fallback value
  if not vim.api.nvim_buf_is_valid(event.buf) then
    return
  end
  if vim.o.foldmethod == '' and vim.go.foldmethod ~= 'marker' then
    -- no local option set, and global option is invalid
    return
  end
  if vim.o.foldmethod ~= 'marker' then
    -- local option is invalid
    return
  end
  local pattern
  if vim.o.commentstring ~= '' then
    pattern = vim.o.commentstring
  elseif vim.go.commentstring ~= '' then
    pattern = vim.go.commentstring
  else
    -- no comment string set
    return
  end
  if not string.find(pattern, '%s') then
    -- pattern substitution cannot be done
    return
  end
  -- set locally only
  vim.o.foldmarker = string.format(
    '%s,%s',
    string.format(pattern, 'region'),
    string.format(pattern, 'endregion')
  )
end

return M
