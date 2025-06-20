local M = {}

M.keys = {
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
  { '<leader>ar', vim.lsp.buf.rename, desc = 'LSP: Rename symbol' },
  -- NOTE renaming accross workspace is dependent on LSP (implementation), some
  -- may support it, some may do it by default
  { '<leader>ls', vim.lsp.buf.signature_help, desc = 'LSP: Signature help' },
}

return M
