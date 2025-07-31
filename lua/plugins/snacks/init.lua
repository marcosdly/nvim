local spec = {
  "folke/snacks.nvim",
  config = function()
    require'plugins.snacks.setup'
    require'plugins.snacks.notify_lsp_progress'
    require'plugins.snacks.keys'
    require'plugins.snacks.toggle'
  end,
}

require('bootstrap').LazyNvim:SetPriority({spec})

return spec
