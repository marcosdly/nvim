-- TODO config https://old.reddit.com/r/neovim/comments/16xz3q9/treesitter_highlighted_folds_are_now_in_neovim/

local P = {}

function add(tab)
  if type(tab) ~= 'table' then return end
  tab.enabled = tab.enabled or true
  if not tab.enabled then return end
  tab.vscode = tab.vscode or false
  if vim.g.vscode and not tab.vscode then return end
  tab.priority = nil
  table.insert(P, tab)
end

function priority(id_list)
  local length = #id_list + 1000 -- minimum of 1000 to make numbers cleaner
  for i, _id in ipairs(id_list) do
    for _, tab in ipairs(P) do
      if tab[1] == _id then
        tab.priority = length - i
        break
      end
    end
  end
end

add {
  'nvim-tree/nvim-web-devicons',
  cmd = { 'NvimWebDeviconsHiTest' },
  event = 'VeryLazy',
  lazy = false,
  pin = true,
  config = true,
}

add {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
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
  opts = {
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
  },
  config = function(lazyspec)
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    local opts_override = {
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

    telescope.setup(vim.tbl_deep_extend('force', lazyspec.opts, opts_override))
    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
  end,
  cmd = 'Telescope',
  keys = {
    { 'svo', '<cmd>Telescope vim_options<cr>' },
    { 'svs', '<cmd>Telescope spell_suggest<cr>' },
  },
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

add {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local config = require 'config.lualine'
    lualine.setup {
      options = {
        theme = 'auto',
        icons_enabled = true,
        globalstatus = true,
        always_divide_middle = true,
      },
      sections = {
        lualine_a = {
          config.mode,
        },
        lualine_b = {
          'branch',
          {
            'diff',
            colored = true,
            fmt = function(str)
              return str:gsub('%s+', '')
            end,
          },
        },
        lualine_c = {
          config.buffer_count,
          {
            'filename',
            path = 1, -- relative path
          },
          config.filesize,
        },
        lualine_x = {
          config.diagnostics,
          config.session_status,
          config.keymap,
        },
        lualine_y = {
          config.selection_count,
        },
        lualine_z = {
          config.location,
        },
      },
    }
  end,
}

add {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    default_file_explorer = true,
    win_options = {
      cursorline = true,
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    constrain_cursor = false,
    watch_for_changed = true,
    view_options = {
      show_hidden = true,
    },
    float = {
      max_height = 0.8,
      max_width = 88,
      preview_split = 'right',
    },
  },
  config = function(lazyspec)
    shared.state.oil = {
      view_detail = false,
    }

    local oil = require 'oil'

    local opts_override = {
      keymaps = {
        ['<c-c>'] = 'actions.close',
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = function()
            shared.state.oil.view_detail = not shared.state.oil.view_detail
            oil.set_columns(
              shared.state.oil.view_detail and { 'mtime', 'size', 'permissions' } or {}
            )
          end,
        },
      },
    }

    oil.setup(vim.tbl_deep_extend('force', lazyspec.opts, opts_override))
  end,
  keys = {
    { '-', '<cmd>Oil --float<cr>' }, -- open parent
    { '<leader>-', '<cmd>Oil --float --trash<cr>' }, -- parent's trash
    { '<localleader>-', '<cmd>Oil --float --trash /<cr>' }, -- all trash
  },
}

add { 'wakatime/vim-wakatime', lazy = false }

add {
  'echasnovski/mini.surround',
  event = 'BufEnter',
  opts = {
    respect_selection_type = true,
  },
}

add {
  'mhartington/formatter.nvim',
  event = 'LspAttach',
  cmd = { 'Format', 'FormatLock', 'FormatWrite', 'FormatWriteLock' },
  opts = {
    logging = false,
    log_level = vim.log.levels.WARN,
  },
  keys = {
    { 'cf', '<cmd>FormatLock<cr>' },
    { 'cF', '<cmd>FormatWriteLock<cr>' },
  },
  config = function(lazyspec)
    local formatter = require 'formatter'
    local config = require 'config.formatter'

    formatter.setup(vim.tbl_deep_extend('force', lazyspec.opts, {
      filetype = config.get_defined_formatters(),
    }))
  end,
}

add {
  'windwp/nvim-ts-autotag',
  opts = {
    opts = {
      enable_close_on_slash = true, -- Auto close on trailing </
    },
  },
  -- if LSP breaks because was formatted in insert mode, uncomment this
  -- SEE https://github.com/windwp/nvim-ts-autotag/issues/19
  -- config = function(opts)
  -- require('nvim-ts-autotag').setup(opts)
  -- vim.lsp.handlers['textDocument/publishDiagnostics'] =
  --   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  --     underline = true,
  --     virtual_text = {
  --       spacing = 5,
  --       severity_limit = 'Warning',
  --     },
  --     update_in_insert = true,
  --   })
  -- end,
}

