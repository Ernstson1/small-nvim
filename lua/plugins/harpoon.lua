local keys = {
  {
    "<leader>H",
    function()
      require("harpoon"):list():add()
    end,
    desc = "Harpoon file",
  },
  {
    "<leader>h",
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon quick menu",
  },
}
for i = 1, 9 do
  table.insert(keys, {
    "<leader>" .. i,
    function()
      require("harpoon"):list():select(i)
    end,
    desc = "Harpoon to file " .. i,
  })
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = keys,
  opts = { settings = { save_on_toggle = true } },
}
