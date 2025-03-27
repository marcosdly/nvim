local M = {}

function M.mode()
  -- return raw vim mode
  -- 1 character modes are standalone
  -- 2 character modes are modes with modifiers
  -- standalone modes may be denoted by <CTRL-*> mappings, which are a single hex codepoint
  local mode = vim.fn.mode()
  if mode:len() == 1 then return vim.fn.keytrans(mode) end
  return mode:gsub(1, 2)
end

function M.buffer_count()
  local current_bufnr = vim.api.nvim_buf_get_number(0)
  local current_buf_i = current_bufnr
  local count = 0
  for i, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_get_option(bufnr, 'buftype') == '' -- normal buffer
    then
      count = count + 1
      if bufnr == current_bufnr then current_buf_i = i end
    end
  end
  if count == 1 then return '' end
  return vim.fn.printf(
    '%*d/%d',
    shared.util.pure_math_int_string_length(count),
    current_buf_i,
    count
  )
end

function M.filesize()
  local file = vim.fn.expand '%:p'
  if file == nil or #file == 0 then return '' end
  local size = vim.fn.getfsize(file)
  local min_size = 10 * 1024 -- 10kb
  if size <= 0 or size < min_size then return '' end

  local suffixes = { 'B', 'KiB', 'MiB', 'GiB' }
  local i = 1
  while size > 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end

  local format = i == 1 and '%d%s' or '%.2f%s'
  return string.format(format, size, suffixes[i])
end

function M.selection_count()
  -- SEE https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/selectioncount.lua
  local mode = vim.fn.mode(true)
  local line_start, line_end = vim.fn.line 'v', vim.fn.line '.'
  local col_start, col_end = vim.fn.col 'v', vim.fn.col '.'
  if not (mode == '' or mode:match '[vV]') then return '' end
  if line_start == line_end and col_start ~= col_end then -- character selection
    return vim.fn.printf(
      '%d:%d-%d (%dc)',
      line_start,
      col_start,
      col_end,
      math.abs(col_end - col_start) + 1
    )
  end
  if line_start ~= line_end and col_start == col_end then -- line selection
    return vim.fn.printf(
      '%d-%d (%dL)',
      line_start,
      line_end,
      math.abs(line_end - line_start) + 1
    )
  end
  if line_start ~= line_end and col_start ~= col_end then -- block selection
    return vim.fn.printf(
      '%d:%dx%d:%d (%dL%dc)',
      line_start,
      col_start,
      line_end,
      col_end,
      math.abs(col_end - col_start) + 1,
      math.abs(line_end - line_start) + 1
    )
  end
  return ''
end

function M.location()
  local cursor_tup = vim.api.nvim_win_get_cursor(0)
  local row, column = cursor_tup[1] or 0, cursor_tup[2] or 0
  local count = vim.api.nvim_buf_line_count(0) or 0
  local row_padding = shared.util.pure_math_int_string_length(count)

  local percentage = 0
  if row > 0 and count > 0 then percentage = row / count * 100 end

  local position
  if row == 1 then
    position = 'Top'
  elseif row == count then
    position = 'Bot'
  else
    position = tostring(row)
  end

  local percentage_str = vim.fn.printf(' %5.1f%%%%', percentage)
  local line_str = vim.fn.printf('%*s/%d', row_padding, position, count)
  local col_str = vim.fn.printf(':%2d', column)
  if position == 'Top' or position == 'Bot' then
    -- fill with whitespace if it's all zeroes
    -- lualine requires double the % characters to print them literally,
    -- so subtract `count('%')/2` from length
    percentage_str = string.rep(' ', percentage_str:len() - 1)
    if column == 0 then col_str = string.rep(' ', col_str:len()) end
  end
  return line_str .. col_str .. percentage_str
end

M.diagnostics = {
  'diagnostics',
  colored = false,
  update_in_insert = true,
  symbols = {
    error = shared.const.icons.diagnostic.error .. ' ',
    warn = shared.const.icons.diagnostic.warn .. ' ',
    info = shared.const.icons.diagnostic.info .. ' ',
    hint = shared.const.icons.diagnostic.hint .. ' ',
  },
}

return M
