#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── install Homebrew if missing ──────────────────────────────────
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ── role → Brewfile mapping (case-based for bash 3 compatibility) ─
brewfile_for_role() {
	case "$1" in
	base) echo "Brewfile" ;;
	macos) echo "Brewfile.macos" ;;
	home) echo "Brewfile.home" ;;
	work) echo "Brewfile.work" ;;
	linux) echo "Brewfile.linux" ;;
	*) echo "" ;;
	esac
}

# ── install bundles for requested roles ──────────────────────────
if [[ $# -eq 0 ]]; then
	echo "Usage: brew-install.sh <role> [role...]"
	echo "Roles: base, macos, home, work, linux"
	echo ""
	echo "Installing base Brewfile only..."
	set -- base
fi

for role in "$@"; do
	brewfile="$(brewfile_for_role "$role")"
	if [[ -z "$brewfile" ]]; then
		echo "  warning: no Brewfile for role '$role', skipping"
		continue
	fi

	filepath="$SCRIPT_DIR/$brewfile"
	if [[ ! -f "$filepath" ]]; then
		echo "  warning: $filepath not found, skipping"
		continue
	fi

	echo "── brew bundle: $brewfile ($role) ──"

	# diff installed packages against the bundle — only install what's missing
	# --no-upgrade skips upgrading already-installed packages (fast on existing machines)
	missing=$(brew bundle check --file="$filepath" --verbose 2>&1 | grep "^→" || true)

	if [[ -z "$missing" ]]; then
		echo "  all packages already installed, skipping"
		continue
	fi

	echo "  installing missing packages:"
	echo "$missing" | sed 's/^→ /    + /' | sed 's/ needs to be.*//'

	brew bundle install --file="$filepath" --no-upgrade
done
