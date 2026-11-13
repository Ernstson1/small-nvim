#!/usr/bin/env bash
# Sets up this Neovim config on a fresh Linux machine (apt, dnf or pacman).
# Usage: ./install.sh [--java] [--dotnet]
set -euo pipefail

if [[ "$(uname -s)" != Linux ]]; then
  echo "install.sh is for Linux. On macOS, see README.md." >&2
  exit 1
fi

java=false
dotnet=false
for arg in "$@"; do
  case "$arg" in
    --java) java=true ;;
    --dotnet) dotnet=true ;;
    *) echo "Unknown option: $arg (expected --java and/or --dotnet)" >&2; exit 1 ;;
  esac
done

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
opt_dir="$HOME/.local/opt"
sudo=""
[[ $EUID -ne 0 ]] && sudo="sudo"

case "$(uname -m)" in
  x86_64) arch=x86_64 treesitter_arch=x64 ;;
  aarch64 | arm64) arch=arm64 treesitter_arch=arm64 ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

step_name=""
step() {
  step_name="$1"
  printf '\n==> %s\n' "$step_name"
}
trap 'echo "install.sh failed during: $step_name. Fix the error above and re-run; finished steps are skipped." >&2' ERR

latest_tag() { # GitHub redirects /releases/latest to /releases/tag/<tag>; avoids the rate-limited API
  curl -fsSLo /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest" | sed 's|.*/||'
}

step "System packages"
# Mason needs node (npm), python (pypi) and unzip; nvim-treesitter and telescope-fzf-native need a C compiler and make.
# clangd comes from the distro because Mason has no Linux arm64 build of it.
if command -v apt-get >/dev/null; then
  packages=(ca-certificates git curl tar gzip unzip build-essential ripgrep python3 python3-venv python3-pip nodejs npm clangd)
  $java && packages+=(openjdk-25-jdk-headless)
  $dotnet && packages+=(libicu-dev)
  $sudo apt-get update
  $sudo apt-get install -y --no-install-recommends "${packages[@]}"
elif command -v dnf >/dev/null; then
  packages=(git curl tar gzip unzip gcc gcc-c++ make ripgrep python3 python3-pip nodejs npm clang-tools-extra)
  $java && packages+=(java-25-openjdk-devel)
  $dotnet && packages+=(libicu)
  $sudo dnf install -y "${packages[@]}"
elif command -v pacman >/dev/null; then
  packages=(git curl tar gzip unzip base-devel ripgrep python python-pip nodejs npm clang)
  $java && packages+=(jdk-openjdk)
  $dotnet && packages+=(icu)
  $sudo pacman -Syu --needed --noconfirm "${packages[@]}"
else
  echo "No supported package manager (apt, dnf, pacman) found." >&2
  exit 1
fi

mkdir -p "$opt_dir"

step "Neovim (latest stable)"
# Distro packages are often older than nvim-treesitter's minimum (0.12), so use the official release
nvim_version="$(latest_tag neovim/neovim)"
if [[ "$("$opt_dir/nvim/bin/nvim" --version 2>/dev/null | head -1)" == "NVIM $nvim_version" ]]; then
  echo "Neovim $nvim_version is already installed"
else
  rm -rf "$opt_dir/nvim"
  mkdir -p "$opt_dir/nvim"
  curl -fL --progress-bar "https://github.com/neovim/neovim/releases/download/$nvim_version/nvim-linux-$arch.tar.gz" |
    tar -xz -C "$opt_dir/nvim" --strip-components=1
fi
# /usr/local/bin comes before /usr/bin in every shell's default PATH, so a distro nvim can't shadow this one
$sudo ln -sf "$opt_dir/nvim/bin/nvim" /usr/local/bin/nvim

step "tree-sitter CLI (latest)"
# nvim-treesitter compiles parsers with it; distro versions are too old and npm's is unsupported
treesitter_version="$(latest_tag tree-sitter/tree-sitter)"
if [[ "$("$opt_dir/tree-sitter" --version 2>/dev/null)" == "tree-sitter ${treesitter_version#v}"* ]]; then
  echo "tree-sitter $treesitter_version is already installed"
else
  curl -fL --progress-bar "https://github.com/tree-sitter/tree-sitter/releases/download/$treesitter_version/tree-sitter-linux-$treesitter_arch.gz" |
    gunzip >"$opt_dir/tree-sitter"
  chmod +x "$opt_dir/tree-sitter"
fi
$sudo ln -sf "$opt_dir/tree-sitter" /usr/local/bin/tree-sitter

if $dotnet; then
  step ".NET SDK (LTS)"
  # dotnet-install.sh skips the download when this version is already installed
  curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir "$HOME/.dotnet"
  # shellcheck disable=SC2016 # $HOME/$PATH must expand when the rc file runs, not now
  path_block='# >>> small-nvim >>>
export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"
export DOTNET_ROOT="$HOME/.dotnet"
# <<< small-nvim <<<'
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [[ -f "$rc" || "$rc" == "$HOME/.bashrc" ]] || continue
    grep -q '>>> small-nvim >>>' "$rc" 2>/dev/null || printf '\n%s\n' "$path_block" >>"$rc"
  done
  export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"
  export DOTNET_ROOT="$HOME/.dotnet"
fi

step "Link config to ~/.config/nvim"
config_dir="$HOME/.config/nvim"
if [[ "$(realpath "$config_dir" 2>/dev/null)" != "$repo_dir" ]]; then
  if [[ -e "$config_dir" || -L "$config_dir" ]]; then
    backup="$config_dir.bak.$(date +%Y%m%d%H%M%S)"
    echo "Moving existing $config_dir to $backup"
    mv "$config_dir" "$backup"
  fi
  mkdir -p "$HOME/.config"
  ln -s "$repo_dir" "$config_dir"
fi

step "Plugins (versions from lazy-lock.json)"
nvim --headless "+Lazy! restore" +qa

step "Language servers, formatters and treesitter parsers"
# jdtls/omnisharp are only installed when java/dotnet are on PATH (see lua/plugins/lsp.lua)
nvim --headless "+luafile $repo_dir/install-tools.lua"

echo
echo "Done. Run nvim."
if $dotnet; then
  echo "Open a new shell (or 'source ~/.bashrc') first so dotnet is on PATH."
fi
