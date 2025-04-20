local M = {}

M.TRUE = 1
M.FALSE = 0
M.is_windows = jit.os == 'Windows'
M.is_linux = jit.os == 'Linux'
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
M.second = 1000
M.minute = 1000 * 60
M.kilobyte = 1024
M.megabyte = 1024 * 1024

return M
