local show_detailed = false

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
            show_detailed = not show_detailed
            oil.set_columns(show_detailed and { 'mtime', 'size', 'permissions' } or {})
          end,
        },
      },
    }

    -- notify lsp oil has modified a file
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilActionsPost',
      desc = 'Lets LSP clients know that a file has been renamed',
      callback = function(event)
        if event.data.actions.type == 'move' then
          Snacks.rename.on_rename_file(
            event.data.actions.src_url,
            event.data.actions.dest_url
          )
        end
      end,
    })
  end,
}

require('bootstrap').LazyNvim:SetPriority { spec }

return spec