add {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
  },
  build = ':TSUpdate',
  opts = {
    sync_install = false,
    auto_install = true,
    ensure_installed = {
      -- good to have, daily basis stuff
      'c',
      'lua',
      'luadoc',
      'luap',
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
      'gitattributes',
      'git_rebase',
      'git_config',
      -- webdev
      'html',
      'javascript',
      'typescript',
      'tsx',
      'css',
      'scss',
      'templ', -- hugo
      'robots',
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = shared.const.kilobyte * 100
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
  },
  config = function(lazyspec)
    local treesitter = require 'nvim-treesitter.configs'
    local treesitter_install = require 'nvim-treesitter.install'

    treesitter_install.prefer_git = true
    -- C compiler priority order
    treesitter_install.compilers =
      { 'zig', 'clang', 'gcc', 'cc', 'cl', vim.fn.getenv 'CC' }

    treesitter.setup(lazyspec.opts)

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    -- Repeat movement with ; and ,
    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}

add {
  'gerazov/toggle-bool.nvim',
  enabled = false,
  pin = true,
  event = 'LspAttach',
  opts = {
    mapping = '<leader>ab',
    additional_toggles = {
      ['0'] = '1',
    },
  },
}

add {
  'neovim/nvim-lspconfig',
  init = function()
    local set = vim.keymap.set
    set('n', '<leader>la', vim.lsp.buf.code_action)
    -- f as in 'find'; j (down) as in here, myself, where I stand
    set('n', '<leader>fj', '<cmd>Telescope lsp_incoming_calls<cr>')
    -- f as in 'find'; k (up) as in there, somewhere, out
    set('n', '<leader>fj', '<cmd>Telescope lsp_outgoing_calls<cr>')
    set('n', '<leader>lr', vim.lsp.buf.rename)
    -- NOTE renaming accross workspace is dependent on LSP (implementation), some
    -- may support it, some may do it by default
    set('n', '<leader>ls', vim.lsp.buf.signature_help)
    -- f as in 'find'; p as in parent, what allowed it to be, from which is inherits
    set('n', '<leader>fp', '<cmd>Telescope lsp_type_definitions<cr>')
    -- TODO Telescope typehierarchy

    -- Diagnostics
    vim.diagnostic.config {
      underline = {
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
        },
      },
      update_in_insert = true,
      float = {
        severity_sort = true,
        source = 'if_many',
        border = 'rounded',
      },
      virtual_text = {
        source = false,
        spacing = 2,
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
        },
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = shared.const.icons.diagnostic.error,
          [vim.diagnostic.severity.WARN] = shared.const.icons.diagnostic.warn,
          [vim.diagnostic.severity.INFO] = shared.const.icons.diagnostic.info,
          [vim.diagnostic.severity.HINT] = shared.const.icons.diagnostic.hint,
        },
        -- numhl = {
        --   [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
        --   [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
        --   [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
        --   [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        -- },
        -- TODO numhl
      },
    }
  end,
}

add {
  'williamboman/mason.nvim',
  lazy = false,
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function(lazyspec)
    local mason_opts = {
      pip = {
        upgrade_pip = true,
      },
      ui = {
        border = 'rounded',
        backdrop = 0,
      },
    }

    local mason_lspconfig_opts = {
      automatic_installation = false,
      ensure_installed = { 'lua_ls', 'jsonls' },
      handlers = {
        -- default
        function(server_name)
          local lspconfig = require 'lspconfig'
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,
      },
    }

    local mason_dap_opts = {
      ensure_installed = { 'python' },
      automatic_installation = true,
      handlers = {}, -- sets up dap in the predefined manner
    }

    require('mason').setup(mason_opts)
    require('mason-lspconfig').setup(mason_lspconfig_opts)
    require('mason-nvim-dap').setup(mason_dap_opts)
  end,
}

local dap_config = require 'config.dap'
add {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'Joakker/lua-json5',
  },
  cond = function()
    return shared.util.buf_is_normal()
  end,
  keys = dap_config.keys,
  cmd = {
    -- Session management
    'DapContinue',
    'DapDisconnect',
    'DapNew',
    'DapTerminate',

    -- Stepping
    'DapRestartFrame',
    'DapStepInto',
    'DapStepOut',
    'DapStepOver',
    'DapPause',

    -- REPL
    'DapEval',
    'DapToggleRepl',

    -- Breakpoints
    'DapClearBreakpoints',
    'DapToggleBreakpoint',

    -- Diagnostics
    'DapSetLogLevel',
    'DapShowLog',
  },
  config = function(lazyspec)
    local dap, dapui = require 'dap', require 'dapui'
    local dap_vscode = require 'dap.ext.vscode'

    -- Listeners
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    -- Config
    dap_vscode.json_decode = require('json5').parse
    dap.configurations = dap_config.configurations
    dapui.setup {}
  end,
}

