#!/bin/bash

DOTFILES="$HOME/dotfiles"

install_mac() {
  echo "macOS detected..."

  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew install eza bat zoxide starship atuin yazi fastfetch \
    tree-sitter-cli \
    lazygit lazydocker \
    colima docker docker-compose

  brew install --cask ghostty
}

install_arch() {
  echo "Arch detected..."

  yay -S --needed eza bat zoxide starship atuin yazi fastfetch \
    tree-sitter-cli \
    lazygit lazydocker \
    docker docker-compose ghostty
}

install_ubuntu() {
  echo "Ubuntu/Debian detected..."

  sudo apt-get update

  # Packages available in apt (Ubuntu 24.04+). On Debian/older Ubuntu some of
  # these may be missing; --no-install-recommends keeps the set minimal and we
  # tolerate individual misses below.
  sudo apt-get install -y \
    curl git unzip build-essential \
    bat eza zoxide fastfetch \
    docker.io docker-compose

  # bat installs as `batcat` on Debian/Ubuntu; expose it as `bat`.
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf "$(command -v batcat)" ~/.local/bin/bat
  fi

  # starship — official installer (not packaged in apt).
  if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  fi

  # atuin — official installer.
  if ! command -v atuin &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  fi

  # yazi, tree-sitter-cli, lazygit, lazydocker are not reliably in apt.
  # Install via cargo (yazi, tree-sitter) and GitHub release tarballs (the TUIs).
  if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
  fi
  command -v yazi &>/dev/null || cargo install --locked yazi-fm yazi-cli
  command -v tree-sitter &>/dev/null || cargo install --locked tree-sitter-cli

  install_github_binary lazygit jesseduffield/lazygit lazygit
  install_github_binary lazydocker jesseduffield/lazydocker lazydocker

  echo "Note: ghostty has no apt package — install from https://ghostty.org/download"
}

# install_github_binary <command> <owner/repo> <binary-name-in-tarball>
# Fetches the latest release tarball matching this machine's arch and drops the
# binary into ~/.local/bin.
install_github_binary() {
  local cmd="$1" repo="$2" bin="$3"
  command -v "$cmd" &>/dev/null && return 0

  local arch
  case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *) echo "Skipping $cmd: unsupported arch $(uname -m)"; return 0 ;;
  esac

  local url
  url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
    | grep -o "https://[^\"]*Linux_${arch}\.tar\.gz" | head -n1)
  if [ -z "$url" ]; then
    echo "Skipping $cmd: no release asset for Linux_${arch}"
    return 0
  fi

  echo "Installing $cmd from $repo..."
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" | tar -xz -C "$tmp" "$bin"
  mkdir -p ~/.local/bin
  install "$tmp/$bin" ~/.local/bin/"$bin"
  rm -rf "$tmp"
}

install_linux() {
  echo "Linux detected..."

  local distro=""
  [ -f /etc/os-release ] && distro=$(. /etc/os-release && echo "$ID $ID_LIKE")

  case "$distro" in
    *arch*) install_arch ;;
    *ubuntu* | *debian*) install_ubuntu ;;
    *)
      if command -v pacman &>/dev/null; then
        install_arch
      elif command -v apt-get &>/dev/null; then
        install_ubuntu
      else
        echo "Unsupported Linux distro: $distro"
        exit 1
      fi
      ;;
  esac
}

symlink_configs() {
  echo "Symlinking configs..."

  # Zsh
  [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup
  ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc

  # Git
  [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.backup
  ln -sf $DOTFILES/git/.gitconfig ~/.gitconfig

  # Nvim (only if config exists in dotfiles)
  if [ -d $DOTFILES/nvim ]; then
    ln -sf $DOTFILES/nvim ~/.config/nvim
  fi

  # Ghostty
  if [ -d $DOTFILES/ghostty ]; then
    ln -sf $DOTFILES/ghostty ~/.config/ghostty
  fi

  # Starship
  if [ -f $DOTFILES/starship/starship.toml ]; then
    ln -sf $DOTFILES/starship/starship.toml ~/.config/starship.toml
  fi

  # bat
  if [ -d $DOTFILES/bat ]; then
    [ -e ~/.config/bat ] && [ ! -L ~/.config/bat ] && mv ~/.config/bat ~/.config/bat.backup
    ln -sfn $DOTFILES/bat ~/.config/bat
  fi

  # AI assistant global instructions. The parent dir only exists once the tool
  # has run at least once, so create it before linking.
  link_ai_config() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
  }
  [ -f $DOTFILES/ai/claude/CLAUDE.md ] && link_ai_config "$DOTFILES/ai/claude/CLAUDE.md" ~/.claude/CLAUDE.md
  [ -f $DOTFILES/ai/codex/AGENTS.md ] && link_ai_config "$DOTFILES/ai/codex/AGENTS.md" ~/.codex/AGENTS.md
  [ -f $DOTFILES/ai/gemini/GEMINI.md ] && link_ai_config "$DOTFILES/ai/gemini/GEMINI.md" ~/.gemini/GEMINI.md
}

# Detect OS and install
if [[ "$OSTYPE" == "darwin"* ]]; then
  install_mac
elif [[ "$OSTYPE" == "linux"* ]]; then
  install_linux
else
  echo "Unsupported OS"
  exit 1
fi

symlink_configs

echo "Done!"
