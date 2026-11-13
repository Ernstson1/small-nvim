local prettier = { "prettier" }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      mode = { "n", "x" },
      desc = "Format",
    },
  },
  opts = {
    -- Filetypes not listed (C/C++, Python, Java, C#) format through their LSP
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = { timeout_ms = 3000 },
    formatters_by_ft = {
      lua = { "stylua" },
      cmake = { "gersemi" },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      jsonc = prettier,
      yaml = prettier,
      html = prettier,
      css = prettier,
      markdown = prettier,
    },
    formatters = {
      -- Wrap prose at prettier's default 80 columns, matching markdownlint's MD013
      prettier = { prepend_args = { "--prose-wrap", "always" } },
    },
  },
}
