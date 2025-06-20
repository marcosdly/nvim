---Function from snacks.nvim/docs/notifier.md
---SEE https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function notify_lsp_progress(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= 'table' then return end
  local p = state.lsp_progress[client.id]

  local is_done = value.kind == 'end'
  state.lsp_done[client.name] = is_done

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == ev.data.params.token then
      p[i] = {
        token = ev.data.params.token,
        msg = ('[%3d%%] %s%s'):format(
          is_done and 100 or value.percentage or 100,
          value.title or '',
          value.message and (' **%s**'):format(value.message) or ''
        ),
        done = is_done,
      }
      break
    end
  end

  local msg = {} ---@type string[]
  state.lsp_progress[client.id] = vim.tbl_filter(function(v)
    return table.insert(msg, v.msg) or not v.done
  end, p)

  if value.kind == 'report' and value.percentage % 5 ~= 0 then return end

  local spinner =
    { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify(table.concat(msg, '\n'), 'info', {
    id = 'lsp_progress',
    title = client.name,
    opts = function(notif)
      notif.icon = #state.lsp_progress[client.id] == 0 and ' '
        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

local M = {}

---@type snacks.Config
M.opts = {
  -- TODO custom styles
  bigfile = {
    enabled = true,
    notify = true,
    size = 2 * 1024 * 1024,
    line_lenght = 5000,
  },
  notifier = {
    enabled = true,
    timeout = 2000,
    width = { min = 32, max = 0.4 },
    height = { min = 1, max = 0.5 },
    margin = { top = 1, right = 1 },
    padding = true,
    sort = { 'added', 'level' },
    level = vim.log.levels.INFO,
    style = 'compact',
    top_down = true,
    refresh = 100, -- ms
  },
  indent = {
    indent = {
      enabled = true,
      priority = 1,
      char = const.icons.misc.bottom_small_dot,
      only_scope = true,
      only_current = false,
    },
    animate = { enabled = false },
    scope = { enabled = true, priority = 10, only_current = false },
    chunk = { enabled = true, priority = 100, only_current = false },
  },
  lazygit = {
    -- TODO style: better hl groups
    configure = true,
    config = {
      os = { editPreset = 'nvim-remote' },
      gui = {
        -- set to an empty string "" to disable icons
        nerdFontsVersion = '3',
      },
    },
  },
  quickfile = { enabled = true },
  scratch = {
    autowrite = true,
    filekey = { cwd = true, branch = true, count = false },
  },
  statuscolumn = {
    enabled = true,
    left = { 'sign', 'fold' },
    right = { 'mark' },
    folds = { open = true, git_hl = true },
    git = {
      patterns = {
        'GitSign',
        'MiniDiffSign',
        'MiniDiffOverAdd',
        'MiniDiffOverDelete',
        'MiniDiffOverAdd',
      },
    },
    refresh = 100,
  },
  dim = {
    scope = {
      min_size = 5,
      max_size = 50,
      siblings = true,
    },
    animate = { enabled = false },
  },
  words = {
    debounce = 100,
  },
  -- TODO terminal
  -- TODO toggle
}

M.keys = {
  {
    '<leader>\\',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Picker: Resume last window',
  },
}

vim.list_extend(M.keys, {
  -- region Search
  -- quick actions
  {
    '<leader>s.',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Picker: Smart find files',
  },
  {
    '<leader>s,',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Picker: Buffers',
  },
  {
    '<leader>s/',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Picker: Grep cwd',
  },
  {
    '<leader>s;',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Picker: Grep buffers',
  },
  -- normal actions
  {
    '<leader>sc',
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Picker: Config files',
  },
  {
    '<leader>sf',
    function()
      Snacks.picker.files()
    end,
    desc = 'Picker: Files',
  },
  {
    '<leader>sp',
    function()
      Snacks.picker.projects()
    end,
    desc = 'Picker: Projects',
  },
  {
    '<leader>sr',
    function()
      Snacks.picker.recent()
    end,
    desc = 'Picker: Recent',
  },
  {
    '<leader>sl',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Picker: Buffer lines',
  },
  {
    '<leader>sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Picker: Word or visual selection',
    mode = { 'n', 'x' },
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Notifications
  {
    '<leader>nl',
    function()
      Snacks.notifier.show_history()
    end,
    desc = 'Notifier: History',
  },
  {
    '<leader>nc',
    function()
      Snacks.notifier.hide()
    end,
    desc = 'Notifier: Dismiss all',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Scratch
  {
    '<leader>..',
    function()
      Snacks.scratch()
    end,
    desc = 'Scratch: Resume',
  },
  {
    '<leader>.b',
    function()
      Snacks.scratch.select()
    end,
    desc = 'Scratch: List opened',
  },
  {
    '<leader>.s',
    function()
      Snacks.scratch.list()
    end,
    desc = 'Scratch: List all',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Git
  {
    '<leader>gls',
    function()
      Snacks.lazygit()
    end,
    desc = 'LazyGit: Status',
  },
  {
    '<leader>gll',
    function()
      Snacks.lazygit.log()
    end,
    desc = 'LazyGit: Log',
  },
  {
    '<leader>glf',
    function()
      Snacks.lazygit.log_file()
    end,
    desc = 'LazyGit: Log current file',
  },
  {
    '<leader>gG',
    function()
      Snacks.gitbrowse()
    end,
    desc = 'Git: Open line in remote repository (web browser)',
    mode = { 'n', 'v' },
  },
  {
    '<leader>gl',
    function()
      Snacks.picker.git_log()
    end,
    desc = 'Git: Log',
  },
  {
    '<leader>gL',
    function()
      Snacks.picker.git_log_line()
    end,
    desc = 'Git: Log current line',
  },
  {
    '<leader>gs',
    function()
      Snacks.picker.git_status()
    end,
    desc = 'Git: Status',
  },
  {
    '<leader>gd',
    function()
      Snacks.picker.git_diff()
    end,
    desc = 'Git: Diff (Hunks)',
  },
  {
    '<leader>gf',
    function()
      Snacks.picker.git_log_file()
    end,
    desc = 'Git: Log current file',
  },
  {
    '<leader>gb',
    function()
      Snacks.git.blame_line()
    end,
    desc = 'Git: Blame current line',
  },
  -- search
  {
    '<leader>gss',
    function()
      Snacks.picker.git_stash()
    end,
    desc = 'Git: Stash',
  },
  {
    '<leader>gsf',
    function()
      Snacks.picker.git_files()
    end,
    desc = 'Git: List files',
  },
  {
    '<leader>gsb',
    function()
      Snacks.picker.git_branches()
    end,
    desc = 'Git: Branches',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Vim
  {
    "<leader>v'",
    function()
      Snacks.picker.registers()
    end,
    desc = 'Vim: Registers',
  },
  {
    '<leader>v/',
    function()
      Snacks.picker.search_history()
    end,
    desc = 'Vim: Search history',
  },
  {
    '<leader>va',
    function()
      Snacks.picker.autocmds()
    end,
    desc = 'Vim: Autocmds',
  },
  {
    '<leader>v:',
    function()
      Snacks.picker.command_history()
    end,
    desc = 'Vim: Command history',
  },
  {
    '<leader>vc',
    function()
      Snacks.picker.commands()
    end,
    desc = 'Vim: Commands',
  },
  {
    '<leader>vC',
    function()
      Snacks.picker.colorschemes()
    end,
    desc = 'Vim: Colorschemes',
  },
  {
    '<leader>vh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Vim: Help',
  },
  {
    '<leader>vH',
    function()
      Snacks.picker.highlights()
    end,
    desc = 'Vim: Highlights',
  },
  {
    '<leader>vi',
    function()
      Snacks.picker.icons()
    end,
    desc = 'Vim: Icons',
  },
  {
    '<leader>vj',
    function()
      Snacks.picker.jumps()
    end,
    desc = 'Vim: Jumps',
  },
  {
    '<leader>vk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Vim: Keymaps',
  },
  {
    '<leader>vl',
    function()
      Snacks.picker.loclist()
    end,
    desc = 'Vim: Locations',
  },
  {
    '<leader>vm',
    function()
      Snacks.picker.marks()
    end,
    desc = 'Vim: Marks',
  },
  {
    '<leader>vM',
    function()
      Snacks.picker.man()
    end,
    desc = 'Vim: Man pages',
  },
  {
    '<leader>vP',
    function()
      Snacks.picker.lazy()
    end,
    desc = 'Vim: Search LazySpecs',
  },
  {
    '<leader>vq',
    function()
      Snacks.picker.qflist()
    end,
    desc = 'Vim: Quickfix',
  },
  {
    '<leader>vu',
    function()
      Snacks.picker.undo()
    end,
    desc = 'Vim: Undo history',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region LSP
  -- search and goto (main features)
  {
    '<leader>ld',
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = 'LSP: Go to definition',
  },
  {
    '<leader>le',
    function()
      Snacks.picker.lsp_declarations()
    end,
    desc = 'LSP: Go to declaration',
  },
  {
    '<leader>lr',
    function()
      Snacks.picker.lsp_references()
    end,
    nowait = true,
    desc = 'LSP: List References',
  },
  {
    '<leader>li',
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = 'LSP: Go to Implementation',
  },
  {
    '<leader>lt',
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = 'LSP: Go to type definition',
  },
  {
    '<leader>lo',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = 'LSP: List Symbols',
  },
  {
    '<leader>lm',
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = 'LSP: List diagnostics',
  },
  -- search
  {
    '<leader>lso',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = 'LSP: List workspace symbols',
  },
  {
    '<leader>lsm',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'LSP: List workspace diagnostics',
  },
  -- Other
  {
    '<leader>ar',
    function()
      Snacks.rename.rename_file()
    end,
    desc = 'LSP: Rename current file',
  },
  {
    ']]',
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = 'LSP: Next highlighted word',
    mode = { 'n', 't' },
  },
  {
    '[[',
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = 'LSP: Previous highlighted word',
    mode = { 'n', 't' },
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Terminal
  {
    '<c-/>',
    function()
      Snacks.terminal()
    end,
    desc = 'Terminal: toggle',
  },
  {
    '<c-_>',
    function()
      Snacks.terminal()
    end,
    desc = 'which_key_ignore',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Buffer
  {
    '<leader>bd',
    function()
      -- deletes buffer without affecting window layout
      Snacks.bufdelete()
    end,
    desc = 'Buffer: Delete',
  },
  -- endregion
})

vim.list_extend(M.keys, {
  -- region Other
  {
    '<leader>N',
    desc = 'Other: Neovim news',
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
  },
  -- endregion
})

function M.init()
  -- lsp progress
  vim.api.nvim_create_autocmd('LspProgress', { callback = notify_lsp_progress })
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
end

function M.config(lazyspec)
  Snacks.toggle.diagnostics():map '<leader>tm'
  Snacks.toggle.dim():map '<leader>td'
  Snacks.toggle.indent():map '<leader>ti'
  Snacks.toggle.inlay_hints():map '<leader>th'
  Snacks.toggle.line_number():map '<leader>tn'
  Snacks.toggle.treesitter():map '<leader>tt'
  Snacks.toggle.words():map '<leader>tw'

  -- Toggle portuguese mbyte-keymap
  Snacks.toggle({
    name = 'mbyte-keymap: Portuguese ABNT2',
    get = function()
      return vim.o.keymap == 'portuguese-accents-abnt2'
    end,
    set = function(state)
      vim.o.keymap = state and 'portuguese-accents-abnt2' or ''
    end,
  }):map '<leader>tk'
end

return M
