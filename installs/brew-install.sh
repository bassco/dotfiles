#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── install Homebrew if missing ──────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ── role → Brewfile mapping ──────────────────────────────────────
declare -A ROLE_BREWFILE=(
  [base]="Brewfile"
  [macos]="Brewfile.macos"
  [home]="Brewfile.home"
  [work]="Brewfile.work"
  [linux]="Brewfile.linux"
)

# ── install bundles for requested roles ──────────────────────────
ROLES=("$@")

if [[ ${#ROLES[@]} -eq 0 ]]; then
  echo "Usage: brew-install.sh <role> [role...]"
  echo "Roles: base, macos, home, work, linux"
  echo ""
  echo "Installing base Brewfile only..."
  ROLES=("base")
fi

for role in "${ROLES[@]}"; do
  brewfile="${ROLE_BREWFILE[$role]:-}"
  if [[ -z "$brewfile" ]]; then
    echo "Warning: no Brewfile for role '$role', skipping"
    continue
  fi

  filepath="$SCRIPT_DIR/$brewfile"
  if [[ ! -f "$filepath" ]]; then
    echo "Warning: $filepath not found, skipping"
    continue
  fi

  echo "── brew bundle: $brewfile ($role) ──"
  brew bundle install --file="$filepath"
done
