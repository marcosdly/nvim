local spec = {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- cmake is the starndard way of building; may be broken on windows
      -- SEE https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/122
      build = vim.fn.join {
        'mkdir build',
        '&&',
        'zig cc -O3 -Wall -Werror -fpic -std=gnu99 -shared src/fzf.c -o build/libfzf.dll',
      },
    },
  },
  config = function()
    local actions = require 'telescope.actions'
    local telescope = require 'telescope'

    telescope.setup {
      extensions = {
        fzf = {
          -- those are the defaults, but all too important for my use
          -- keep them as explicit documentation/reinforcement for future updates
          fuzzy = true,
          override_generic_sorted = true,
          override_file_sorted = true,
          case_mode = 'smart_case',
        },
      },
      defaults = {
        mappings = {
          i = {
            ['<c-c>'] = actions.close,
          },
          n = {
            ['<c-c>'] = actions.close,
          },
        },
      },
    }

    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
  end,
}

require('bootstrap').LazyNvim:SetPriority { spec }

return spec
