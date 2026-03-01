# detect and activate Homebrew (macOS Apple Silicon, macOS Intel, or Linuxbrew)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# activate mise version manager if available
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
