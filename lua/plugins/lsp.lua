local servers = { "basedpyright", "ruff", "neocmake", "vtsls", "eslint", "marksman", "jsonls", "lua_ls" }
-- Only install servers whose runtime exists (install.sh --java / --dotnet)
if vim.fn.executable("java") == 1 then
  table.insert(servers, "jdtls")
end
if vim.fn.executable("dotnet") == 1 then
  table.insert(servers, "omnisharp")
end

-- Mason has no Linux arm64 clangd; install.sh installs the distro one instead
local linux_arm = vim.uv.os_uname().sysname == "Linux" and vim.uv.os_uname().machine:match("^a") ~= nil
if not linux_arm then
  table.insert(servers, "clangd")
end

local tools = { "prettier", "stylua", "gersemi", "markdownlint-cli2" }

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(tools) do
          local package = registry.get_package(name)
          if not package:is_installed() and not package:is_installing() then
            package:install()
          end
        end
      end)
    end,
  },
  {
    -- Enables every Mason-installed server through vim.lsp.enable, using nvim-lspconfig's lsp/*.lua configs
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = { ensure_installed = servers },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      -- automatic_enable only covers Mason-installed servers, so enable a system clangd explicitly
      if vim.fn.executable("clangd") == 1 then
        vim.lsp.enable("clangd")
      end
    end,
  },
}
