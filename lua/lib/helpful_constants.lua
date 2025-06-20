local M = {}

M.icons = {
  diagnostic = {
    error = '󰅚', -- x000f015a
    warn = '󰀪', -- x000f002a
    info = '󰋽', -- x000f02fd
    hint = '󰌶', -- x000f0336
  },
  misc = {
    center_small_dot = '·',
    center_big_dot = '•',
    bottom_small_dot = '.',
  },
}

M.time_delay = {
  second = 1000,
  minute = 1000 * 60,
}

M.storage_size = {
  kilobyte = 1024,
  megabyte = 1024 * 1024,
}

return M
