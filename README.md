# small-nvim

A lightweight, standalone Neovim config for VMs and containers. A trimmed-down version of my [nvim-config](https://github.com/Ernstson1/nvim-config) with the same keymaps.

## Install

Linux (apt, dnf or pacman):

```bash
git clone https://github.com/Ernstson1/small-nvim.git
cd small-nvim
./install.sh            # add --java and/or --dotnet for those LSPs
```

This installs Neovim, the tree-sitter CLI and system packages, links the repo to `~/.config/nvim` (backing up any existing config), then installs plugins, language servers and parsers.

macOS:

```bash
brew install neovim ripgrep node python tree-sitter-cli
git clone https://github.com/Ernstson1/small-nvim.git ~/.config/nvim
```

## What's in it

lazy.nvim, gruvbox-material, treesitter, Mason + native LSP, blink.cmp, conform (format on save), nvim-lint, telescope, neo-tree, harpoon2, toggleterm, lualine, which-key, gitsigns, mini.surround and mini.pairs. One file per topic in `lua/plugins/`.

LSPs: Python, C/C++, CMake, JS/TS, Markdown, JSON and Lua, plus Java and C# when `java`/`dotnet` are installed.

## License

[Apache License 2.0](LICENSE).
