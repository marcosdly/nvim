local spec = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'Wansmer/treesj',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
    'Jxstxs/conceal.nvim',
  },
  build = ':TSUpdate',
  config = function()
    require 'plugins.treesitter.setup'
    require 'plugins.treesitter.conceal'
  end,
}

require('bootstrap').LazyNvim:SetPriority { spec }

return spec
