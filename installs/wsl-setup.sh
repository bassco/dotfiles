#!/usr/bin/env bash
set -euo pipefail

# Bootstrap WSL2 Debian/Ubuntu environment
# Run inside WSL after Windows setup:
#   bash installs/wsl-setup.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "── Installing system packages ──"
sudo apt-get update
sudo apt-get install -y build-essential curl git

echo "── Installing Linuxbrew ──"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "── Running dotfiles setup ──"
bash "$DOTFILES_DIR/setup.sh" base linux
