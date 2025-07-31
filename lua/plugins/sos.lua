local spec = {
  "tmillr/sos.nvim",
  opts = {
    enabled = true,
    timeout = const.time_delay.second * 10,
    create_parent_dirs = true,
    autowrite = false,
    save_on_cmd = "some",
    save_on_bufleave = false,
    save_on_focuslost = true,
    should_save = {
      unmodifiable = false,
      acwrite = {
        net = false,
        git = false,
        compress = false,
        other = false,
        schemes = {
          octo = false,
          term = false,
          file = true,
        },
      },
    },
  },
}

require('bootstrap').LazyNvim:SetPriority({spec})

return spec
