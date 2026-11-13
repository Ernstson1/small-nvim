return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  init = function()
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_foreground = "mix"
  end,
  config = function()
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
