local plugin_id = {
  plenary = 'nvim-lua/plenary.nvim',
  telescope = 'nvim-telescope/telescope.nvim',
  telescope_fzf = 'nvim-telescope/telescope-fzf-native.nvim',
  web_devicons = 'nvim-tree/nvim-web-devicons',
  lazygit = 'kdheepak/lazygit.nvim',
  lualine = 'nvim-lualine/lualine.nvim',
  oil = 'stevearc/oil.nvim',
  wakatime = 'wakatime/vim-wakatime',
  surround = 'echasnovski/mini.surround',
  formatter = 'mhartington/formatter.nvim',
  treesitter = 'nvim-treesitter/nvim-treesitter',
  treesitter_textobjects = 'nvim-treesitter/nvim-treesitter-textobjects',
  treesitter_autotag = 'windwp/nvim-ts-autotag',
  toggle_bool = 'gerazov/toggle-bool.nvim',
  lspconfig = 'neovim/nvim-lspconfig',
  mason_lspconfig = 'williamboman/mason-lspconfig.nvim',
  mason = 'williamboman/mason.nvim',
  dap = 'mfussenegger/nvim-dap',
  dapui = 'rcarriga/nvim-dap-ui',
  nvim_nio = 'nvim-neotest/nvim-nio',
  json5 = 'Joakker/lua-json5',
  lazydev = 'folke/lazydev.nvim',
  neoconf = 'folke/neoconf.nvim',
  auto_session = 'rmagatti/auto-session',
  mason_dap = 'jay-babu/mason-nvim-dap.nvim',
  colorizer = 'catgoose/nvim-colorizer.lua',
  autoclose = 'm4xshen/autoclose.nvim',
  git_diff = 'echasnovski/mini.diff',
  capsoff = 'zongben/capsoff.nvim',
  snacks = 'folke/snacks.nvim',
}

local config = setmetatable({}, {
  __index = function(_, key)
    return require('config.' .. key)
  end,
})

local tool = {}

function tool.not_lazy(list)
  for _, lazyspec in ipairs(list) do
    lazyspec.lazy = false
  end
end

function tool.set_priority(priority_table)
  for lazyspec, priority_int in pairs(priority_table) do
    lazyspec.priority = priority_int
  end
end

function tool.disable(disable_list)
  for _, lazyspec in ipairs(disable_list) do
    lazyspec.enabled = false
  end
end

local P = {}

P.web_devicons = {
  plugin_id.web_devicons,
  cmd = { 'NvimWebDeviconsHiTest' },
  event = 'VeryLazy',
  pin = true,
  config = true,
}

P.telescope_fzf = {
  plugin_id.telescope_fzf,
  -- cmake is the starndard way of building; may be broken on windows
  -- SEE https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/122
  build = vim.fn.join {
    'mkdir build',
    '&&',
    'zig cc -O3 -Wall -Werror -fpic -std=gnu99 -shared src/fzf.c -o build/libfzf.dll',
  },
}

