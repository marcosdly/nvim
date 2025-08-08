local spec = {
  'folke/snacks.nvim',
  config = function()
    require 'plugins.snacks.setup'
    require 'plugins.snacks.toggle'

    local lsp_progress = require 'plugins.snacks.lsp_progress'
    lsp_progress.Setup()
  end,
}

require('bootstrap').LazyNvim:SetPriority { spec }

return spec
