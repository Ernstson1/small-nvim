local function builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
  },
  keys = {
    { "<leader><space>", builtin("find_files"), desc = "Find files" },
    { "<leader>ff", builtin("find_files"), desc = "Find files" },
    { "<leader>/", builtin("live_grep"), desc = "Grep" },
    { "<leader>sg", builtin("live_grep"), desc = "Grep" },
    { "<leader>sw", builtin("grep_string"), mode = { "n", "x" }, desc = "Grep word" },
    { "<leader>fb", builtin("buffers", { sort_mru = true }), desc = "Buffers" },
    { "<leader>fr", builtin("oldfiles"), desc = "Recent files" },
    { "<leader>sh", builtin("help_tags"), desc = "Help pages" },
    { "<leader>sk", builtin("keymaps"), desc = "Keymaps" },
    { "<leader>sd", builtin("diagnostics"), desc = "Diagnostics" },
    { "<leader>ss", builtin("lsp_document_symbols"), desc = "Document symbols" },
    { "<leader>sr", builtin("resume"), desc = "Resume last search" },
    { "gr", builtin("lsp_references"), nowait = true, desc = "References" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")
  end,
}
