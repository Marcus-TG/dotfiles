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
    lazygit lazydocker \
    colima docker docker-compose

  brew install --cask ghostty
}

install_linux() {
  echo "Linux detected..."

  yay -S --needed eza bat zoxide starship atuin yazi fastfetch \
    lazygit lazydocker \
    docker docker-compose ghostty
}

symlink_configs() {
  echo "Symlinking configs..."

  # Zsh
  [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup
  ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc

  # Nvim (only if config exists in dotfiles)
  if [ -d $DOTFILES/nvim ]; then
    ln -sf $DOTFILES/nvim ~/.config/nvim
  fi
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
