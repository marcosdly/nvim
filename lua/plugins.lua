-- TODO config https://old.reddit.com/r/neovim/comments/16xz3q9/treesitter_highlighted_folds_are_now_in_neovim/
local P = {}

local function add(tab)
  tab.priority = nil
  table.insert(P, tab)
end

local function priority(id_list)
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
  lazy = false,
  cond = util.is_gui,
  pin = true,
  config = true,
}

add {
  'nvim-telescope/telescope.nvim',
  cond = util.is_gui,
  lazy = false,
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
    { '<leader>vo', '<cmd>Telescope vim_options<cr>', desc = 'Vim: Search options' },
    {
      '<leader>vs',
      '<cmd>Telescope spell_suggest<cr>',
      desc = 'Vim: List spelling suggestions',
    },
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
  cond = util.is_gui,
  lazy = false,
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
          config.lsp_status,
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
  cond = util.is_gui,
  lazy = false,
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
    state.oil = {
      view_detail = false,
    }

    local oil = require 'oil'

    local opts_override = {
      keymaps = {
        ['<c-c>'] = 'actions.close',
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = function()
            state.oil.view_detail = not state.oil.view_detail
            oil.set_columns(
              state.oil.view_detail and { 'mtime', 'size', 'permissions' } or {}
            )
          end,
        },
      },
    }

    oil.setup(vim.tbl_deep_extend('force', lazyspec.opts, opts_override))
  end,
  keys = {
    { '-', '<cmd>Oil --float<cr>', desc = 'Oil: Open parent dir' },
    { '<leader>-', '<cmd>Oil --float --trash<cr>', desc = 'Oil: Parent dir trash' },
    {
      '<localleader>-',
      '<cmd>Oil --float --trash /<cr>',
      desc = 'Oil: System wide trash',
    },
  },
}

add { 'wakatime/vim-wakatime', lazy = false }

add {
  'echasnovski/mini.surround',
  event = { 'CmdlineEnter', 'InsertEnter', 'BufReadPost', 'VeryLazy' },
  opts = {
    respect_selection_type = true,
  },
}

