---Function from snacks.nvim/docs/notifier.md
---SEE https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md

local M = {}

local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local lsp_progress = vim.defaulttable()

function M.GetProgress()
  return lsp_progress
end

---@type table<string, boolean>
local lsp_done = {}

function M.GetDone()
  return lsp_done
end

function M.AllLoaded()
  for _, client in ipairs(vim.lsp.get_clients()) do
    if not lsp_done[client.name] then return false end
  end
  return true
end

---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
function M.Notify(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= 'table' then return end
  local p = lsp_progress[client.id]

  local is_done = value.kind == 'end'
  lsp_done[client.name] = is_done

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
  lsp_progress[client.id] = vim.tbl_filter(function(v)
    return table.insert(msg, v.msg) or not v.done
  end, p)

  if value.kind == 'report' and value.percentage % 5 ~= 0 then return end

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify(table.concat(msg, '\n'), 'info', {
    id = 'lsp_progress',
    title = client.name,
    opts = function(notif)
      notif.icon = #lsp_progress[client.id] == 0 and ' '
        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

function M.Setup()
  -- lsp progress
  vim.api.nvim_create_autocmd('LspProgress', { callback = M.Notify })
end

return M
