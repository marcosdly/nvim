dly.options = {}

dly.options.default = {
  -- TODO: See fold, complete, im, spell, thesaurus, win

  -- ui
  background = "dark",
  cursorline = true,
  cursorcolumn = true,
  cmdheight = 2,
  number = true,
  numberwidth = 2,
  relativenumber = false, -- changes elsewhere
  rulerformat = "All",
  showbreak = "> ",
  sidescroll = 3,
  sidescrolloff = 3,
  syntax = "ON",
  termguicolors = true,
  colorcolumn = "88",

  -- editing
  autowrite = true,
  breakat = vim.o.breakat .. "\\",
  copyindent = true,
  expandtab = true,
  shiftround = true,
  shiftwidth = 2,
  startofline = true,

  -- neovim
  confirm = true,
  endoffile = true,
  fileignorecase = true,
  ignorecase = true,
  linebreak = true,
  smartcase = true,
  smartindent = true,
  -- smoothscroll = true, -- unavailable in 0.9.x
  title = true,
  titlestring = "beep boop bits to drive go :wqa",
  wildignorecase = true,
}

dly.options.windows = {
  shell = "powershell.exe",
}

if vim.fn.has "win32" then
  dly.options.active = vim.tbl_extend("force", dly.options.default, dly.options.windows)
end

for key, value in pairs(dly.options.active) do
  vim.opt[key] = value
end

return true