add {
  'Joakker/lua-json5',
  optional = true,
  pin = true,
  build = shared.const.is_windows and 'powershell ./install.ps1' or './install.sh',
}

add {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  event = 'BufEnter',
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      'formatter.nvim',
      'lazy.nvim',
      'lua-json5',
      'lualine.nvim',
      'mason-lspconfig.nvim',
      'mason.nvim',
      'mini.surround',
      'nvim-dap',
      'nvim-dap-ui',
      'nvim-lspconfig',
      'nvim-nio',
      'nvim-treesitter',
      'nvim-treesitter-textobjects',
      'nvim-ts-autotag',
      'nvim-web-devicons',
      'oil.nvim',
      'plenary.nvim',
      'telescope.nvim',
      'snacks.nvim',
    },
  },
}

add {
  'jay-babu/mason-nvim-dap.nvim',
}

add {
  'folke/neoconf.nvim',
  lazy = false,
  enabled = false,
  cmd = 'Neoconf',
  opts = {
    plugins = {
      dap = {
        enabled = true,
      },
    },
  },
}

add {
  'rmagatti/auto-session',
  lazy = false,
  enabled = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  cmd = {
    'SessionSave',
    'SessionRestore',
    'SessionDelete',
    'SessionDisableAutoSave',
    'SessionToggleAutoSave',
    'SessionPurgeOrphaned',
    'SessionSearch',
    'Autosession',
  },
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { '<leader>ss', '<cmd>SessionSearch<cr>', desc = 'Session search' },
    { '<leader>sv', '<cmd>SessionSave<cr>', desc = 'Session quick save' },
    { '<leader>sn', ':SessionSave ', desc = 'Save session as...' },
    { '<leader>sa', ':SessionToggleAutoSave', desc = 'Toggle autosave' },
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
}

