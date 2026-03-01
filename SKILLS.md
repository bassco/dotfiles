# SKILLS.md — common tasks and tools

## Setup & Bootstrap

```bash
# First-time setup (pick your roles)
./setup.sh base macos home        # home macOS
./setup.sh base macos work        # work macOS
./setup.sh base linux             # Linux / WSL2

# Re-apply after pulling changes (reads saved roles from ~/.machine-role)
./setup.sh

# Preview what would change without applying
./setup.sh --dry-run base macos home
```

## Managing Stow Packages

```bash
# Re-stow a single package manually
stow --restow --dir=$HOME/.dotfiles --target=$HOME zsh

# Stow a package with a custom target
stow --restow --dir=$HOME/.dotfiles --target=$HOME/.config/ghostty ghostty

# Import an existing config file into the repo
mkdir pkg && touch pkg/.configfile
stow --adopt pkg
```

## Adding a New Config Package

1. Create a directory mirroring the home-directory layout:
   ```bash
   mkdir -p my-tool/.config/my-tool
   cp ~/.config/my-tool/config.toml my-tool/.config/my-tool/
   ```
2. Add the package name to `ROLE_PACKAGES` in `setup.sh`
3. If the target isn't `$HOME`, add it to `STOW_TARGET` in `setup.sh`
4. Run `./setup.sh` to apply

## Homebrew

```bash
# Install packages for specific roles
./installs/brew-install.sh base
./installs/brew-install.sh base macos home

# Edit Brewfiles directly
# installs/Brewfile         — base CLI tools (all platforms)
# installs/Brewfile.macos   — macOS casks and formulae
# installs/Brewfile.home    — personal apps + Mac App Store
# installs/Brewfile.work    — work tools (gitignored)
# installs/Brewfile.linux   — linux-specific packages
```

## macOS Defaults

```bash
# Apply system defaults (keyboard repeat, screenshots, etc.)
./installs/macos-defaults.sh
```

## Mise (Tool Versions)

```bash
mise install              # install tools from config
mise ls                   # list installed versions
mise use node@20          # set a tool version
# Base config:    mise/.config/mise/config.toml
# Work overlay:   overlays/mise-config.work.toml → ~/.config/mise/config.local.toml
```

## Git Workflow

```bash
# Commit style: lowercase imperative
git commit -m "add starship config"
git commit -m "remove kitty config and clean up broken symlinks"
git commit -m "move mise work config to overlays"

# Git config uses conditional includes:
#   ~/dev/github/ → .gitconfig-personal
#   ~/dev/gitlab/ → .gitconfig-work (if exists)
```

## Shell & Terminal

```bash
# Reload shell config
source ~/.zshrc

# Shell history search (atuin + fzf)
# Ctrl+R — atuin widget
# Ctrl+E — atuin search

# Fuzzy find (fzf)
# Ctrl+T — file search
# Alt+C  — cd into directory
```

## Secrets

```bash
# Store secrets in ~/.secrets (sourced by .zshenv/.bashrc, gitignored)
echo 'export API_KEY="..."' >> ~/.secrets

# Per-package secrets use **/.secrets pattern (also gitignored)
```

## Key Tool Configs in This Repo

| Tool | Config location | Notes |
|------|----------------|-------|
| zsh | `zsh/.zshrc`, `.zshenv`, `.zprofile` | role overlays via `.zshrc-local` |
| git | `git/.gitconfig` | delta pager, GPG signing |
| neovim | `nvim/.config/nvim/` | LazyVim-based |
| tmux | `tmux/.tmux.conf` | vi keys, mouse, base-index 1 |
| starship | `starship/.config/starship.toml` | prompt theming |
| ripgrep | `ripgrep/.ripgreprc` | hidden files, smart-case |
| ghostty | `ghostty/config` | Catppuccin Mocha theme |
| atuin | `atuin/config.toml` | encrypted history sync |
| mise | `mise/.config/mise/config.toml` | node, python, rust, fzf |
| lazygit | `lazygit/.config/lazygit/config.yml` | git TUI |
| aerospace | `aerospace/.config/aerospace/` | tiling WM (home) |
| claude | `claude/.claude/settings.json` | Claude CLI settings |

## Windows / WSL2

```bash
# Windows host: run in elevated PowerShell
.\installs\choco-install.ps1

# WSL2: bootstrap inside the distro
./installs/wsl-setup.sh
```
