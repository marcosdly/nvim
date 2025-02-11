
local o, g, go = vim.o, vim.g, vim.go

local GLOBAL_OPTIONS = {
  number = true,
  -- relativenumber = true,  -- set in autocmd
}

for key, value in pairs(GLOBAL_OPTIONS) do
  vim.go[key] = value
end

