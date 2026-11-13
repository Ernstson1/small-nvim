local keys = {}
for i = 1, 4 do
  table.insert(keys, { "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm<CR>", desc = "Terminal " .. i })
end

return {
  "akinsho/toggleterm.nvim",
  keys = vim.list_extend({ { "<C-t>", desc = "Toggle terminal" } }, keys),
  cmd = "ToggleTerm",
  opts = {
    open_mapping = [[<C-t>]],
    direction = "horizontal",
    size = 15,
  },
}