add {
  'catgoose/nvim-colorizer.lua',
  enabled = false,
  pin = true,
  ft = { 'css', 'scss', 'sass', 'less', 'html' },
  cmd = {
    'ColorizerAttachToBuffer',
    'ColorizerDetachFromBuffer',
    'ColorizerReloadAllBuffers',
    'ColorizerToggle',
  },
  opts = {
    filetypes = { 'css', 'scss', 'sass', 'less', 'html' },
    buftypes = { '' },
    lazy_load = true,
    user_default_options = {
      names = false,
      RGBA = false,
      rgb_fn = true,
      virtualtext_inline = false,
    },
  },
}

add {
  'm4xshen/autoclose.nvim',
  event = 'InsertEnter',
  cond = function()
    return shared.util.buf_is_normal()
  end,
  opts = {
    options = {
      disabled_filetypes = { 'text', 'markdown' },
    },
  },
}

add {
  'echasnovski/mini.diff',
  pin = true,
  event = 'VeryLazy',
  opts = {
    view = {
      style = 'number',
    },
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = '',

      -- Reset hunks inside a visual/operator region
      reset = '',

      -- Hunk range textobject to be used inside operator
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = '',

      -- Go to hunk range in corresponding direction
      goto_first = '',
      goto_prev = '',
      goto_next = '',
      goto_last = '',
    },
  },
  config = function(lazyspec)
    require('mini.diff').setup(lazyspec.opts)
    local hl_add = vim.api.nvim_get_hl(0, { name = 'GitSignsAdd' })
    local hl_delete = vim.api.nvim_get_hl(0, { name = 'GitSignsDelete' })
    local hl_change = vim.api.nvim_get_hl(0, { name = 'GitSignsChange' })
    vim.api.nvim_set_hl(0, 'MiniDiffOverAdd', {
      fg = hl_add.fg,
      bg = hl_add.bg,
    })
    vim.api.nvim_set_hl(0, 'MiniDiffOverDelete', {
      fg = hl_delete.fg,
      bg = hl_delete.bg,
    })
    vim.api.nvim_set_hl(0, 'MiniDiffOverAdd', {
      fg = hl_change.fg,
      bg = hl_change.bg,
    })
  end,
}

add {
  'zongben/capsoff.nvim',
  lazy = false,
  enabled = false,
  build = ':CapsLockOffBuild',
  config = function()
    require('capsoff').setup { auto = false }
    vim.api.nvim_create_autocmd('InsertLeave', {
      desc = 'Disable CAPSLOCK when leaving insert mode (Windows, linux/X11)',
      command = 'CapsLockOff',
      nested = true,
    })
  end,
}

local snacks_config = require 'config.snacks'
add {
  'folke/snacks.nvim',
  lazy = false,
  init = snacks_config.init,
  opts = snacks_config.opts,
  keys = snacks_config.keys,
}

add {
  'nacro90/numb.nvim',
  event = 'VeryLazy',
  opts = {
    show_number = true,
    show_cursorline = true,
    hide_relativenumber = true,
    number_only = true,
    centered_peeking = true,
  },
}

add {
  'shortcuts/no-neck-pain.nvim',
  lazy = false,
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
  config = function(lazyspec)
    local no_neck_pain = require 'no-neck-pain'

    no_neck_pain.setup(lazyspec.opts)

    Snacks.toggle({
      name = 'Centered buffer',
      get = function()
        return require('no-neck-pain').state.enabled
      end,
      set = function(state)
        (state and no_neck_pain.enable or no_neck_pain.disable)()
      end,
    }):map 'tC'
  end,
}

