local LazyNvim = require('bootstrap').LazyNvim

local plugins = {
  {
    "hiphish/rainbow-delimiters.nvim",
    init = function()
      vim.g.rainbow_delimiters = {
        highlight = { "RainbowDelimiterBlue", "RainbowDelimiterGreen" },
      }
    end,
  },
  {
    "m4xshen/autoclose.nvim",
    opts = {
      options = {
        disabled_filetypes = { "text", "markdown" },
      },
    },
  },
  {
    "gerazov/toggle-bool.nvim",
    pin = true,
    opts = {
      mapping = "<leader>ab",
      additional_toggles = {
        ["0"] = "1",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    opts = {
      respect_selection_type = true,
    },
  },
  {
    "echasnovski/mini.diff",
    pin = true,
    opts = {
      view = {
        style = "number",
      },
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Apply hunks inside a visual/operator region
        apply = "",

        -- Reset hunks inside a visual/operator region
        reset = "",

        -- Hunk range textobject to be used inside operator
        -- Works also in Visual mode if mapping differs from apply and reset
        textobject = "",

        -- Go to hunk range in corresponding direction
        goto_first = "",
        goto_prev = "",
        goto_next = "",
        goto_last = "",
      },
    },
    config = function(lazyspec)
      require("mini.diff").setup(lazyspec.opts)
      local hl_add = vim.api.nvim_get_hl(0, { name = "GitSignsAdd" })
      local hl_delete = vim.api.nvim_get_hl(0, { name = "GitSignsDelete" })
      local hl_change = vim.api.nvim_get_hl(0, { name = "GitSignsChange" })
      vim.api.nvim_set_hl(0, "MiniDiffOverAdd", {
        fg = hl_add.fg,
        bg = hl_add.bg,
      })
      vim.api.nvim_set_hl(0, "MiniDiffOverDelete", {
        fg = hl_delete.fg,
        bg = hl_delete.bg,
      })
      vim.api.nvim_set_hl(0, "MiniDiffOverAdd", {
        fg = hl_change.fg,
        bg = hl_change.bg,
      })
    end,
  },
}

LazyNvim:SetPriority(plugins, {
  "echasnovski/mini.surround",
  "m4xshen/autoclose.nvim",
  "hiphish/rainbow-delimiters.nvim",
  "echasnovski/mini.diff",
  "gerazov/toggle-bool.nvim",
})

return plugins
