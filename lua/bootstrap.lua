--[[
  Bootstrap lazy.nvim
--]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazybranch = 'stable'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--depth=1", "--branch=" .. lazybranch, lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  defaults = {
    lazy = true
  },
  spec = {
    { import = 'plugins' },
  },
  install = {
    -- colorscheme that will be used when installing plugins.
    colorscheme = { 'habamax' }
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    concurrency = 1,
    check_pinned = true,
    frequency = 3600 * 24 -- 1 day (seconds)
  },
  ui = { border = 'rounded', title = 'Plugins', title_pos = 'center' },
})

