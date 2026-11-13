return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
      documentation = { auto_show = true },
    },
  },
}
