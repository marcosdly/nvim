local set = vim.keymap.set
local LazyNvim = require('bootstrap').LazyNvim
local const = require 'lib.helpful_constants'
local util = require 'lib.util'

local plugins = {
  {
    'neovim/nvim-lspconfig',
    config = function()
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

      set(
        'n',
        '<leader>la',
        vim.lsp.buf.code_action,
        { desc = 'LSP: List code actions' }
      )
      set('n', '<leader>lc', '<cmd>Telescope lsp_incoming_calls<cr>', {
        desc = 'LSP: List incoming calls',
      })
      set('n', '<leader>lC', '<cmd>Telescope lsp_outgoing_calls<cr>', {
        desc = 'LSP: List outgoing calls',
      })
      set(
        'n',
        '<leader>ls',
        vim.lsp.buf.signature_help,
        { desc = 'LSP: Signature help' }
      )
      set(
        'n',
        '<leader>ar',
        -- NOTE renaming accross workspace is dependent on LSP (implementation), some
        -- may support it, some may do it by default
        vim.lsp.buf.rename,
        { desc = 'LSP: Rename symbol' }
      )
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      PATH = 'prepend',
      pip = {
        upgrade_pip = true,
      },
      ui = {
        border = 'rounded',
        backdrop = 0,
      },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
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
  },
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      local action_preview = require 'actions-preview'

      action_preview.setup {
        -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
        -- diff = {},
        backend = { 'snacks' },
        snacks = {
          layout = { preset = 'default' },
        },
      }

      set({ 'n', 'v' }, '<leader>aa', action_preview.code_actions, {
        desc = 'Action: List and preview actions',
      })
    end,
  },
  {
    'catgoose/nvim-colorizer.lua',
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
  },
  {
    'Bekaboo/dropbar.nvim',
    config = function()
      local api = require 'dropbar.api'
      local dropbar = require 'dropbar'

      dropbar.setup {
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
      }

      set('n', '<leader>lbs', api.pick, {
        desc = 'Breadcrumbs: Pick symbols',
      })
      set('n', '<leader>lb[', function()
        api.goto_context_start(1)
      end, {
        desc = 'Breadcrumbs: Go to previous context',
      })
      set('n', '<leader>lb]', api.select_next_context, {
        desc = 'Breadcrumbs: Select next context',
      })
    end,
  },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        'lazy.nvim',
        'lua-json5',
        'lualine.nvim',
        'mason-lspconfig.nvim',
        'mason.nvim',
        'nvim-lspconfig',
        'nvim-nio',
        'plenary.nvim',
        'telescope.nvim',
        'snacks.nvim',
      },
    },
  },
}

LazyNvim:SetPriority(plugins, {
  'williamboman/mason-lspconfig.nvim',
  'Bekaboo/dropbar.nvim',
  'aznhe21/actions-preview.nvim',
  'folke/lazydev.nvim',
  'catgoose/nvim-colorizer.lua',
})

return plugins
