local conceal = require("conceal")

conceal.setup({
  ["lua"] = {
    keywords = {
      ["local"] = {
        conceal = "L",
      },
      ["return"] = {
        conceal = "R",
      },
      ["for"] = {
        conceal = "F",
        highlight = "keyword",
      },
      ["function"] = {
        conceal = "Fn",
      },
      ["end"] = {
        conceal = "E",
      },
    },
  },
})

conceal.generate_conceals()
