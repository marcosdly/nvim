
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
  config = function(opts)
    _G.oil_state = { view_detail = false }

    local function oil_toggle_details()
      local oil = require('oil')
      oil_state.view_detail = not oil_state.view_detail
      if oil_state.view_detail then
        oil.set_columns({ 'mtime', 'size', 'permissions' })
      else
        oil.set_columns({})
      end
    end

    local opts_override = {
      keymaps = {
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = oil_toggle_details
        }
      }
    }

    require('oil').setup(vim.tbl_deep_extend('force', opts, opts_override))
  end,
  keys = {
    { '-', '<cmd>Oil --float<cr>' }, -- open parent
    { '<leader>-', '<cmd>Oil --float --trash<cr>' }, -- parent's trash
    { '<localleader>-', '<cmd>Oil --float --trash /<cr>' } -- all trash
  }
}

local wakatime = {
  'wakatime/vim-wakatime',
  event = 'VeryLazy'
}

local surround = {
  'echasnovski/mini.surround',
  event = 'VeryLazy',
  opts = {
    respect_selection_type = true
  }
}

local formatter = {
  'mhartington/formatter.nvim',
  event = 'VeryLazy',
  cmd = { 'Format', 'FormatLock', 'FormatWrite', 'FormatWriteLock' },
  opts = {
    logging = false,
    log_level = vim.log.levels.WARN
  },
  config = function(opts)
    local formatter = require('formatter')
    local filetypes = require('formatter.filetypes')

    local opts_override = {
      filetype = {
        -- ['*'] = {
        --   filetypes.any.substitute_trailing_whitespace
        -- },
        lua = {
          filetypes.lua.stylua
        }
      }
    }

    formatter.setup(vim.tbl_deep_extend('force', opts, opts_override))
  end,
  keys = {
    { '<leader>f', '<cmd>FormatLock<cr>' },
    { '<leader>F', '<cmd>FormatWriteLock<cr>' }
  }
}

local treeshitter = {
  'nvim-treesitter/nvim-treesitter',
  event = { 'VeryLazy', 'BufEnter' },
  build = ':TSUpdate',
  opts = {
    sync_install = false,
    auto_install = true,
    ensure_installed = {
      -- good to have, daily basis stuff
      'c',
      'lua',
      'luadoc',
      'lua_patterns',
      'vim',
      'vimdoc',
      'json',
      'toml',
      'yaml',
      'xml',
      'markdown',
      'markdown_inline',
      'powershell',
      'bash',
      -- trully useful, be-sure-to-haves
      'printf',
      'regex',
      'editorconfig',
      'dockerfile',
      'ssh_config',
      -- vanity
      'gitignore',
      'gitcommit',
      'gitattributtes',
      'git_rebase',
      'git_config',
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
      end,
      additional_vim_regex_highlighting = false
    },
    indent = { enable = true }
    -- TODO treesitter folding
    -- TODO treesitter incremental selection
    -- TODO treesitter install options
  }
}

local lspconfig = 'neovim/nvim-lspconfig'

local masonlspconfig = {
  'williamboman/mason-lspconfig.nvim',
  event = { 'VeryLazy', 'BufEnter' },
  dependencies = {
    {
      'williamboman/mason.nvim',
      priority = 10,
      opts = {
        pip = {
          upgrade_pip = true
        },
        ui = {
          border = 'round',
          backdrop = 0
        }
      }
    }
  },
  opts = {
    automatic_installation = false,
    ensure_installed = { 'lua_ls', 'jsonls' }
  },
  config = function(opts)
    local mason_lspconfig = require('mason-lspconfig')

    local function default_handler(server_name)
      local lspconfig = require('lspconfig')
      lspconfig[server_name].setup({})
    end

    mason_lspconfig.setup(opts)
    mason_lspconfig.setup_handlers({ default_handler })
  end
}

local lazygit = {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  keys = {
    -- status
    { '<leader>lgs', '<cmd>LazyGit<cr>' },
    -- current
    { '<leader>lgc', '<cmd>LazyGitCurrentFile<cr>' },
  }
}

return {
  telescope,
  lualine,
  oil,
  wakatime,
  surround,
  formatter,
  lspconfig,
  masonlspconfig,
  treeshitter,
  lazygit
}

