#!/usr/bin/env bash
set -euo pipefail

# Dump current Homebrew state and update a role-specific Brewfile,
# excluding packages already declared in base/shared Brewfiles.
#
# Usage:
#   brew-dump.sh <role>        # e.g. work, home, linux
#   brew-dump.sh --dry-run <role>  # preview without writing

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── flags ─────────────────────────────────────────────────────────
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  shift
fi

ROLE="${1:-}"
if [[ -z "$ROLE" ]]; then
  echo "Usage: brew-dump.sh [--dry-run] <role>"
  echo "Roles: work, home, linux"
  exit 1
fi

# ── role → Brewfile + which shared files to subtract ──────────────
declare -A ROLE_BREWFILE=(
  [home]="Brewfile.home"
  [work]="Brewfile.work"
  [linux]="Brewfile.linux"
)

# shared Brewfiles whose entries should be excluded from the role dump
declare -A ROLE_SHARED=(
  [home]="Brewfile Brewfile.macos"
  [work]="Brewfile Brewfile.macos"
  [linux]="Brewfile"
)

TARGET="${ROLE_BREWFILE[$ROLE]:-}"
if [[ -z "$TARGET" ]]; then
  echo "Error: unknown role '$ROLE'"
  echo "Valid roles: ${!ROLE_BREWFILE[*]}"
  exit 1
fi

TARGET_PATH="$SCRIPT_DIR/$TARGET"

# ── dump current brew state to a temp file ────────────────────────
DUMP=$(mktemp)
trap 'rm -f "$DUMP"' EXIT

echo "Dumping current Homebrew installation..."
brew bundle dump --file="$DUMP" --force

# ── build a set of entries from shared Brewfiles to exclude ───────
# normalises each line to "type<tab>name" for matching
normalise() {
  # strip comments, blank lines, and trailing options (link: false, etc.)
  sed -E \
    -e 's/#.*$//' \
    -e '/^[[:space:]]*$/d' \
    -e 's/,[[:space:]]+link:.*$//' \
    -e 's/"[[:space:]]*$//' \
    -e 's/^(tap|brew|cask|mas)[[:space:]]+"?/\1\t/' \
    -e 's/"$//' \
    "$@"
}

SHARED_ENTRIES=$(mktemp)
trap 'rm -f "$DUMP" "$SHARED_ENTRIES"' EXIT

for shared in ${ROLE_SHARED[$ROLE]}; do
  shared_path="$SCRIPT_DIR/$shared"
  if [[ -f "$shared_path" ]]; then
    normalise "$shared_path" >> "$SHARED_ENTRIES"
  fi
done

# ── filter the dump: remove anything in shared Brewfiles ──────────
FILTERED=$(mktemp)
trap 'rm -f "$DUMP" "$SHARED_ENTRIES" "$FILTERED"' EXIT

while IFS= read -r line; do
  # pass through comments and blank lines
  if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line// /}" ]]; then
    continue
  fi

  # normalise this line the same way
  norm=$(echo "$line" | normalise /dev/stdin)

  if [[ -z "$norm" ]]; then
    continue
  fi

  # check if this entry exists in shared
  if grep -qxF "$norm" "$SHARED_ENTRIES" 2>/dev/null; then
    continue
  fi

  echo "$line"
done < "$DUMP" > "$FILTERED"

# ── sort into sections ────────────────────────────────────────────
RESULT=$(mktemp)
trap 'rm -f "$DUMP" "$SHARED_ENTRIES" "$FILTERED" "$RESULT"' EXIT

{
  # header comment
  case "$ROLE" in
    work)  echo "# work machine packages" ;;
    home)  echo "# home machine packages — personal macOS machines" ;;
    linux) echo "# Linux-specific packages (Linuxbrew)" ;;
  esac

  # taps
  taps=$(grep '^tap ' "$FILTERED" 2>/dev/null || true)
  if [[ -n "$taps" ]]; then
    echo ""
    echo "# taps"
    echo "$taps" | sort
  fi

  # formulae
  brews=$(grep '^brew ' "$FILTERED" 2>/dev/null || true)
  if [[ -n "$brews" ]]; then
    echo ""
    echo "# formulae"
    echo "$brews" | sort
  fi

  # casks
  casks=$(grep '^cask ' "$FILTERED" 2>/dev/null || true)
  if [[ -n "$casks" ]]; then
    echo ""
    echo "# casks"
    echo "$casks" | sort
  fi

  # mas
  mas_apps=$(grep '^mas ' "$FILTERED" 2>/dev/null || true)
  if [[ -n "$mas_apps" ]]; then
    echo ""
    echo "# Mac App Store"
    echo "$mas_apps" | sort
  fi
} > "$RESULT"

# ── output ────────────────────────────────────────────────────────
echo ""
if $DRY_RUN; then
  echo "── dry run: would write to $TARGET ──"
  echo ""
  cat "$RESULT"
else
  cp "$RESULT" "$TARGET_PATH"
  echo "── updated $TARGET ──"
  echo ""
  cat "$TARGET_PATH"
fi

echo ""
echo "Done. $(grep -c '^[^#]' "$RESULT" 2>/dev/null || echo 0) entries (excluding shared packages)."
