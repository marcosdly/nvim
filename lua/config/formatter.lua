local M = {}

function M.get_defined_formatters()
  local ft = require 'formatter.filetypes'

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
    jsonc = {
      ft.json.prettierd,
    },
    json5 = {
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
    },
  }

  return formatters
end

return M
