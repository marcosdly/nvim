return {
  {
    'gerazov/toggle-bool.nvim',
    cond = false,
    pin = true,
    opts = {
      mapping = '<leader>ab',
      additional_toggles = {
        ['0'] = '1',
      },
    },
  },
  {
    'nacro90/numb.nvim',
    opts = {
      show_number = true,
      show_cursorline = false,
      hide_relativenumber = true,
      number_only = true,
      centered_peeking = true,
    },
  },
  {
    'Jxstxs/conceal.nvim',
    cond = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      ['lua'] = {
        keywords = {
          ['local'] = {
            conceal = 'L',
          },
          ['return'] = {
            conceal = 'R',
          },
          ['for'] = {
            conceal = 'F',
            highlight = 'keyword',
          },
          ['function'] = {
            conceal = 'Fn',
          },
          ['end'] = {
            conceal = 'E',
          },
        },
      },
    },
    config = function(lazyspec)
      local conceal = require 'conceal'
      conceal.setup(lazyspec.opts)
      conceal.generate_conceals()
      vim.keymap.set('n', 'tc', function()
        vim.wo.conceallevel = vim.wo.conceallevel == 0 and 1 or 0
      end)
    end,
  },
  {
    'echasnovski/mini.surround',
    opts = {
      respect_selection_type = true,
    },
  },
}
