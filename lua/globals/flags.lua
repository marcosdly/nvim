_G.FLAG = {}

FLAG.CAN_TEST_UI_RELATED = false
vim.api.nvim_create_autocmd('VimEnter', {
  once=true,
  callback = function()
    FLAG.CAN_TEST_UI_RELATED = true
  end,
})

