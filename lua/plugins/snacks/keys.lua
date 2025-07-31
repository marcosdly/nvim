local set = vim.keymap.set

set('n', '<leader>\\', Snacks.picker.resume, {
  desc = 'Picker: Resume last window',
})

-- region Search
-- quick actions
set('n', '<leader>s.', Snacks.picker.smart, { desc = 'Picker: Smart find files' })
set('n', '<leader>s,', Snacks.picker.buffers, { desc = 'Picker: Buffers' })
set('n', '<leader>s/', Snacks.picker.grep, { desc = 'Picker: Grep cwd' })
set('n', '<leader>s;', Snacks.picker.grep_buffers, {
  desc = 'Picker: Grep buffers',
})
-- normal actions
set('n', '<leader>sc', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Picker: Config files' })
set('n', '<leader>sf', Snacks.picker.files, {
  desc = 'Picker: Files',
})
set('n', '<leader>sp', Snacks.picker.projects, { desc = 'Picker: Projects' })
set('n', '<leader>sr', Snacks.picker.recent, {
  desc = 'Picker: Recent',
})
set('n', '<leader>sl', Snacks.picker.lines, { desc = 'Picker: Buffer lines' })
set({ 'n', 'x' }, '<leader>sw', Snacks.picker.grep_word, {
  desc = 'Picker: Word or visual selection',
})
-- endregion

-- region Notifications
set('n', '<leader>nl', Snacks.notifier.show_history, { desc = 'Notifier: History' })
set('n', '<leader>nc', Snacks.notifier.hide, { desc = 'Notifier: Dismiss all' })
-- endregion

-- region Scratch
set('n', '<leader>..', Snacks.scratch.open, { desc = 'Scratch: Resume' })
set('n', '<leader>.b', Snacks.scratch.select, { desc = 'Scratch: List opened' })
set('n', '<leader>.s', Snacks.scratch.list, { desc = 'Scratch: List all' })
-- endregion

-- region Git
set('n', '<leader>gls', Snacks.lazygit.open, { desc = 'LazyGit: Status' })
set('n', '<leader>gll', Snacks.lazygit.log, { desc = 'LazyGit: Log' })
set('n', '<leader>glf', Snacks.lazygit.log_file, { desc = 'LazyGit: Log current file' })
set({ 'n', 'v' }, '<leader>gG', Snacks.gitbrowse.open, {
  desc = 'Git: Open line in remote repository (web browser)',
})
set('n', '<leader>gl', Snacks.picker.git_log, { desc = 'Git: Log' })
set('n', '<leader>gL', Snacks.picker.git_log_line, { desc = 'Git: Log current line' })
set('n', '<leader>gs', Snacks.picker.git_status, { desc = 'Git: Status' })
set('n', '<leader>gd', Snacks.picker.git_diff, { desc = 'Git: Diff (Hunks)' })
set('n', '<leader>gf', Snacks.picker.git_log_file, { desc = 'Git: Log current file' })
set('n', '<leader>gb', Snacks.git.blame_line, { desc = 'Git: Blame current line' })
-- search
set('n', '<leader>gss', Snacks.picker.git_stash, { desc = 'Git: Stash' })
set('n', '<leader>gsf', Snacks.picker.git_files, { desc = 'Git: List files' })
set('n', '<leader>gsb', Snacks.picker.git_branches, { desc = 'Git: Branches' })
-- endregion

-- region Vim
set('n', "<leader>v'", Snacks.picker.registers, { desc = 'Vim: Registers' })
set('n', '<leader>v/', Snacks.picker.search_history, { desc = 'Vim: Search history' })
set('n', '<leader>va', Snacks.picker.autocmds, { desc = 'Vim: Autocmds' })
set('n', '<leader>v:', Snacks.picker.command_history, { desc = 'Vim: Command history' })
set('n', '<leader>vc', Snacks.picker.commands, { desc = 'Vim: Commands' })
set('n', '<leader>vC', Snacks.picker.colorschemes, { desc = 'Vim: Colorschemes' })
set('n', '<leader>vh', Snacks.picker.help, { desc = 'Vim: Help' })
set('n', '<leader>vH', Snacks.picker.highlights, { desc = 'Vim: Highlights' })
set('n', '<leader>vi', Snacks.picker.icons, { desc = 'Vim: Icons' })
set('n', '<leader>vj', Snacks.picker.jumps, { desc = 'Vim: Jumps' })
set('n', '<leader>vk', Snacks.picker.keymaps, { desc = 'Vim: Keymaps' })
set('n', '<leader>vl', Snacks.picker.loclist, { desc = 'Vim: Locations' })
set('n', '<leader>vm', Snacks.picker.marks, { desc = 'Vim: Marks' })
set('n', '<leader>vM', Snacks.picker.man, { desc = 'Vim: Man pages' })
set('n', '<leader>vP', Snacks.picker.lazy, { desc = 'Vim: Search LazySpecs' })
set('n', '<leader>vq', Snacks.picker.qflist, { desc = 'Vim: Quickfix' })
set('n', '<leader>vu', Snacks.picker.undo, { desc = 'Vim: Undo history' })
-- endregion

-- region LSP
-- search and goto (main features)
set(
  'n',
  '<leader>ld',
  Snacks.picker.lsp_definitions,
  { desc = 'LSP: Go to definition' }
)
set(
  'n',
  '<leader>le',
  Snacks.picker.lsp_declarations,
  { desc = 'LSP: Go to declaration' }
)
set('n', '<leader>lr', Snacks.picker.lsp_references, {
  desc = 'LSP: List References',
})
set(
  'n',
  '<leader>li',
  Snacks.picker.lsp_implementations,
  { desc = 'LSP: Go to Implementation' }
)
set(
  'n',
  '<leader>lt',
  Snacks.picker.lsp_type_definitions,
  { desc = 'LSP: Go to type definition' }
)
set('n', '<leader>lo', Snacks.picker.lsp_symbols, { desc = 'LSP: List Symbols' })
set(
  'n',
  '<leader>lm',
  Snacks.picker.diagnostics_buffer,
  { desc = 'LSP: List diagnostics' }
)
-- search
set(
  'n',
  '<leader>lso',
  Snacks.picker.lsp_workspace_symbols,
  { desc = 'LSP: List workspace symbols' }
)
set(
  'n',
  '<leader>lsm',
  Snacks.picker.diagnostics,
  { desc = 'LSP: List workspace diagnostics' }
)
-- Other
set('n', '<leader>ar', Snacks.rename.rename_file, { desc = 'LSP: Rename current file' })
set({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, {
  desc = 'LSP: Next highlighted word',
})
set({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, {
  desc = 'LSP: Previous highlighted word',
})
-- endregion

-- region Terminal
set('n', '<c-/>', Snacks.terminal.open, { desc = 'Terminal: toggle' })
set('n', '<c-_>', Snacks.terminal.open, { desc = 'which_key_ignore' })
-- endregion

-- region Buffer
set(
  'n',
  '<leader>bd',
  -- deletes buffer without affecting window layout
  Snacks.bufdelete.delete,
  {
    desc = 'Buffer: Delete',
  }
)
-- endregion

-- region Other
set('n', '<leader>N', function()
  Snacks.win {
    file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = 'yes',
      statuscolumn = ' ',
      conceallevel = 3,
    },
  }
end, {
  desc = 'Other: Neovim news',
})
-- endregion
