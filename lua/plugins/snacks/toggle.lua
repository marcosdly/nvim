Snacks.toggle.diagnostics():map("<leader>tm")
Snacks.toggle.dim():map("<leader>td")
Snacks.toggle.indent():map("<leader>ti")
Snacks.toggle.inlay_hints():map("<leader>th")
Snacks.toggle.line_number():map("<leader>tn")
Snacks.toggle.treesitter():map("<leader>tt")
Snacks.toggle.words():map("<leader>tw")

-- Toggle portuguese mbyte-keymap
Snacks.toggle({
  name = "mbyte-keymap: Portuguese ABNT2",
  get = function()
    return vim.o.keymap == "portuguese-accents-abnt2"
  end,
  set = function(state)
    vim.o.keymap = state and "portuguese-accents-abnt2" or ""
  end,
}):map("<leader>tk")

Snacks.toggle({
  name = "Centered buffer",
  get = function()
    return require("no-neck-pain").state.enabled
  end,
  set = function(state)
    (state and no_neck_pain.enable or no_neck_pain.disable)()
  end,
}):map("tC")

Snacks.toggle({
  name = "Treesitter conceal",
  get = function()
    return vim.wo.conceallevel == 1
  end,
  set = function(level)
    vim.wo.conceallevel = level == 1 and 0 or 1
  end,
}):map("<leader>tc")

Snacks.toggle({
  name = "(buffer) Auto-write",
  get = function()
    return sos.buf_enabled(0)
  end,
  set = function(state)
    (state and sos.enable_buf or sos.disable_buf)(0)
  end,
}):map("tab")
Snacks.toggle({
  name = "(global) Auto-write",
  get = function()
    return require("sos.config").opts.enabled
  end,
  set = function(state)
    vim.cmd(state and "SosEnable" or "SosDisable")
  end,
}):map("tag")
