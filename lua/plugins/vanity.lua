local LazyNvim = require('bootstrap').LazyNvim

local plugins = {
  {
    'nacro90/numb.nvim',
    opts = {
      show_number = true,
      show_cursorline = true,
      hide_relativenumber = true,
      number_only = true,
      centered_peeking = true,
    },
  },
  {
    'zongben/capsoff.nvim',
    cond = vim.g.is_windows,
    build = ':CapsLockOffBuild',
    config = function()
      require('capsoff').setup { auto = false }
      vim.api.nvim_create_autocmd('InsertLeave', {
        desc = 'Disable CAPSLOCK when leaving insert mode (Windows, linux/X11)',
        command = 'CapsLockOff',
        nested = true,
      })
    end,
  },

  {
    'shortcuts/no-neck-pain.nvim',
    opts = {
      debug = false,
      width = 88,
      disableOnLastBuffer = true,
      autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        reloadOnColorSchemeChange = true,
        skipEnteringNoNeckPainBuffer = true,
      },
      buffers = {
        setNames = false,
        scratchPad = { enabled = false },
        wo = {
          fillchars = 'eob: ',
        },
        bo = {
          buftype = 'nofile',
        },
        left = {
          enabled = false,
        },
        right = {
          enabled = false,
        },
      },
      integrations = {
        NvimTree = { reopen = false },
        NeoTree = { reopen = false },
        undotree = { reopen = false },
        neotest = { reopen = false },
        TSPlayground = { reopen = false },
        NvimDAPUI = { reopen = false },
        outline = { reopen = false },
        aerial = { reopen = false },
        dashboard = { enabled = false },
      },
      mappings = {
        enabled = false,
      },
    },
  },
  {
    'zaldih/themery.nvim',
    cond = false,
    config = function()
      local function get_std_colorscheme_names()
        return vim
          .iter(vim.api.nvim_get_runtime_file('colors/*.{vim,lua}', true))
          :map(function(path)
            return vim.fs.basename(path):sub(0, -5)
          end)
          :totable()
      end

      require('themery').setup {
        themes = get_std_colorscheme_names(),
        livePreview = true,
      }
    end,
  },
  {
    'folke/which-key.nvim',
    config = function()
      local whichkey = require 'which-key'

      whichkey.setup {
        preset = 'helix',
        filter = function(mapping)
          return mapping.desc and mapping.desc ~= ''
        end,
        -- icons = {
        --   mappings = false,
        -- },
        replace = {
          desc = {
            -- defaults
            { '<Plug>%(?(.*)%)?', '%1' },
            { '^%+', '' },
            { '<[cC]md>', '' },
            { '<[cC][rR]>', '' },
            { '<[sS]ilent>', '' },
            { '^lua%s+', '' },
            { '^call%s+', '' },
            { '^:%s*', '' },

            -- custom
            { '^.+:%s+', '' },
          },
        },
      }
    end,
  },
  {
    'jovanlanik/fsplash.nvim',
    config = function()
      local fsplash = require 'fsplash'

      local lines = [[
           _  ___   _____ __  __
          | \| \ \ / /_ _|  \/  |
          | .` |\ V / | || |\/| |
          |_|\_| \_/ |___|_|  |_|
      ]]

      local lines_as_list =
        vim.iter(vim.split(lines, '\n', { trimempty = true })):map(vim.trim):totable()

      fsplash.setup {
        -- lines of text containing the splash
        lines = lines_as_list,
        -- autocmds that close the splash
        autocmds = {
          'ModeChanged',
          'CmdlineEnter',
        },
        -- highlights in this table will be set using vim.api.nvim_set_hl()
        highlights = {
          -- this resets NormalFloat
          ['NormalFloat'] = {},
          -- the following line would set it to gray
          -- ['NormalFloat'] = { ctermfg = 'darkgray' };
        },
        -- floting window border
        border = 'solid',
        -- winblend option
        winblend = 0,
      }
    end,
  },
}

LazyNvim:SetPriority(plugins, {
  'folke/which-key.nvim',
  'nacro90/numb.nvim',
  'zongben/capsoff.nvim',
  'shortcuts/no-neck-pain.nvim',
  'zaldih/themery.nvim',
  'jovanlanik/fsplash.nvim',
})

return plugins
