-- Run by install.sh: installs Mason packages and treesitter parsers headless, waiting for them to finish
require("lazy").load({ plugins = { "mason.nvim", "mason-lspconfig.nvim", "nvim-treesitter" } })
local registry = require("mason-registry")
-- mason-lspconfig skips its ensure_installed step in headless mode, so run it explicitly
registry.refresh(vim.schedule_wrap(function()
  require("mason-lspconfig.features.ensure_installed")()
end))
local function mason_pending()
  local installing = 0
  for _, package in ipairs(registry.get_all_packages()) do
    if package:is_installing() then
      installing = installing + 1
    end
  end
  local installed = #registry.get_installed_package_names()
  io.stdout:write(("\rMason: %d installed, %d in progress   "):format(installed, installing))
  return installing
end
vim.wait(30000, function()
  return mason_pending() > 0
end, 500)
vim.wait(1800000, function()
  return mason_pending() == 0
end, 1000)
io.stdout:write("\n")
local treesitter = require("lazy.core.config").plugins["nvim-treesitter"]
local parsers = require("lazy.core.plugin").values(treesitter, "opts", false).ensure_installed
require("nvim-treesitter").install(parsers):wait(1800000)
vim.cmd("qa!")
