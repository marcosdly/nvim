local set = vim.keymap.set

-- Repeat movement with ; and ,
-- vim way: ; goes to the direction you were moving.

set({ "n", "x", "o" }, ";", function()
  require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move()
end, {
  desc = "Treesitter: textobjects repeat",
})

set({ "n", "x", "o" }, ",", function()
  require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite()
end, { desc = "Treesitter: textobjects repeat opposite direction" })
