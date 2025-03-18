
local telescope = {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- cmake is the starndard way of building; may be broken on windows
      -- SEE https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/122
      build = vim.fn.join({
        'mkdir build', '&&',
        'zig cc -O3 -Wall -Werror -fpic -std=gnu99 -shared src/fzf.c -o build/libfzf.dll'
      })
    }
  },
  opts = {
    extensions = {
      fzf = {
        -- those are the defaults, but all too important for my use
        -- keep them as explicit documentation/reinforcement for future updates
        fuzzy = true,
        override_generic_sorted = true,
        override_file_sorted = true,
        case_mode = 'smart_case',
      }
    }
  },
  config = function(opts)
    require('telescope').load_extension('fzf')
  end,
  cmd = 'Telescope',
  event = 'VeryLazy',
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>' },
    { '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<cr>' },
    -- git
    { '<leader>fgf', '<cmd>Telescope git_files<cr>' },
    { '<leader>fgs', '<cmd>Telescope git_status<cr>' },
    { '<leader>fgc', '<cmd>Telescope git_commits<cr>' },
    { '<leader>fgt', '<cmd>Telescope git_stash<cr>' },
    { '<leader>fgb', '<cmd>Telescope git_branches<cr>' },
    -- vim
    { '<leader>fvh', '<cmd>Telescope help_tags<cr>' },
    { '<leader>fvo', '<cmd>Telescope vim_options<cr>' },
    { '<leader>fvs', '<cmd>Telescope search_history<cr>' },
    { '<leader>fvr', '<cmd>Telescope registers<cr>' },
    { '<leader>fvk', '<cmd>Telescope keymaps<cr>' },
    { '<leader>fvc', '<cmd>Telescope command_history<cr>' },
    { '<leader>fvl', '<cmd>Telescope spell_suggest<cr>' }
  }
}

--[[
Relevant modes and variants:
SEE :h mode()
  n       Normal
  nt      Normal,Terminal
  v       Visual
  V       Visual,Line
  CTRL-V  Visual,Block
  s       Select
  S       Select,Line
  CTRL-S  Select,Block
  i       Insert
  R       Replace
  Rv      Replace,Virtual
  c       Command
  cv      Ex
  r       Prompt
  !       Shell/external command running
  t       Terminal
]]

local lualine = {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  lazy = false,
  opts = {
    options = {
      icons_enabled = false,
    },
    sections = {
      lualine_a = {
        -- mode
        function()
          return vim.fn.printf('%-2s', vim.fn.mode():sub(1, 2):upper())
        end
      },
    }
  }
}

local oil = {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    default_file_explorer = true,
    columns = {
      'type',
      'size',
      'permissions'
    },
    buf_options = {
      autowrite = false,
      autowriteall = false
    },
    win_options = {
      cursorline = true,
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    constrain_cursor = false,
    watch_for_changed = true,
    view_options = {
      show_hidden = true
    },
    float = {
      max_height = 0.8,
      max_width = 88,
      preview_split = 'right'
    }
  },
  keys = {
    -- TODO open trash (all)
    -- TODO open trash (cwd)
    -- TODO open float
  }
}

local wakatime = {
  'wakatime/vim-wakatime',
  event = 'VeryLazy'
}

return {
  telescope,
  lualine
  oil,
  wakatime
}

