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
  {
    'klen/nvim-config-local',
    config = function()
      require('config-local').setup {
        -- Default options (optional)

        -- Config file patterns to load (lua supported)
        config_files = { '.nvim.lua' },

        -- Where the plugin keeps files data
        hashfile = vim.fn.stdpath 'data' .. '/config-local',

        autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
        silent = false, -- Disable plugin messages (Config loaded/denied)
        lookup_parents = true, -- Lookup config files in parent directories
      }
    end,
  },
}

LazyNvim:SetPriority(plugins, {
  'wakatime/vim-wakatime',
  'Joakker/lua-json5',
  'folke/neoconf.nvim',
  'klen/nvim-config-local',
  'rmagatti/auto-session',
  'echasnovski/mini.icons',
  'nvim-tree/nvim-web-devicons',
})

return plugins
