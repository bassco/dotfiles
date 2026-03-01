# CLAUDE.md — dotfiles repo

## What this repo is

Role-based dotfiles managed with GNU Stow. Each top-level directory is a stow package that gets symlinked into `$HOME` (or a custom target). `setup.sh` orchestrates stowing, overlay symlinks, and install scripts per role.

## Repo structure

- **Stow packages** — top-level dirs (`zsh/`, `git/`, `nvim/`, `tmux/`, etc.) contain config files mirroring their home-directory layout
- **`overlays/`** — role-specific config files symlinked to custom destinations (not stowed)
- **`installs/`** — Brewfiles, install scripts, and system defaults per role/platform
- **`setup.sh`** — the main entry point; takes roles (`base`, `macos`, `home`, `work`, `linux`, `windows`) and stows the right packages, links overlays, and runs install scripts

## Roles

- **base** — zsh, bash, git, nvim, tmux, starship, ripgrep, atuin, common, gpg, claude, mise, lazygit
- **macos** — ghostty + macOS defaults
- **home** — archey4, zed
- **work** — vscode, terraform

## Key conventions

- Each stow package directory mirrors the target directory structure (usually `$HOME`)
- Packages with non-`$HOME` targets are listed in `STOW_TARGET` in `setup.sh`
- Role overlays (in `ROLE_OVERLAYS`) use `source:destination` format
- Roles are saved to `~/.machine-role` on first run; `./setup.sh` with no args re-applies them
- Secrets go in `**/.secrets` files (gitignored)

## Working with this repo

- **Adding a new config**: create a directory, mirror the home-dir layout inside it, add it to `ROLE_PACKAGES` in `setup.sh`
- **Importing an existing config**: `mkdir pkg && touch pkg/.file && stow --adopt pkg`
- **Testing changes**: `./setup.sh --dry-run base macos home`
- **Re-applying**: `cd ~/.dotfiles && ./setup.sh`

## Git conventions

- Use lowercase imperative commit messages (e.g. "add zed config", "remove kitty config")
- Keep commits focused — one logical change per commit
