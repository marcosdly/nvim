local spec = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "jay-babu/mason-nvim-dap.nvim",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "Joakker/lua-json5",
  },
  config=function()
    require 'plugins.dap.setup'
    require 'plugins.dap.keys'
  end,
}

require('bootstrap').LazyNvim:SetPriority({spec})

return spec
