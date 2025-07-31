local lualine = require("lualine")
local c = require("plugins.lualine.components")

lualine.setup({
  options = {
    theme = "auto",
    icons_enabled = true,
    globalstatus = true,
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      c.mode,
    },
    lualine_b = {
      "branch",
      c.diff,
    },
    lualine_c = {
      c.buffer_count,
      c.filename,
      c.filesize,
    },
    lualine_x = {
      c.lsp_status,
      c.diagnostics,
      c.session_status,
      c.keymap,
    },
    lualine_y = {
      c.selection_count,
    },
    lualine_z = {
      c.location,
    },
  },
})
