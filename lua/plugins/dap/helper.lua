local M = {}

function M.refresh_config()
  require("dap.ext.vscode").load_launchjs()
  -- TODO load configs from neodev's config file
  -- TODO watch files for changes
end

return M
