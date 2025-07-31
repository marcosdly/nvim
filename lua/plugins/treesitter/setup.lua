local const = require 'lib.helpful_constants'
local install = require 'nvim-treesitter.install'
local storage_size = const.storage_size

install.prefer_git = true
-- C compiler priority order
install.compilers = { 'zig', 'clang', 'gcc', 'cc', 'cl', vim.fn.getenv 'CC' }

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

require('nvim-treesitter.configs').setup {
  sync_install = false,
  auto_install = true,
  ensure_installed = {
    -- good to have, daily basis stuff
    'luadoc',
    'luap',
    'vimdoc',
    'markdown',
    'markdown_inline',
    'powershell',
    'bash',
    'printf',
    'regex',
    'ssh_config',
    'gitignore',
    'gitcommit',
    'gitattributes',
    'git_rebase',
    'git_config',
  },
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = storage_size.kilobyte * 100
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then return true end
      return false
    end,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<leader>gs',
      node_incremental = '<cr>',
      scope_incremental = '<tab>',
      node_decremental = '<s-tab>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- SEE textobjects.scm, locals.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    -- TODO move operation
  },
}

require('nvim-ts-autotag').setup {
  opts = {
    enable_close_on_slash = true, -- Auto close on trailing </
  },
  -- LSP may break because was formatted in insert mode
  -- SEE https://github.com/windwp/nvim-ts-autotag/issues/19
}
