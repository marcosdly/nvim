local M = {}

M.lazyspec = {}

M.lazyspec.opts = {
  logging = false,
  log_level = vim.log.levels.WARN,
}

M.lazyspec.cmd = { 'Format', 'FormatLock', 'FormatWrite', 'FormatWriteLock' }

M.lazyspec.keys = {
  { 'cf', '<cmd>FormatLock<cr>' },
  { 'cF', '<cmd>FormatWriteLock<cr>' },
}

M._cached_formatter_config = nil

function M.get_defined_formatters()
  local ft = require 'formatter.filetypes'

  if M._cached_formatter_config ~= nil then return M._cached_formatter_config end

  local formatters = {
    python = {
      ft.python.ruff,
      ft.python.iruff, -- fix imports
    },
    lua = {
      ft.lua.stylua,
    },
    javascript = {
      ft.javascript.prettierd,
    },
    typescript = {
      ft.typescript.prettierd,
    },
    javascriptreact = {
      ft.javascriptreact.prettierd,
    },
    typescriptreact = {
      ft.typescriptreact.prettierd,
    },
    css = {
      ft.css.prettierd,
    },
    html = {
      ft.html.prettierd,
    },
    json = {
      ft.json.prettierd,
    },
    markdown = {
      ft.markdown.prettierd,
    },
    yaml = {
      ft.yaml.prettierd,
    },
    toml = {
      ft.toml.taplo,
    },
    sh = {
      ft.sh.shfmt,
    },
    xhtml = {
      ft.xhtml.tidy,
    },
    xml = {
      ft.xml.tidy,
    }
  }

  M._cached_formatter_config = formatters
  return formatters
end

return M
