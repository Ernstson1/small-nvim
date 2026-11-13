# nvim-small

A small, standalone Neovim config (no LazyVim) for VMs and containers. A trimmed-down version of my [nvim-config](https://github.com/Ernstson1/nvim-config), keeping the same keymaps.

## Install

### Linux (apt, dnf or pacman)

```bash
git clone https://github.com/Ernstson1/nvim-small.git
cd nvim-small
./install.sh            # add --java and/or --dotnet for those LSPs
```

The script installs system packages (git, ripgrep, node, python, a C compiler, clangd), the latest Neovim and tree-sitter CLI, and optionally a JDK and the .NET SDK. It links the repo to `~/.config/nvim` (backing up any existing config to `~/.config/nvim.bak.<date>`), then installs plugins, language servers and treesitter parsers. It needs `sudo` unless run as root.

### macOS

```bash
brew install neovim ripgrep node python tree-sitter-cli
git clone https://github.com/Ernstson1/nvim-small.git ~/.config/nvim
```

To try it next to another config: clone to `~/.config/nvim-small` and run `NVIM_APPNAME=nvim-small nvim`.

## What's in it

One file per topic in `lua/plugins/`:

| File | Plugins |
|---|---|
| `colorscheme.lua` | gruvbox-material (soft) |
| `treesitter.lua` | nvim-treesitter |
| `lsp.lua` | mason, mason-lspconfig, nvim-lspconfig |
| `completion.lua` | blink.cmp |
| `format.lua` | conform.nvim (format on save) |
| `lint.lua` | nvim-lint (markdown) |
| `neo-tree.lua` | neo-tree |
| `harpoon.lua` | harpoon2 |
| `telescope.lua` | telescope + fzf-native |
| `terminal.lua` | toggleterm |
| `ui.lua` | lualine, which-key, gitsigns |
| `editor.lua` | mini.surround, mini.pairs |

Language servers: basedpyright, ruff, clangd, neocmake, vtsls, eslint, marksman, jsonls, lua_ls, plus jdtls and omnisharp when `java`/`dotnet` are on PATH. Files without a conform formatter format through their LSP.

## Keymaps

| Keys | Action |
|---|---|
| `<leader><space>`, `<leader>ff` | Find files |
| `<leader>/`, `<leader>sg` | Grep |
| `<leader>fb` / `fr` | Buffers / recent files |
| `<leader>e` / `<leader>fo` | Toggle / focus Neo-tree |
| `<leader>H` / `<leader>h` / `<leader>1-9` | Harpoon add / menu / jump |
| `<C-t>`, `<leader>t1-4` | Terminals |
| `gd`, `gr`, `gI`, `K` | Definition, references, implementation, hover |
| `<leader>ca` / `cr` / `cf` / `cd` | Code action / rename / format / line diagnostics |
| `<leader>bn/bp/bx/bo/bb` | Next / previous / close / close others / last buffer |
| `]h`, `[h`, `<leader>gh*` | Git hunks |
| `gsa`, `gsd`, `gsr` | Add / delete / replace surrounding |

The arrow keys are disabled in normal and visual mode. Use `hjkl`.

## License

[Apache License 2.0](LICENSE).
