local lspconfig = {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local lspconfig = require "lspconfig"
    local mason = require "mason"
    local masonlsp = require "mason-lspconfig"
    local zero = require "lsp-zero"

    local lsp_attach = function(client, bufnr)
      -- disable language servers ability to create new highlights
      client.server_capabilities.semanticTokensProvider = nil

      zero.default_keymaps { buffer = bufnr, preserve_mappings = false }
    end

    mason.setup {}
    masonlsp.setup {
      opts = {
        ensure_installed = { "lua_ls", "tsserver", "ruff_lsp", "jsonls", "taplo", "yamlls" },
      },
    }


    zero.extend_lspconfig { sign_text = true, lsp_attach = lsp_attach }
  end,
}

local formatting = {
  "stevearc/conform.nvim",
  config = function ()
    local conform = require "conform"
    local prettier = { "prettierd", "prettier", stop_after_first = true }

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff" },
        javascript = prettier,
        typescript = prettier,
        json = prettier,
        html = prettier,
        css = prettier,
        scss = prettier,
        sass = prettier,
        less = prettier,
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    }
  end,
}

local completion = {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
}

local debugging = {
  "mfussenegger/nvim-dap",
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",
}

local hints = {
  "folke/trouble.nvim",
}

return vim.tbl_extend("keep", { lspconfig, formatting }, completion, debugging, hints)

