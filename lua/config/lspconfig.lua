local M = {}

M.keys = {
  { '<leader>la', vim.lsp.buf.code_action },
  -- f as in 'find'; j (down) as in here, myself, where I stand
  { '<leader>fj', '<cmd>Telescope lsp_incoming_calls<cr>' },
  -- f as in 'find'; k (up) as in there, somewhere, out
  { '<leader>fj', '<cmd>Telescope lsp_outgoing_calls<cr>' },
  { '<leader>lr', vim.lsp.buf.rename },
  -- NOTE renaming accross workspace is dependent on LSP (implementation), some
  -- may support it, some may do it by default
  { '<leader>ls', vim.lsp.buf.signature_help },
  -- f as in 'find'; p as in parent, what allowed it to be, from which is inherits
  { '<leader>fp', '<cmd>Telescope lsp_type_definitions<cr>' },
  -- TODO Telescope typehierarchy
}

return M
