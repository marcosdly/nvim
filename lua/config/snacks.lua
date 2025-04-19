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
  bigfile = {
    enabled = true,
    notify = true,
    size = 2 * 1024 * 1024,
    line_lenght = 5000,
  },
  notifier = {
    enabled = true,
    timeout = 3000,
    width = { min = 32, max = 0.4 },
    height = { min = 1, max = 0.5 },
    margin = { top = 1, right = 1 },
    padding = true,
    sort = { 'updated', 'added' },
    level = vim.log.levels.INFO,
    keep = shared.util.is_mode_cmdline,
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
}

return M
