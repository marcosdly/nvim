local LazyNvim = require('bootstrap').LazyNvim

local plugins = {
  {
    'Joakker/lua-json5',
    optional = true,
    pin = true,
    build = vim.g.is_windows and 'powershell ./install.ps1' or './install.sh',
  },
  'echasnovski/mini.icons',
  {
    'nvim-tree/nvim-web-devicons',
    config = true,
  },
  'wakatime/vim-wakatime',
  {
    'folke/neoconf.nvim',
    opts = {
      plugins = {
        dap = {
          enabled = true,
        },
      },
    },
  },
  {
    'rmagatti/auto-session',
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>Ss', '<cmd>SessionSearch<cr>', desc = 'AutoSession: Search' },
      { '<leader>Sw', '<cmd>SessionSave<cr>', desc = 'AutoSession: Quick save' },
      { '<leader>Sn', ':SessionSave ', desc = 'AutoSession: Save as...' },
      { '<leader>St', ':SessionToggleAutoSave', desc = 'AutoSession: Toggle autosave' },
    },
    opts = {
      use_git_branch = true,
      continue_restore_on_error = false,
      cwd_change_handling = true,
      lsp_stop_on_restore = true,
      args_allow_single_directory = true,
      args_allow_files_auto_save = false,
      session_lens = {
        load_on_setup = true,
        previewer = true,
      },
      auto_create = function()
        local cmd = 'git rev-parse --is-inside-work-tree'
        return vim.fn.system(cmd) == 'true\n'
      end,
    },
    config = function(lazyspec)
      require('auto-session').setup(lazyspec.opts)
      vim.o.sessionoptions =
        'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
    end,
  },
}

LazyNvim:SetPriority(plugins, {
  'wakatime/vim-wakatime',
  'Joakker/lua-json5',
  'folke/neoconf.nvim',
  'rmagatti/auto-session',
  'echasnovski/mini.icons',
  'nvim-tree/nvim-web-devicons',
})

return plugins
