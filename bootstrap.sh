#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> This script needs sudo. Enter your password:"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools (accept the GUI prompt)"
  xcode-select --install
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile"
brew bundle --file=./Brewfile

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

echo "==> Installing latest Node via Volta"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
volta install node@latest

if ! grep -q 'VOLTA_HOME' "$HOME/.zshrc" 2>/dev/null; then
  echo "==> Adding Volta to ~/.zshrc"
  cat >> "$HOME/.zshrc" <<'EOF'

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
EOF
fi

echo "==> Done. Open a new shell so volta/asdf/brew are on PATH."
