return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer (Neo-tree)" },
    { "<leader>fo", "<cmd>Neotree focus<CR>", desc = "Focus Neo-tree" },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
  },
}
