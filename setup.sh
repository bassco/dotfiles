#!/usr/bin/env zsh
set -euo pipefail

# Usage: ./setup.sh <role> [role...]
# Examples:
#   ./setup.sh base macos home    # home macOS machine
#   ./setup.sh base macos work    # work macOS machine
#   ./setup.sh base linux         # Linux machine
#   ./setup.sh base linux         # WSL2 (run inside WSL)
#
# On subsequent runs, calling ./setup.sh with no args re-applies
# the roles saved in ~/.machine-role from the first run.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ROLE_FILE="$HOME/.machine-role"

# ── role → stow packages mapping ────────────────────────────────
declare -A ROLE_PACKAGES=(
  [base]="zsh bash git nvim tmux starship ripgrep atuin common gpg claude mise lazygit cspell"
  [macos]="ghostty"
  [home]="archey4 zed"
  [work]="vscode terraform"
  [linux]=""
  [windows]=""
)

# ── packages that need a custom stow target ─────────────────────
declare -A STOW_TARGET=(
  [archey4]="$HOME/.config/archey4"
  [atuin]="$HOME/.config/atuin"
  [ghostty]="$HOME/.config/ghostty"
  [cspell]="$HOME/.config/cspell"
)

# ── overlay files to symlink for each role ──────────────────────
# format: "source_relative_to_dotfiles:destination_relative_to_home"
declare -A ROLE_OVERLAYS=(
  [work]="zsh/.zshrc-work:.zshrc-local zsh/.zshenv-work:.zshenv-local overlays/mise-config.work.toml:.config/mise/config.local.toml overlays/cspell-work-words.txt:.config/cspell/work-words.txt"
  [home]="zsh/.zshrc-home:.zshrc-local overlays/cspell-home-words.txt:.config/cspell/home-words.txt"
)

# ── helpers ──────────────────────────────────────────────────────

usage() {
  cat <<USAGE
Usage: $(basename "$0") [--dry-run] <role> [role...]

Roles: base, macos, home, work, linux, windows
  base   — core shell, editor, and CLI tools (all machines)
  macos  — macOS-specific apps and settings
  home   — personal/home machine packages
  work   — work machine packages
  linux  — Linux-specific packages
  windows — Windows native apps (run outside WSL)

If called with no roles, re-applies roles from ~/.machine-role.
USAGE
  exit 1
}

stow_package() {
  local pkg="$1"
  local target="${STOW_TARGET[$pkg]:-$HOME}"
  local flags=("--restow" "--dir=$DOTFILES_DIR" "--target=$target")

  if [[ "$target" != "$HOME" ]]; then
    mkdir -p "$target"
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    flags+=("--simulate" "--verbose")
  fi

  echo "  stow $pkg → $target"
  stow "${flags[@]}" "$pkg"
}

link_overlay() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$2"

  if [[ ! -f "$src" ]]; then
    echo "  warning: overlay source $src not found, skipping"
    return
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    echo "  would link $dst → $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -f "$dst" ]]; then
    echo "  warning: $dst exists and is not a symlink, skipping"
    return
  fi

  ln -s "$src" "$dst"
  echo "  link $dst → $src"
}

