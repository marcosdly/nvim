state.oil = {
  view_detail = false,
}

local spec = {
  'stevearc/oil.nvim',
  config = function()
    local oil = require 'oil'

    oil.setup {
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

    local set = vim.keymap.set

    set('n', '-', '<cmd>Oil --float<cr>', { desc = 'Oil: Open parent dir' })
    set(
      'n',
      '<leader>-',
      '<cmd>Oil --float --trash<cr>',
      { desc = 'Oil: Parent dir trash' }
    )
    set(
      'n',
      '<localleader>-',
      '<cmd>Oil --float --trash /<cr>',
      { desc = 'Oil: System wide trash' }
    )
  end,
}

require('bootstrap').LazyNvim:SetPriority { spec }

return spec