add {
  'Wansmer/treesj',
  events = 'VeryLazy',
  keys = { '<space>m', '<space>j', '<space>s' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = true,
}

add {
  'hiphish/rainbow-delimiters.nvim',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  init = function()
    vim.g.rainbow_delimiters = {
      condition = shared.util.buf_is_normal,
      highlight = { 'RainbowDelimiterBlue', 'RainbowDelimiterGreen' },
    }
  end,
}

add {
  'tmillr/sos.nvim',
  lazy = false,
  opts = {
    enabled = true,
    timeout = shared.const.second * 10,
    create_parent_dirs = true,
    autowrite = false,
    save_on_cmd = 'some',
    save_on_bufleave = false,
    save_on_focuslost = true,
    should_save = {
      unmodifiable = false,
      acwrite = {
        net = false,
        git = false,
        compress = false,
        other = false,
        schemes = {
          octo = false,
          term = false,
          file = true,
        },
      },
    },
  },
  config = function(lazyspec)
    local sos = require 'sos'
    sos.setup(lazyspec.opts)
    Snacks.toggle({
      name = '(buffer) Auto-write',
      get = function()
        return sos.buf_enabled(0)
      end,
      set = function(state)
        (state and sos.enable_buf or sos.disable_buf)(0)
      end,
    }):map 'tab'
    Snacks.toggle({
      name = '(global) Auto-write',
      get = function()
        return require('sos.config').opts.enabled
      end,
      set = function(state)
        vim.cmd(state and 'SosEnable' or 'SosDisable')
      end,
    }):map 'tag'
  end,
}

add {
  'zaldih/themery.nvim',
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
}

add {
  'Bekaboo/dropbar.nvim',
  event = { 'VeryLazy', 'LspAttach' },
  opts = {
    bar = {
      enable = function(bufnr, _, _)
        return shared.util.buf_is_normal(bufnr)
      end,
      update_debounce = 100,
      update_events = {
        global = { 'DirChanged', 'VimResized', 'FocusGained' },
      },
      hover = true,
    },
    menu = {
      quick_navigation = true, -- TODO is mouse pointer only?
      hover = true,
    },
    symbol = {
      on_click = function() end,
    },
    sources = {
      path = { max_depth = 8 },
      treesiter = { max_depth = 8 },
      lsp = { max_depth = 8 },
      markdown = { max_depth = 8 },
    },
  },
  keys = {
    {
      'gc;',
      function()
        require('dropbar.api').pick()
      end,
      desc = 'Pick symbols in winbar',
    },
    {
      'gc[',
      function()
        require('dropbar.api').goto_context_start()
      end,
      desc = 'Go to start of current context',
    },
    {
      'gc]',
      function()
        require('dropbar.api').select_next_context()
      end,
      desc = 'Select next context',
    },
  },
}

add {
  'aznhe21/actions-preview.nvim',
  event = { 'VeryLazy', 'LspAttach' },
  opts = {
    -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
    -- diff = {},
    backend = { 'snacks' },
    snacks = {
      layout = { preset = 'default' },
    },
  },
  keys = {
    {
      '<leader>ca',
      function()
        require('actions-preview').code_actions()
      end,
      desc = 'Display code actions with change preview',
      mode = { 'n', 'v' },
    },
  },
}

add {
  'Jxstxs/conceal.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
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

    local level = 1
    Snacks.toggle({
      name = 'Keyword conceal',
      get = function()
        return vim.wo.conceallevel == level
      end,
      set = function(state)
        vim.wo.conceallevel = state and level or nil
      end,
    }):map 'tc'
  end,
  keys = { 'tc' },
}

priority {
  'folke/snacks.nvim',
  'shortcuts/no-neck-pain.nvim',
  'rmagatti/auto-session',
  'folke/neoconf.nvim',
  'williamboman/mason.nvim',
  'nvim-lualine/lualine.nvim',
}

shared.plugins = P

-- TODO print file stat on notification (Snacks.notify)
-- TODO remove file size from lualine
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#keybinding
--   for input language support
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#debugging (nvim-dap extensions)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#utility (different utility functions)
-- TODO checkout and consider https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#media (media viewer in the terminal)
-- TODO checkout and consider https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#bars-and-lines (bars and lines customization)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#project (project management)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#search (search improvements)

return P
