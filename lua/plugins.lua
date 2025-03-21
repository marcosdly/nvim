function _G.pure_math_int_string_length(n)
  -- pure math string length of integer, which seems faster
  -- source: voices in my head
  -- SEE https://stackoverflow.com/a/10952773
  return math.ceil(math.log10(n + 1))
end

local telescope = {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
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
  config = function(opts)
    require('telescope').load_extension 'fzf'
  end,
  cmd = 'Telescope',
  lazy = false,
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

local lualine = {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = {
    options = {
      theme = 'auto',
      icons_enabled = false,
      globalstatus = true,
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 3)
          end,
        },
      },
      lualine_b = {
        'branch',
        {
          'diff',
          colored = false,
          fmt = function(str)
            return str:gsub('%s+', '')
          end,
        },
      },
      lualine_c = {
        -- buffer count
        function()
          local count = vim.tbl_count(vim
            .iter(vim.api.nvim_list_bufs())
            :filter(vim.api.nvim_buf_is_loaded)
            :filter(function(bufnr) -- is normal text buffer
              return vim.api.nvim_buf_get_option(bufnr, 'buftype') == ''
            end)
            :totable())
          if count == 1 then return '' end
          local current = vim.api.nvim_buf_get_number(0)
          return vim.fn.printf(
            '%*d/%d',
            pure_math_int_string_length(count),
            current,
            count
          )
        end,
        {
          'filename',
          path = 1, -- relative path
        },
        -- file size
        function()
          local file = vim.fn.expand '%:p'
          if file == nil or #file == 0 then return '' end
          local size = vim.fn.getfsize(file)
          local min_size = 10 * 1024 -- 10kb
          if size <= 0 or size < min_size then return '' end

          local suffixes = { 'B', 'KiB', 'MiB', 'GiB' }
          local i = 1
          while size > 1024 and i < #suffixes do
            size = size / 1024
            i = i + 1
          end

          local format = i == 1 and '%d%s' or '%.2f%s'
          return string.format(format, size, suffixes[i])
        end,
      },
      lualine_x = {
        { 'diagnostics', colored = false, update_in_insert = true },
      },
      lualine_y = {
        -- selection count
        -- SEE https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/selectioncount.lua
        function()
          local mode = vim.fn.mode(true)
          local line_start, line_end = vim.fn.line 'v', vim.fn.line '.'
          local col_start, col_end = vim.fn.col 'v', vim.fn.col '.'
          if not (mode == '' or mode:match '[vV]') then return '' end
          if line_start == line_end and col_start ~= col_end then -- character selection
            return vim.fn.printf(
              '%d:%d-%d (%dc)',
              line_start,
              col_start,
              col_end,
              math.abs(col_end - col_start) + 1
            )
          end
          if line_start ~= line_end and col_start == col_end then -- line selection
            return vim.fn.printf(
              '%d-%d (%dL)',
              line_start,
              line_end,
              math.abs(line_end - line_start) + 1
            )
          end
          if line_start ~= line_end and col_start ~= col_end then -- block selection
            return vim.fn.printf(
              '%d:%dx%d:%d (%dL%dc)',
              line_start,
              col_start,
              line_end,
              col_end,
              math.abs(col_end - col_start) + 1,
              math.abs(line_end - line_start) + 1
            )
          end
          return ''
        end,
      },
      lualine_z = {
        -- location
        function()
          local cursor_tup = vim.api.nvim_win_get_cursor(0)
          local row, column = cursor_tup[1] or 0, cursor_tup[2] or 0
          local count = vim.api.nvim_buf_line_count(0) or 0
          local row_padding = pure_math_int_string_length(count)

          local percentage = 0
          if row > 0 and count > 0 then percentage = row / count * 100 end

          local position
          if row == 1 then
            position = 'Top'
          elseif row == count then
            position = 'Bot'
          else
            position = tostring(row)
          end

          local percentage_str = vim.fn.printf(' %5.1f%%%%', percentage)
          local line_str = vim.fn.printf('%*s/%d', row_padding, position, count)
          local col_str = vim.fn.printf(':%2d', column)
          if position == 'Top' or position == 'Bot' then
            -- fill with whitespace if it's all zeroes
            -- lualine requires double the % characters to print them literally,
            -- so subtract `count('%')/2` from length
            percentage_str = string.rep(' ', percentage_str:len() - 1)
            if column == 0 then col_str = string.rep(' ', col_str:len()) end
          end
          return line_str .. col_str .. percentage_str
        end,
      },
    },
  },
}

local oil = {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    default_file_explorer = true,
    buf_options = {
      autowrite = false,
      autowriteall = false,
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
      show_hidden = true,
    },
    float = {
      max_height = 0.8,
      max_width = 88,
      preview_split = 'right',
    },
  },
  config = function(opts)
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
        ['gd'] = {
          desc = 'Toggle file detail view',
          callback = oil_toggle_details,
        },
      },
    }

    require('oil').setup(vim.tbl_deep_extend('force', opts, opts_override))
  end,
  keys = {
    { '-', '<cmd>Oil --float<cr>' }, -- open parent
    { '<leader>-', '<cmd>Oil --float --trash<cr>' }, -- parent's trash
    { '<localleader>-', '<cmd>Oil --float --trash /<cr>' }, -- all trash
  },
}

local wakatime = {
  'wakatime/vim-wakatime',
  lazy = false,
}

local surround = {
  'echasnovski/mini.surround',
  event = 'BufEnter',
  opts = {
    respect_selection_type = true,
  },
}

local formatter = {
  'mhartington/formatter.nvim',
  event = 'LspAttach',
  cmd = { 'Format', 'FormatLock', 'FormatWrite', 'FormatWriteLock' },
  opts = {
    logging = false,
    log_level = vim.log.levels.WARN,
  },
  config = function(opts)
    local formatter = require 'formatter'
    local filetypes = require 'formatter.filetypes'

    local opts_override = {
      filetype = {
        -- ['*'] = {
        --   filetypes.any.substitute_trailing_whitespace
        -- },
        lua = {
          filetypes.lua.stylua,
        },
      },
    }

    formatter.setup(vim.tbl_deep_extend('force', opts, opts_override))
  end,
  keys = {
    { '<leader>f', '<cmd>FormatLock<cr>' },
    { '<leader>F', '<cmd>FormatWriteLock<cr>' },
  },
}

local treeshitter = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
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
        if ok and stats and stats.size > max_filesize then return true end
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
  config = function(opts)
    local treesitter_configs = require 'nvim-treesitter.configs'
    local treesitter_install = require 'nvim-treesitter.install'
    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    treesitter_install.prefer_git = true

    treesitter_configs.setup(opts)

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

local lspconfig = {
  'neovim/nvim-lspconfig',
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
  end,
}

local masonlspconfig = {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  dependencies = {
    {
      'williamboman/mason.nvim',
      priority = 10,
      opts = {
        pip = {
          upgrade_pip = true,
        },
        ui = {
          border = 'rounded',
          backdrop = 0,
        },
      },
    },
  },
  opts = {
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
  },
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
  },
}

return {
  -- TODO mini.move
  telescope,
  lualine,
  oil,
  wakatime,
  surround,
  formatter,
  lspconfig,
  masonlspconfig,
  treeshitter,
  lazygit,
}
