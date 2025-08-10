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
    tag = 'v1.32.0',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    },
    config = function()
      local function check_function(bufnr, _)
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        for _, name in ipairs(clients) do
          local conditions = LSP:GetAttachConditions(name)
          for _, should_attach in ipairs(conditions) do
            if not should_attach() then return false end
          end
        end
        return true
      end

      vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = check_function,
          signs = check_function,
          update_in_insert = check_function,
          virtual_text = check_function,
        })

      local opts = {
        automatic_installation = false,
        ensure_installed = { 'lua_ls', 'jsonls' },
        automatic_enable = {
          exclude = { 'luau_lsp' },
        },
        handlers = {
          luau_lsp = function(_) end,
          -- default
          function(server_name)
            local lspconfig = require 'lspconfig'
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

            lspconfig[server_name].setup {
              capabilities = capabilities,
              on_attach = function(bufnr) end,
            }
          end,
        },
      }

      require('mason-lspconfig').setup(opts)
    end,
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
  {
    'lopi-py/luau-lsp.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      _G.luau = {
        is_rojo_project = function()
          return vim.fs.root(0, function(name)
            return name:match '.+%.project%.json$'
          end)
        end,
        lsp = require 'luau-lsp',
      }

      luau.lsp.setup {
        fflags = {
          enable_by_default = true,
          -- enables the fflags required for luau's new type solver
          enable_new_solver = true,
          -- sync currently enabled fflags with roblox's published fflags
          sync = true,
        },
      }
    end,
  },
}

LazyNvim:SetPriority(plugins, {
  'williamboman/mason-lspconfig.nvim',
  'lopi-py/luau-lsp.nvim',
  'Bekaboo/dropbar.nvim',
  'aznhe21/actions-preview.nvim',
  'folke/lazydev.nvim',
  'catgoose/nvim-colorizer.lua',
})

return plugins
