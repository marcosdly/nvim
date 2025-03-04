--[[
  General auto commands.
--]]

local autocmd = vim.api.nvim_create_autocmd

-- Toggle relative numbers on insert mode enter/leave
autocmd('InsertEnter', { pattern = '*', command = 'set norelativenumber' })
autocmd('InsertLeave', { pattern = '*', command = 'set relativenumber' })

-- Only highlight search matches while searching
autocmd('CmdlineEnter', { pattern = '*', command = 'set hlsearch' })
autocmd('CmdlineLeave', { pattern = '*', command = 'set nohlsearch' })

-- Force buffers to be hard linked to their window
autocmd('WinNew', { pattern = '*', command = 'set winfixbuf' })

-- Set fold marker
autocmd('BufEnter', {
  pattern = '*',
  callback = function(event)
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
})
