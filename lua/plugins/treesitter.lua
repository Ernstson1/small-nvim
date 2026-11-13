local parsers = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "c_sharp",
  "java",
  "python",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "yaml",
  "toml",
  "html",
  "css",
  "vim",
  "vimdoc",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = { ensure_installed = parsers },
  config = function(_, opts)
    require("nvim-treesitter").install(opts.ensure_installed)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        if pcall(vim.treesitter.start, event.buf) then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
