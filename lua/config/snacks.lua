local state = { notifier = {} }

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
state.notifier.progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---Function from snacks.nvim/docs/notifier.md
  ---SEE https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then return end
    local p = state.notifier.progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    state.notifier.progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner =
      { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #state.notifier.progress[client.id] == 0 and ' '
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

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
      char = shared.const.icons.misc.bottom_small_dot,
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
  -- TODO remap keys
  {
    '<leader>ggs',
    function()
      Snacks.lazygit()
    end,
  },
  {
    '<leader>ggl',
    function()
      Snacks.lazygit.log()
    end,
  },
  {
    '<leader>ggh',
    function()
      Snacks.lazygit.log_file()
    end,
  },
  {
    '<leader>s.',
    function()
      Snacks.scratch()
    end,
  },
  {
    '<leader>ss',
    function()
      Snacks.scratch.select()
    end,
  },
  {
    '<leader>sl',
    function()
      Snacks.scratch.list()
    end,
  },
  {
    '<leader>nl',
    function()
      Snacks.notifier.show_history()
    end,
    desc = 'Notification History',
  },
  {
    '<leader>nc',
    function()
      Snacks.notifier.hide()
    end,
    desc = 'Dismiss All Notifications',
  },
  {
    '<leader>bd',
    function()
      Snacks.bufdelete()
    end,
    desc = 'Delete buffer without affecting window layout',
  },
  -- git
  {
    '<leader>gb',
    function()
      Snacks.picker.git_branches()
    end,
    desc = 'Git Branches',
  },
  {
    '<leader>gl',
    function()
      Snacks.picker.git_log()
    end,
    desc = 'Git Log',
  },
  {
    '<leader>gL',
    function()
      Snacks.picker.git_log_line()
    end,
    desc = 'Git Log Line',
  },
  {
    '<leader>gs',
    function()
      Snacks.picker.git_status()
    end,
    desc = 'Git Status',
  },
  {
    '<leader>gS',
    function()
      Snacks.picker.git_stash()
    end,
    desc = 'Git Stash',
  },
  {
    '<leader>gd',
    function()
      Snacks.picker.git_diff()
    end,
    desc = 'Git Diff (Hunks)',
  },
  {
    '<leader>gF',
    function()
      Snacks.picker.git_log_file()
    end,
    desc = 'Git Log File',
  },
  {
    '<leader>gf',
    function()
      Snacks.picker.git_files()
    end,
    desc = 'Find Git Files',
  },
  {
    '<leader>gB',
    function()
      Snacks.git.blame_line()
    end,
    desc = 'List git log (blame) for current line',
  },
  -- Top Pickers & Explorer
  {
    's<space>',
    function()
      Snacks.picker.smart()
    end,
    desc = 'Smart Find Files',
  },
  {
    's,',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Buffers',
  },
  {
    's/',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Grep',
  },
  -- find
  {
    'sc',
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end,
    desc = 'Find Config File',
  },
  {
    'sf',
    function()
      Snacks.picker.files()
    end,
    desc = 'Find Files',
  },
  {
    'sp',
    function()
      Snacks.picker.projects()
    end,
    desc = 'Projects',
  },
  {
    'sr',
    function()
      Snacks.picker.recent()
    end,
    desc = 'Recent',
  },
  -- Grep
  {
    'sl',
    function()
      Snacks.picker.lines()
    end,
    desc = 'Buffer Lines',
  },
  {
    's;',
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = 'Grep Open Buffers',
  },
  {
    'sg',
    function()
      Snacks.picker.grep()
    end,
    desc = 'Grep',
  },
  {
    'sw',
    function()
      Snacks.picker.grep_word()
    end,
    desc = 'Visual selection or word',
    mode = { 'n', 'x' },
  },
  -- search
  {
    "sv'",
    function()
      Snacks.picker.registers()
    end,
    desc = 'Registers',
  },
  {
    'sv/',
    function()
      Snacks.picker.search_history()
    end,
    desc = 'Search History',
  },
  {
    'sva',
    function()
      Snacks.picker.autocmds()
    end,
    desc = 'Autocmds',
  },
  {
    'sv:',
    function()
      Snacks.picker.command_history()
    end,
    desc = 'Command History',
  },
  {
    'svc',
    function()
      Snacks.picker.commands()
    end,
    desc = 'Commands',
  },
  {
    'sd',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'Diagnostics',
  },
  {
    'sD',
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = 'Buffer Diagnostics',
  },
  {
    'svh',
    function()
      Snacks.picker.help()
    end,
    desc = 'Help Pages',
  },
  {
    'svh',
    function()
      Snacks.picker.highlights()
    end,
    desc = 'Highlights',
  },
  {
    'svi',
    function()
      Snacks.picker.icons()
    end,
    desc = 'Icons',
  },
  {
    'sj',
    function()
      Snacks.picker.jumps()
    end,
    desc = 'Jumps',
  },
  {
    'svk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = 'Keymaps',
  },
  {
    'svl',
    function()
      Snacks.picker.loclist()
    end,
    desc = 'Location List',
  },
  {
    'sm',
    function()
      Snacks.picker.marks()
    end,
    desc = 'Marks',
  },
  {
    'svm',
    function()
      Snacks.picker.man()
    end,
    desc = 'Man Pages',
  },
  {
    'svl',
    function()
      Snacks.picker.lazy()
    end,
    desc = 'Search for Plugin Spec',
  },
  {
    'sq',
    function()
      Snacks.picker.qflist()
    end,
    desc = 'Quickfix List',
  },
  {
    'svp',
    function()
      Snacks.picker.resume()
    end,
    desc = 'Resume',
  },
  {
    'svu',
    function()
      Snacks.picker.undo()
    end,
    desc = 'Undo History',
  },
  {
    'svC',
    function()
      Snacks.picker.colorschemes()
    end,
    desc = 'Colorschemes',
  },
  -- LSP
  {
    'gd',
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = 'Goto Definition',
  },
  {
    'ge',
    function()
      Snacks.picker.lsp_declarations()
    end,
    desc = 'Goto Declaration',
  },
  {
    'gr',
    function()
      Snacks.picker.lsp_references()
    end,
    nowait = true,
    desc = 'References',
  },
  {
    'gi',
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = 'Goto Implementation',
  },
  {
    'gy',
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = 'Goto T[y]pe Definition',
  },
  {
    'gs',
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = 'LSP Symbols',
  },
  {
    'gS',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = 'LSP Workspace Symbols',
  },
  -- Other
  {
    'cR',
    function()
      Snacks.rename.rename_file()
    end,
    desc = 'Rename File',
  },
  {
    'sb',
    function()
      Snacks.gitbrowse()
    end,
    desc = 'Git Browse',
    mode = { 'n', 'v' },
  },
  {
    '<c-/>',
    function()
      Snacks.terminal()
    end,
    desc = 'Toggle Terminal',
  },
  {
    '<c-_>',
    function()
      Snacks.terminal()
    end,
    desc = 'which_key_ignore',
  },
  {
    ']]',
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = 'Next Reference',
    mode = { 'n', 't' },
  },
  {
    '[[',
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = 'Prev Reference',
    mode = { 'n', 't' },
  },
  {
    '<leader>N',
    desc = 'Neovim News',
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
}

function M.init()
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
  Snacks.toggle.diagnostics():map 'td'
  Snacks.toggle.dim():map 'tD'
  -- Snacks.toggle.indent():map 'ti'
  Snacks.toggle.inlay_hints():map 'th'
  Snacks.toggle.line_number():map 'tn'
  -- Snacks.toggle.treesitter():map 'tt'
  Snacks.toggle.words():map 'tw'

  -- Toggle portuguese mbyte-keymap
  Snacks.toggle({
    name = 'mbyte-keymap: Portuguese ABNT2',
    get = function()
      return vim.o.keymap == 'portuguese-accents-abnt2'
    end,
    set = function(state)
      vim.o.keymap = state and 'portuguese-accents-abnt2' or ''
    end,
  }):map 'tkp'
end

return M
