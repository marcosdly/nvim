local spec = {
  "mhartington/formatter.nvim",
  config = function()
    local formatter = require("formatter")
    local ft = require("formatter.filetypes")

    formatter.setup({
      logging = false,
      log_level = vim.log.levels.WARN,
      filetype = {
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
      },
    })

    local set = vim.keymap.set

    set("n", "<leader>af", "<cmd>FormatLock<cr>", { desc = "Action: Format buffer" })
  end,
}

require('bootstrap').LazyNvim:SetPriority({spec})

return spec