add {
  'mhartington/formatter.nvim',
  cmd = { 'Format', 'FormatLock', 'FormatWrite', 'FormatWriteLock' },
  opts = {
    logging = false,
    log_level = vim.log.levels.WARN,
  },
  keys = {
    { '<leader>af', '<cmd>FormatLock<cr>', desc = 'Action: Format buffer' },
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
  'nvim-treesitter/nvim-treesitter-textobjects',
  keys = {
    -- Repeat movement with ; and ,
    -- vim way: ; goes to the direction you were moving.
    {
      ';',
      function()
        require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Treesitter: textobjects repeat',
    },
    {
      ',',
      function()
        require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_opposite()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Treesitter: textobjects repeat opposite direction',
    },
  },
}

add {
  'windwp/nvim-ts-autotag',
  ft = { 'html', 'xml', 'javascriptreact', 'typescriptreact' },
  opts = {
    opts = {
      enable_close_on_slash = true, -- Auto close on trailing </
    },
  },
  -- LSP may break because was formatted in insert mode
  -- SEE https://github.com/windwp/nvim-ts-autotag/issues/19
}

add {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
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
        local max_filesize = const.storage_size.kilobyte * 100
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

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}

add {
  'gerazov/toggle-bool.nvim',
  cond = false,
  pin = true,
  opts = {
    mapping = '<leader>ab',
    additional_toggles = {
      ['0'] = '1',
    },
  },
}

local lspconfig_config = require 'config.lspconfig'
add {
  'neovim/nvim-lspconfig',
  event = 'LspAttach',
  keys = lspconfig_config.keys,
  config = function()
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
          [vim.diagnostic.severity.ERROR] = const.icons.diagnostic.error,
          [vim.diagnostic.severity.WARN] = const.icons.diagnostic.warn,
          [vim.diagnostic.severity.INFO] = const.icons.diagnostic.info,
          [vim.diagnostic.severity.HINT] = const.icons.diagnostic.hint,
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
  dependencies = 'williamboman/mason-lspconfig.nvim',
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

    require('mason').setup(mason_opts)
    require('mason-lspconfig').setup(mason_lspconfig_opts)
  end,
}

local dap_config = require 'config.dap'
add {
  'mfussenegger/nvim-dap',
  dependencies = {
    'jay-babu/mason-nvim-dap.nvim',
    { 'rcarriga/nvim-dap-ui', cond = util.is_gui },
    { 'nvim-neotest/nvim-nio', cond = util.is_gui },
    'Joakker/lua-json5',
  },
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

    local mason_dap_opts = {
      ensure_installed = { 'python' },
      automatic_installation = true,
      handlers = {}, -- sets up dap in the predefined manner
    }

    -- Config
    dap_vscode.json_decode = require('json5').parse
    dap.configurations = dap_config.configurations
    dapui.setup {}
    require('mason-nvim-dap').setup(mason_dap_opts)
  end,
}

add {
  'Joakker/lua-json5',
  optional = true,
  pin = true,
  build = IS_WINDOWS and 'powershell ./install.ps1' or './install.sh',
}

add {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load on lua files
  cond = function()
    return vim.fs.relpath(vim.fn.stdpath 'config', vim.fs.abspath '.') ~= nil
  end,
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
  'folke/neoconf.nvim',
  lazy = false,
  cond = false,
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
  cond = false,
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
}

add {
  'catgoose/nvim-colorizer.lua',
  cond = util.is_gui,
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
  event = { 'CmdlineEnter', 'InsertEnter', 'BufReadPost', 'VeryLazy' },
  opts = {
    options = {
      disabled_filetypes = { 'text', 'markdown' },
    },
  },
}

add {
  'echasnovski/mini.diff',
  cond = util.is_gui,
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
  cond = IS_WINDOWS,
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
  event = 'CmdlineEnter',
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
  -- cond = util.is_gui,
  lazy = false,
  cond = false,
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
  cond = false,
  keys = { '<space>m', '<space>j', '<space>s' },
  config = true,
}

add {
  'hiphish/rainbow-delimiters.nvim',
  event = { 'BufReadPost', 'VeryLazy' },
  cond = util.is_gui,
  init = function()
    vim.g.rainbow_delimiters = {
      condition = util.buf_is_normal,
      highlight = { 'RainbowDelimiterBlue', 'RainbowDelimiterGreen' },
    }
  end,
}

add {
  'tmillr/sos.nvim',
  event = 'VeryLazy',
  -- cond = function()
  --   return vim.bo[0].buftype == ''
  --     and vim.bo[0].filetype ~= ''
  --     and vim.bo[0].modifiable
  --     and not vim.bo[0].readonly
  --     and vim.uv.fs_stat(vim.api.nvim_buf_get_name(0) or '')
  -- end,
  opts = {
    enabled = true,
    timeout = const.time_delay.second * 10,
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
  cond = util.is_gui,
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
  cond = util.is_gui,
  event = 'LspAttach',
  opts = {
    bar = {
      enable = function(bufnr, _, _)
        return util.buf_is_normal(bufnr)
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
      '<leader>lbs',
      function()
        require('dropbar.api').pick()
      end,
      desc = 'Breadcrumbs: Pick symbols',
    },
    {
      '<leader>lb[',
      function()
        require('dropbar.api').goto_context_start(1)
      end,
      desc = 'Breadcrumbs: Go to previous context',
    },
    {
      '<leader>lb]',
      function()
        require('dropbar.api').select_next_context()
      end,
      desc = 'Breadcrumbs: Select next context',
    },
  },
}

add {
  'aznhe21/actions-preview.nvim',
  cond = util.is_gui,
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
      '<leader>aa',
      function()
        require('actions-preview').code_actions()
      end,
      desc = 'Action: List and preview actions',
      mode = { 'n', 'v' },
    },
  },
}

add {
  'Jxstxs/conceal.nvim',
  cond = util.is_gui,
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

    Snacks.toggle({
      name = 'Treesitter conceal',
      get = function()
        return vim.wo.conceallevel == 1
      end,
      set = function(level)
        vim.wo.conceallevel = level == 1 and 0 or 1
      end,
    }):map '<leader>tc'
  end,
  keys = { '<leader>tc' },
}

priority {
  -- essential
  'folke/snacks.nvim', -- first for quickfile
  'nvim-treesitter/nvim-treesitter',
  'wakatime/vim-wakatime', -- ensure effort is being recorded

  -- dev icons (may be important, or maybe not at all)
  'nvim-tree/nvim-web-devicons',

  -- main editor utility
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim', -- may be started by snacks
  'stevearc/oil.nvim',

  -- other
  'folke/neoconf.nvim',
  'rmagatti/auto-session',
  'williamboman/mason.nvim',
}

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
