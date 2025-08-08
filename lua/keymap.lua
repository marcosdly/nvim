--[[
  Editor keymaps
--]]

-- TODO toggle boolean value under cursor (code action? treeshitter?)
-- TODO merge, split lines both in normal and insert modes
-- TODO jump to syntax token
-- TODO jump to enclosing tokens (quotes, parentheses)

local action_preview = require 'actions-preview'
local dap = require 'dap'
local dap_helper = require 'plugins.dap.helper'
local dapui = require 'dapui'
local dropbar_api = require 'dropbar.api'
local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
local wk = require 'which-key'

wk.add {
  { '<c-d>', '<c-d>zz', desc = 'Scroll half screen up' },
  { '<c-u>', '<c-u>zz', desc = 'Scroll half screen down' },
  { '<leader>/', '<cmd>nohl<cr>', desc = 'Clear search highlighting' },

  -- move up and down even between wrapped lines
  -- SEE https://stackoverflow.com/a/60907908
  -- >I have found another version of this solution that does more than
  -- >moving through physical or virtual lines, it also adds jumps bigger
  -- >than 5 lines to the jump list, allowing us to use Ctrl-o and Ctrl-i.
  -- SOURCE: https://www.vi-improved.org/vim-tips/
  {
    'j',
    [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj']],
    noremap = true,
    expr = true,
  },
  {
    'k',
    [[v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk']],
    noremap = true,
    expr = true,
  },

  -- Clear line without appending to any register, nor changing mode
  { 'dD', '0"_D', desc = 'Delete line without yanking' },
  -- Remap visual block mode
  { '<c-b>', '<c-v>', desc = 'Block select mode' },

  { '<leader>b', group = 'Buf' },
  -- region Buffer
  { '<leader>bn', '<cmd>bnext<cr>', desc = 'Buffer: Go to next' },
  { '<leader>bp', '<cmd>bprevious<cr>', desc = 'Buffer: Go to previous' },
  { '<leader>b[', '<cmd>bfirst<cr>', desc = 'Buffer: Go to first' },
  { '<leader>b]', '<cmd>blast<cr>', desc = 'Buffer: Go to last' },
  -- deletes buffer without affecting window layout
  { '<leader>bd', Snacks.bufdelete.delete, desc = 'Buffer: Delete' },
  -- endregion

  { '<leader>w', group = 'Win' },
  -- region Window
  { '<leader>wn', '<cmd>wincmd w<cr>', desc = 'Window: Go to next (wrap around)' },
  { '<leader>wp', '<cmd>wincmd W<cr>', desc = 'Window: Go to previous (wrap around)' },
  { '<leader>wj', '<cmd>wincmd j<cr>', desc = 'Window: Go to bottom' },
  { '<leader>wk', '<cmd>wincmd k<cr>', desc = 'Window: Go to top' },
  { '<leader>wh', '<cmd>wincmd h<cr>', desc = 'Window: Go to left' },
  { '<leader>wl', '<cmd>wincmd l<cr>', desc = 'Window: Go to right' },
  { '<leader>we', '<cmd>wincmd p<cr>', desc = 'Window: Go to last accessed' },
  {
    '<leader>wP',
    function() -- todo to preview window or error
      local ok, _ = pcall(vim.cmd '<cmd>wincmd P<cr>')
      if not ok then vim.print 'No preview window available.' end
    end,
    desc = 'Window: Go to preview window',
  },
  { '<leader>wt', '<cmd>wincmd T<cr>', desc = 'Window: Move to new tab' },
  {
    '<leader>w=',
    '<cmd>wincmd =<cr>',
    desc = 'Window: Even out dimensions of all windows',
  },
  { '<leader>w[', '<cmd>wincmd +1<cr>', desc = 'Window: Increase height' },
  { '<leader>w]', '<cmd>wincmd -1<cr>', desc = 'Window: Decrease height' },
  { "<leader>w'", '<cmd>wincmd >1<cr>', desc = 'Window: Increase width' },
  { '<leader>w;', '<cmd>wincmd <1<cr>', desc = 'Window: Decrease width' },
  { '<leader>w\\', '<cmd>wincmd _<cr>', desc = 'Window: Maximium height' },
  { '<leader>w|', '<cmd>wincmd |<cr>', desc = 'Window: Maximium width' },
  {
    '<leader>wf',
    '<cmd>wincmd _<cr><cmd>wincmd |<cr>',
    desc = 'Window: Maximum dimentions',
  },
  -- endregion

  { '<leader>t', group = 'Tab' },
  -- region Tab
  -- Open a new tab and edit the file under the cursor
  { '<leader>tf', '<ctrl-w>gf', desc = 'Tab: Open this file (plain path)' },
  -- Open a new tab and edit the file under the cursor, include line number identiifers
  { '<leader>tF', '<ctrl-w>gF', desc = 'Tab: Open this file (editor string)' },
  { '<leader>tn', '<cmd>tabnext<cr>', desc = 'Tab: Go to next' },
  { '<leader>tp', '<cmd>tabprevious<cr>', desc = 'Tab: Go to previous' },
  { '<leader>td', '<cmd>tabclose<cr>', desc = 'Tab: Close current' },
  { '<leader>t[', '<cmd>tabfirst<cr>', desc = 'Tab: Go to first tab' },
  { '<leader>t]', '<cmd>tablast<cr>', desc = 'Tab: Go to last tab' },
  { '<leader>te', '<ctrl-w>g<tab>', desc = 'Tab: Go to last accessed' },
  -- endregion

  -- save file in other modes
  { '<c-z>', '<cmd>write<cr>', mode = 't', desc = 'Write file' },

  -- region Meta
  {
    '<leader>?',
    function()
      wk.show { global = false }
    end,
    desc = 'WhichKey: Buffer Local Keymaps',
  },
  {
    '<leader>N',
    function()
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
    end,
    desc = 'Other: Neovim news',
  },
  -- endregion

  { '<leader>v', group = 'Vim' },
  -- region Vim
  {
    '<leader>vo',
    '<cmd>Telescope vim_options<cr>',
    desc = 'Vim: Search options',
  },
  {
    '<leader>vs',
    '<cmd>Telescope spell_suggest<cr>',
    desc = 'Vim: List spelling suggestions',
  },
  { "<leader>v'", Snacks.picker.registers, desc = 'Vim: Registers' },
  { '<leader>v/', Snacks.picker.search_history, desc = 'Vim: Search history' },
  { '<leader>va', Snacks.picker.autocmds, desc = 'Vim: Autocmds' },
  { '<leader>v:', Snacks.picker.command_history, desc = 'Vim: Command history' },
  { '<leader>vc', Snacks.picker.commands, desc = 'Vim: Commands' },
  { '<leader>vC', Snacks.picker.colorschemes, desc = 'Vim: Colorschemes' },
  { '<leader>vh', Snacks.picker.help, desc = 'Vim: Help' },
  { '<leader>vH', Snacks.picker.highlights, desc = 'Vim: Highlights' },
  { '<leader>vi', Snacks.picker.icons, desc = 'Vim: Icons' },
  { '<leader>vj', Snacks.picker.jumps, desc = 'Vim: Jumps' },
  { '<leader>vk', Snacks.picker.keymaps, desc = 'Vim: Keymaps' },
  { '<leader>vl', Snacks.picker.loclist, desc = 'Vim: Locations' },
  { '<leader>vm', Snacks.picker.marks, desc = 'Vim: Marks' },
  { '<leader>vM', Snacks.picker.man, desc = 'Vim: Man pages' },
  { '<leader>vP', Snacks.picker.lazy, desc = 'Vim: Search LazySpecs' },
  { '<leader>vq', Snacks.picker.qflist, desc = 'Vim: Quickfix' },
  { '<leader>vu', Snacks.picker.undo, desc = 'Vim: Undo history' },
  -- endregion

  -- region Oil
  { '-', '<cmd>Oil --float<cr>', desc = 'Oil: Open parent dir' },
  { '<leader>-', '<cmd>Oil --float --trash<cr>', desc = 'Oil: Parent dir trash' },
  {

    '<localleader>-',
    '<cmd>Oil --float --trash /<cr>',
    desc = 'Oil: System wide trash',
  },
  -- endregion

  { '<leader>l', group = 'LSP' },
  -- region LSP
  { '<leader>la', vim.lsp.buf.code_action, desc = 'LSP: List code actions' },
  {

    '<leader>lc',
    '<cmd>Telescope lsp_incoming_calls<cr>',
    desc = 'LSP: List incoming calls',
  },
  {

    '<leader>lC',
    '<cmd>Telescope lsp_outgoing_calls<cr>',
    desc = 'LSP: List outgoing calls',
  },
  { '<leader>ls', vim.lsp.buf.signature_help, desc = 'LSP: Signature help' },
  { '<leader>lbs', dropbar_api.pick, desc = 'Breadcrumbs: Pick symbols' },
  {

    '<leader>lb[',
    function()
      dropbar_api.goto_context_start(1)
    end,
    desc = 'Breadcrumbs: Go to previous context',
  },
  {

    '<leader>lb]',
    dropbar_api.select_next_context,
    desc = 'Breadcrumbs: Select next context',
  },
  -- search and goto (main features)
  { '<leader>ld', Snacks.picker.lsp_definitions, desc = 'LSP: Go to definition' },
  {

    '<leader>le',
    Snacks.picker.lsp_declarations,
    desc = 'LSP: Go to declaration',
  },
  { '<leader>lr', Snacks.picker.lsp_references, desc = 'LSP: List References' },
  {

    '<leader>li',
    Snacks.picker.lsp_implementations,
    desc = 'LSP: Go to Implementation',
  },
  {

    '<leader>lt',
    Snacks.picker.lsp_type_definitions,
    desc = 'LSP: Go to type definition',
  },
  { '<leader>lo', Snacks.picker.lsp_symbols, desc = 'LSP: List Symbols' },
  {

    '<leader>lm',
    Snacks.picker.diagnostics_buffer,
    desc = 'LSP: List diagnostics',
  },
  -- search
  {

    '<leader>lso',
    Snacks.picker.lsp_workspace_symbols,
    desc = 'LSP: List workspace symbols',
  },
  {

    '<leader>lsm',
    Snacks.picker.diagnostics,
    desc = 'LSP: List workspace diagnostics',
  },
  {
    ']]',
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    mode = { 'n', 't' },
    desc = 'LSP: Next highlighted word',
  },
  {
    '[[',
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    mode = { 'n', 't' },
    desc = 'LSP: Previous highlighted word',
  },
  -- endregion

  { '<leader>a', group = 'Action' },
  -- region Code Action
  {
    '<leader>ar',
    -- NOTE renaming accross workspace is dependent on LSP (implementation), some
    -- may support it, some may do it by default
    vim.lsp.buf.rename,
    desc = 'LSP: Rename symbol',
  },
  {
    '<leader>aa',
    action_preview.code_actions,
    mode = { 'n', 'v' },
    desc = 'Action: List and preview actions',
  },
  { '<leader>af', '<cmd>FormatLock<cr>', desc = 'Action: Format buffer' },
  { '<leader>ar', Snacks.rename.rename_file, desc = 'LSP: Rename current file' },
  -- endregion

  { '<leader>S', group = 'Session' },
  -- region Session
  -- Will use Telescope if installed or a vim.ui.select picker otherwise
  { '<leader>Ss', '<cmd>SessionSearch<cr>', desc = 'AutoSession: Search' },
  { '<leader>Sw', '<cmd>SessionSave<cr>', desc = 'AutoSession: Quick save' },
  { '<leader>Sn', ':SessionSave ', desc = 'AutoSession: Save as...' },
  { '<leader>St', ':SessionToggleAutoSave', desc = 'AutoSession: Toggle autosave' },
  -- endregion

  -- region Treesitter
  -- Repeat movement with ; and ,
  -- vim way: ; goes to the direction you were moving.
  {
    ';',
    ts_repeat_move.repeat_last_move,
    mode = { 'n', 'x', 'o' },
    desc = 'Treesitter: textobjects repeat',
  },
  {
    ',',
    ts_repeat_move.repeat_last_move_opposite,
    mode = { 'n', 'x', 'o' },
    desc = 'Treesitter: textobjects repeat opposite direction',
  },
  -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
  { 'f', ts_repeat_move.builtin_f_expr, mode = { 'n', 'x', 'o' }, expr = true },
  { 'F', ts_repeat_move.builtin_F_expr, mode = { 'n', 'x', 'o' }, expr = true },
  { 't', ts_repeat_move.builtin_t_expr, mode = { 'n', 'x', 'o' }, expr = true },
  { 'T', ts_repeat_move.builtin_T_expr, mode = { 'n', 'x', 'o' }, expr = true },

  -- endregion

  -- region Snacks
  { '<leader>\\', Snacks.picker.resume, desc = 'Picker: Resume last window' },
  -- endregion

  { '<leader>s', group = 'Search' },
  -- region Search
  -- quick actions
  { '<leader>s.', Snacks.picker.smart, desc = 'Picker: Smart find files' },
  { '<leader>s,', Snacks.picker.buffers, desc = 'Picker: Buffers' },
  { '<leader>s/', Snacks.picker.grep, desc = 'Picker: Grep cwd' },
  { '<leader>s;', Snacks.picker.grep_buffers, desc = 'Picker: Grep buffers' },
  -- normal actions
  {

    '<leader>sc',
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Picker: Config files',
  },
  { '<leader>sf', Snacks.picker.files, desc = 'Picker: Files' },
  { '<leader>sp', Snacks.picker.projects, desc = 'Picker: Projects' },
  { '<leader>sr', Snacks.picker.recent, desc = 'Picker: Recent' },
  { '<leader>sl', Snacks.picker.lines, desc = 'Picker: Buffer lines' },
  {
    '<leader>sw',
    Snacks.picker.grep_word,
    mode = { 'n', 'x' },
    desc = 'Picker: Word or visual selection',
  },
  -- endregion

  { '<leader>n', group = 'Notifications' },
  -- region Notifications
  { '<leader>nl', Snacks.notifier.show_history, desc = 'Notifier: History' },
  { '<leader>nc', Snacks.notifier.hide, desc = 'Notifier: Dismiss all' },
  -- endregion

  { '<leader>.', group = 'Scratchpad' },
  -- region Scratchpad
  { '<leader>..', Snacks.scratch.open, desc = 'Scratch: Resume' },
  { '<leader>.b', Snacks.scratch.select, desc = 'Scratch: List opened' },
  { '<leader>.s', Snacks.scratch.list, desc = 'Scratch: List all' },
  -- endregion

  { '<leader>g', group = 'Git' },
  -- region Git
  { '<leader>gls', Snacks.lazygit.open, desc = 'LazyGit: Status' },
  { '<leader>gll', Snacks.lazygit.log, desc = 'LazyGit: Log' },
  { '<leader>glf', Snacks.lazygit.log_file, desc = 'LazyGit: Log current file' },
  {
    '<leader>gG',
    Snacks.gitbrowse.open,
    mode = { 'n', 'v' },
    desc = 'Git: Open line in remote repository (web browser)',
  },
  { '<leader>gl', Snacks.picker.git_log, desc = 'Git: Log' },
  { '<leader>gL', Snacks.picker.git_log_line, desc = 'Git: Log current line' },
  { '<leader>gs', Snacks.picker.git_status, desc = 'Git: Status' },
  { '<leader>gd', Snacks.picker.git_diff, desc = 'Git: Diff (Hunks)' },
  { '<leader>gf', Snacks.picker.git_log_file, desc = 'Git: Log current file' },
  { '<leader>gb', Snacks.git.blame_line, desc = 'Git: Blame current line' },
  -- search
  { '<leader>gss', Snacks.picker.git_stash, desc = 'Git: Stash' },
  { '<leader>gsf', Snacks.picker.git_files, desc = 'Git: List files' },
  { '<leader>gsb', Snacks.picker.git_branches, desc = 'Git: Branches' },
  -- endregion

  -- region Terminal
  { '<esc>', '<c-\\><c-n>', mode = 't', desc = 'which_key_ignore' },
  { '<c-/>', Snacks.terminal.open, desc = 'Terminal: toggle' },
  { '<c-_>', Snacks.terminal.open, desc = 'which_key_ignore' },
  -- endregion

  { '<leader>d', group = 'Debug' },
  -- region Debug
  {

    '<leader>dc',
    function()
      dap_helper.refresh_config()
      dap.continue()
    end,
  },
  { '<leader>dC', dap.reverse_continue },
  { '<leader>dr', dap.restart },
  { '<leader>dR', dap.restart_frame },
  { '<leader>dp', dap.pause },
  { '<leader>dt', dap.terminate },
  {

    '<leader>di',
    function()
      dap_helper.refresh_config()
      dap.status()
    end,
  },
  {

    '<leader>dI',
    function()
      dap_helper.refresh_config()
      dap.sessions()
    end,
  },
  { '<leader>dD', dap.disconnect },
  { '<leader>dg', dapui.toggle },
  -- breakpoint
  { '<leader>db', dap.toggle_breakpoint },
  {

    '<leader>dB',
    function()
      dap_helper.refresh_config()
      dap.list_breakpoints()
    end,
  },
  { '<leader>dC', dap.clear_breakpoints },
  -- navigation
  { '<leader>dl', dap.step_over },
  { '<leader>dh', dap.step_back },
  { '<leader>dk', dap.step_out },
  { '<leader>dj', dap.step_into },
  { '<leader>dp', dap.up },
  { '<leader>dn', dap.down },
  { '<leader>df', dap.focus_frame },
  { '<leader>du', dap.run_to_cursor },
  -- console
  { '<leader>dco', dap.repl.open },
  { '<leader>dcc', dap.repl.close },
  -- TODO exec text from selection
  { '<leader>dce', dap.repl.execute, mode = 'v' },
  -- TODO goto line dap.goto_()
  -- TODO dap widgets
  -- endregion
}