P.telescope = {
  plugin_id.telescope,
  tag = '0.1.8',
  dependencies = {
    plugin_id.plenary,
    plugin_id.lazygit,
    plugin_id.web_devicons,
    plugin_id.telescope_fzf,
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
    telescope.load_extension 'lazygit'
  end,
  cmd = 'Telescope',
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
    { '<leader>fgl', '<cmd>Telescope lazygit<cr>' },
    -- vim
    { '<leader>fvh', '<cmd>Telescope help_tags<cr>' },
    { '<leader>fvo', '<cmd>Telescope vim_options<cr>' },
    { '<leader>fvs', '<cmd>Telescope search_history<cr>' },
    { '<leader>fvr', '<cmd>Telescope registers<cr>' },
    { '<leader>fvk', '<cmd>Telescope keymaps<cr>' },
    { '<leader>fvc', '<cmd>Telescope command_history<cr>' },
    { '<leader>fvl', '<cmd>Telescope spell_suggest<cr>' },
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

P.lualine = {
  plugin_id.lualine,
  dependencies = {
    P.web_devicons,
  },
  opts = {
    options = {
      theme = 'auto',
      icons_enabled = true,
      globalstatus = true,
      always_divide_middle = true,
    },
  },
  sections = {
    lualine_a = {
      config.lualine.mode,
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
      config.lualine.buffer_count,
      {
        'filename',
        path = 1, -- relative path
      },
      config.lualine.filesize,
    },
    lualine_x = {
      config.lualine.diagnostics,
      config.lualine.session_status,
      config.lualine.keymap,
    },
    lualine_y = {
      config.lualine.selection_count,
    },
    lualine_z = {
      config.lualine.location,
    },
  },
}

P.oil = {
  plugin_id.oil,
  dependencies = {
    P.web_devicons,
  },
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
    _G.oil_state = { view_detail = false }

    local function oil_toggle_details()
      local oil = require 'oil'
      oil_state.view_detail = not oil_state.view_detail
      if oil_state.view_detail then
        oil.set_columns { 'mtime', 'size', 'permissions' }
      else
        oil.set_columns {}
      end
    end

    local opts_override = {
      keymaps = {
        ['<c-c>'] = 'actions.close',
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = oil_toggle_details,
        },
      },
    }

    require('oil').setup(vim.tbl_deep_extend('force', lazyspec.opts, opts_override))
  end,
  keys = {
    { '-', '<cmd>Oil --float<cr>' }, -- open parent
    { '<leader>-', '<cmd>Oil --float --trash<cr>' }, -- parent's trash
    { '<localleader>-', '<cmd>Oil --float --trash /<cr>' }, -- all trash
  },
}

P.wakatime = {
  plugin_id.wakatime,
}

P.surround = {
  plugin_id.surround,
  event = 'BufEnter',
  opts = {
    respect_selection_type = true,
  },
}

P.formatter = {
  plugin_id.formatter,
  event = 'LspAttach',
  cmd = config.formatter.lazyspec.cmd,
  opts = config.formatter.lazyspec.opts,
  keys = config.formatter.lazyspec.keys,
  config = function(lazyspec)
    local formatter = require 'formatter'

    formatter.setup(vim.tbl_deep_extend('force', lazyspec.opts, {
      filetype = config.formatter.get_defined_formatters(),
    }))
  end,
}

P.treesitter_autotag = {
  plugin_id.treesitter_autotag,
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

P.treeshitter = {
  plugin_id.treesitter,
  dependencies = {
    plugin_id.treesitter_textobjects,
    plugin_id.treesitter_autotag,
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
        local max_filesize = 100 * 1024 -- 100 KB
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

P.toggle_bool = {
  plugin_id.toggle_bool,
  pin = true,
  event = 'LspAttach',
  opts = {
    mapping = '<leader>ab',
    additional_toggles = {
      ['0'] = '1',
    },
  },
}

P.lspconfig = {
  plugin_id.lspconfig,
  init = function()
    local set = vim.keymap.set
    set('n', '<leader>la', vim.lsp.buf.code_action)
    set('n', '<leader>ld', vim.lsp.buf.definition)
    set('n', '<leader>fd', '<cmd>Telescope lsp_definitions<cr>')
    set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>')
    set('n', '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<cr>')
    set('n', '<leader>li', vim.lsp.buf.implementation)
    set('n', '<leader>fi', '<cmd>Telesope lsp_implementations<cr>')
    -- f as in 'find'; j (down) as in here, myself, where I stand
    set('n', '<leader>fj', '<cmd>Telescope lsp_incoming_calls<cr>')
    -- f as in 'find'; k (up) as in there, somewhere, out
    set('n', '<leader>fj', '<cmd>Telescope lsp_outgoing_calls<cr>')
    -- f as in 'find'; m as in 'more'
    set('n', '<leader>fm', '<cmd>Telescope lsp_references<cr>')
    set('n', '<leader>lr', vim.lsp.buf.rename)
    -- NOTE renaming accross workspace is dependent on LSP (implementation), some
    -- may support it, some may do it by default
    set('n', '<leader>ls', vim.lsp.buf.signature_help)
    set('n', '<leader>lt', vim.lsp.buf.type_definition)
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

P.mason = {
  plugin_id.mason,
  dependencies = {
    plugin_id.mason_lspconfig,
    plugin_id.mason_dap,
    plugin_id.lspconfig,
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

P.masonlspconfig = {
  plugin_id.mason_lspconfig,
}

P.lazygit = {
  plugin_id.lazygit,
  dependencies = {
    plugin_id.plenary,
  },
  init = function()
    vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
    vim.g.lazygit_floating_window_scaling_factor = 0.8
    vim.g.lazygit_floating_window_border_chars =
      { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
    vim.g.lazygit_floating_window_use_plenary = shared.const.FALSE
    vim.g.lazygit_use_neovim_remote = shared.const.TRUE
    vim.g.lazygit_use_custom_config_file_path = shared.const.FALSE
  end,
  keys = {
    -- status
    { '<leader>lgs', '<cmd>LazyGit<cr>' },
    -- current
    { '<leader>lgc', '<cmd>LazyGitCurrentFile<cr>' },
  },
}

P.dap = {
  plugin_id.dap,
  dependencies = {
    plugin_id.dapui,
    plugin_id.nvim_nio,
    plugin_id.json5,
  },
  cond = function()
    return shared.util.buf_is_normal()
  end,
  keys = config.dap.lazyspec.keys,
  cmd = config.dap.lazyspec.cmd,
  config = config.dap.lazyspec.config,
}

P.json5 = {
  plugin_id.json5,
  optional = true,
  pin = true,
  build = shared.const.is_windows and 'powershell ./install.ps1' or './install.sh',
}

P.lazydev = {
  plugin_id.lazydev,
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
    },
  },
}

P.mason_dap = {
  plugin_id.mason_dap,
}

P.neoconf = {
  plugin_id.neoconf,
  cmd = 'Neoconf',
  opts = {
    plugins = {
      dap = {
        enabled = true,
      },
    },
  },
}

P.auto_session = {
  plugin_id.auto_session,
  dependencies = {
    plugin_id.telescope,
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

P.colorizer = {
  plugin_id.colorizer,
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

P.autoclose = {
  plugin_id.autoclose,
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

P.git_diff = {
  plugin_id.git_diff,
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

P.capsoff = {
  plugin_id.capsoff,
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

P.snacks = {
  plugin_id.snacks,
  init = config.snacks.init,
  opts = config.snacks.opts,
  keys = config.snacks.keys,
}

tool.not_lazy {
  P.telescope,
  P.lualine,
  P.oil,
  P.wakatime,
  P.treeshitter,
  P.lazygit,
  P.neoconf,
  P.auto_session,
  P.mason,
  P.capsoff,
  P.snacks,
}

tool.set_priority {
  [P.snacks] = 2000,
  [P.auto_session] = 2000,
  [P.neoconf] = 1000,
  -- [P.lspconfig] = 999,
  [P.mason] = 990,
  [P.lualine] = 960,
}

tool.disable {
  P.auto_session,
  P.toggle_bool,
  P.colorizer,
  P.neoconf,
  P.capsoff,
}

local plugins = {
  id = plugin_id,
  as_dictionary = P,
  as_list = vim.tbl_values(P),
}

plugins.by_id = vim.iter(plugins.as_list):fold({}, function(acc, lazyspec)
  acc[lazyspec[1]] = lazyspec
  return acc
end)

shared.plugins = plugins

-- TODO mini.move
-- TODO multi cursor
-- TODO add treesitter fold code block
-- TODO patch 'marcosdly/minimal' colorscheme
-- TODO see file info in telescope (enter will copy to yank register)
-- TODO show file size on lualine only for sometime after writing
-- TODO add plugin https://github.com/m4xshen/hardtime.nvim to enforce good practices
-- TODO add plugin for aligning
-- TODO add remote development
-- TODO color current scope's bracket
-- TODO add zenmode custom config
-- TODO consider https://github.com/tmillr/sos.nvim (auto saving buffer)
-- TODO consider https://github.com/Jxstxs/conceal.nvim (minimize visual clutter)
-- TODO add snippets
-- TODO consider split/join of code structures (similar to command capital J)
-- TODO add treesitter context display (context of breadcrumbs)
-- TODO add https://github.com/kiyoon/telescope-insert-path.nvim (insert filepath using telescope)
-- TODO add https://github.com/zhisme/copy_with_context.nvim (copy line number with metadata)
-- TODO add https://github.com/shortcuts/no-neck-pain.nvim (center single buffer on screen)
-- TODO add textobject base surrounding
-- TODO consider https://github.com/nacro90/numb.nvim (peeking line by typing :{number})
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#keybinding
--   for input language support
-- TODO consider https://github.com/YaroSpace/lua-console.nvim (lua scratchpad/REPL)
-- TODO consider general srcratchpad plugin (taking notes)
-- TODO add test runner
-- TODO add subterminal
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#debugging (nvim-dap extensions)
-- TODO consider this or similars https://github.com/samharju/yeet.nvim (run shell commands in buffers)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#utility (different utility functions)
-- TODO checkout and consider https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#media (media viewer in the terminal)
-- TODO checkout and consider https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#bars-and-lines (bars and lines customization)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#project (project management)
-- TODO checkout https://github.com/rockerBOO/awesome-neovim?tab=readme-ov-file#search (search improvements)
-- TODO add conditional completion
-- TODO add code actinos support
-- TODO consider language specific plugins for better feature support *without compromizing general experience*

return plugins.as_list