run_installs() {
  local role="$1"

  if [[ "$DRY_RUN" == "1" ]]; then
    echo "  would run installs for role: $role"
    return
  fi

  case "$role" in
    base)
      if [[ -f "$DOTFILES_DIR/installs/brew-install.sh" ]]; then
        echo "  running brew-install.sh (base)..."
        bash "$DOTFILES_DIR/installs/brew-install.sh" base
      fi
      echo "  installing mise tools..."
      mise install 2>/dev/null || echo "  warning: mise not found, skipping tool installs"
      echo "  installing neovim providers..."
      uv pip install --system neovim 2>/dev/null || echo "  warning: uv not found, skipping python neovim provider"
      npm install -g neovim 2>/dev/null || echo "  warning: npm not found, skipping node neovim provider"
      ;;
    macos)
      if [[ -f "$DOTFILES_DIR/installs/brew-install.sh" ]]; then
        bash "$DOTFILES_DIR/installs/brew-install.sh" macos
      fi
      if [[ -f "$DOTFILES_DIR/installs/macos-defaults.sh" ]]; then
        echo "  running macos-defaults.sh..."
        bash "$DOTFILES_DIR/installs/macos-defaults.sh"
      fi
      ;;
    home)
      if [[ -f "$DOTFILES_DIR/installs/brew-install.sh" ]]; then
        bash "$DOTFILES_DIR/installs/brew-install.sh" home
      fi
      ;;
    work)
      if [[ -f "$DOTFILES_DIR/installs/brew-install.sh" ]]; then
        bash "$DOTFILES_DIR/installs/brew-install.sh" work
      fi
      ;;
    linux)
      if [[ -f "$DOTFILES_DIR/installs/brew-install.sh" ]]; then
        bash "$DOTFILES_DIR/installs/brew-install.sh" linux
      fi
      ;;
    windows)
      if [[ -f "$DOTFILES_DIR/installs/choco-install.ps1" ]]; then
        echo "  note: run installs/choco-install.ps1 in PowerShell for native Windows apps"
      fi
      ;;
  esac
}

# ── main ─────────────────────────────────────────────────────────

DRY_RUN=0
ROLES=()

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help|-h) usage ;;
    *) ROLES+=("$arg") ;;
  esac
done

# no roles given — try to read from ~/.machine-role
if [[ ${#ROLES[@]} -eq 0 ]]; then
  if [[ -f "$ROLE_FILE" ]]; then
    read -A ROLES < "$ROLE_FILE"
    echo "Re-applying saved roles: ${ROLES[*]}"
  else
    echo "No roles specified and $ROLE_FILE not found."
    usage
  fi
fi

# validate roles
for role in "${ROLES[@]}"; do
  if [[ ! -v ROLE_PACKAGES[$role] ]]; then
    echo "Error: unknown role '$role'"
    usage
  fi
done

# auto-prepend base (always) and macos (on darwin) if not already present
if [[ ! " ${ROLES[*]} " == *" base "* ]]; then
  ROLES=("base" "${ROLES[@]}")
fi
if [[ "$OSTYPE" == darwin* && ! " ${ROLES[*]} " == *" macos "* ]]; then
  ROLES=("${ROLES[1]}" "macos" "${ROLES[@]:1}")
fi

# save roles for future re-runs
if [[ "$DRY_RUN" == "0" ]]; then
  echo "${ROLES[*]}" > "$ROLE_FILE"
  echo "Saved roles to $ROLE_FILE: ${ROLES[*]}"
fi

# install git hooks
if [[ -d "$DOTFILES_DIR/.git" && -d "$DOTFILES_DIR/hooks" ]]; then
  echo ""
  echo "── git hooks ──"
  for hook in "$DOTFILES_DIR/hooks/"*; do
    hookname=$(basename "$hook")
    target="$DOTFILES_DIR/.git/hooks/$hookname"
    if [[ "$DRY_RUN" == "1" ]]; then
      echo "  would link $target → $hook"
    else
      ln -sf "$hook" "$target"
      echo "  link $hookname"
    fi
  done
fi

# stow packages and run installs for each role
for role in "${ROLES[@]}"; do
  echo ""
  echo "── role: $role ──"

  # stow packages
  for pkg in ${=ROLE_PACKAGES[$role]}; do
    stow_package "$pkg"
  done

  # link overlays
  if [[ -v ROLE_OVERLAYS[$role] ]]; then
    for mapping in ${=ROLE_OVERLAYS[$role]}; do
      IFS=: read src dst <<< "$mapping"
      link_overlay "$src" "$dst"
    done
  fi

  # run install scripts
  run_installs "$role"
done

echo ""
echo "Done! Open a new shell to pick up changes."
