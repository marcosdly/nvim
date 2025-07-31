local o, go = vim.o, vim.go

o.cdhome = false
o.hlsearch = true
o.scrolloff = 5
go.shortmess = "laoOstIcF"
o.smoothscroll = true
o.swapfile = false
o.errorbells = false
o.backupcopy = "no"
o.virtualedit = "onemore"
o.wildignorecase = true
o.ignorecase = true
o.smartcase = true
-- keep clipboard inside neovim only
o.clipboard = ""
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000
vim.g.clipboard = vim.g.vscode_clipboard
