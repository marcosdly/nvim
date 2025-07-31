local autocmd = vim.api.nvim_create_autocmd
local vscode = require("vscode")

-- Toggle relative numbers on insert mode enter/leave
autocmd("InsertEnter", {
  desc = "ENABLE relativenumber",
  callback = function()
    vscode.update_config("editor.lineNumbers", "on", "global")
  end,
})
autocmd("InsertLeave", {
  desc = "DISABLE relativenumber",
  callback = function()
    vscode.update_config("editor.lineNumbers", "relative", "global")
  end,
})

local options_default = {
  ["editor.lineNumbers"] = "relative",
}

-- Set options back to default at startup
autocmd("VimEnter", {
  desc = "Set options back to default on start",
  callback = function()
    local vscode = require("vscode")
    for k, v in pairs(options_default) do
      vscode.update_config(k, v, "global")
    end
  end,
})
