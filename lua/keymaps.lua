dly.keymaps = {}

local keys = { "buffer", "nowait", "silent", "script", "expr", "unique" }

dly.keymaps.default = {
  { "n", "<C-s>", "<cmd>write<cr>", silent = true, unique = true, nowait = true },
  {
    { "n", "x" },
    "j",
    "gj",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
  {
    { "n", "x" },
    "k",
    "gk",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
  {
    { "n", "x" },
    "<down>",
    "gj",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
  {
    { "n", "x" },
    "<up>",
    "gk",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
  {
    "i",
    "<down>",
    "<C-O>gj",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
  {
    "i",
    "<up>",
    "<C-O>gk",
    silent = true,
    unique = true,
    nowait = true,
    noremap = true,
  },
}

dly.keymaps.active = vim.tbl_extend("force", dly.keymaps.default, {})

for _, map in ipairs(dly.keymaps.active) do
  local opts = {}

  for _, key in ipairs(keys) do
    if map[key] ~= nil then opts[key] = map[key] end
  end

  vim.keymap.set(map[1], map[2], map[3], opts)
end
