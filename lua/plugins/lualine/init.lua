local spec = {
  "nvim-lualine/lualine.nvim",
  config = function()
    require 'plugins.lualine.setup'
  end,
}

require('bootstrap').LazyNvim:SetPriority({spec})

return spec

