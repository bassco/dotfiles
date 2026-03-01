# dotfiles

Role-based dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Directory layout

```
.dotfiles/
├── setup.sh              # role-based stow + install orchestrator
├── zsh/                  # base shell config (.zshrc, .zshenv, .zprofile)
│   ├── .zshrc-work       # work overlay (sourced as ~/.zshrc-local)
│   ├── .zshrc-home       # home overlay (sourced as ~/.zshrc-local)
│   ├── .zshenv-work      # work env vars (sourced as ~/.zshenv-local)
│   └── ...
├── bash/                 # base: bash config
├── git/                  # base: git config
├── nvim/                 # base: neovim config
├── tmux/                 # base: tmux config
├── starship/             # base: starship prompt
├── ripgrep/              # base: ripgrep config
├── atuin/                # base: atuin shell history
├── common/               # base: .hushlogin, etc.
├── gpg/                  # base: gnupg config
├── ghostty/              # macos: ghostty terminal
├── aerospace/            # home: aerospace window manager
├── hammerspoon/          # home: hammerspoon automation
├── archey4/              # home: system info display
├── cspell/               # base: cspell spell checking config
├── vscode/               # work: vscode settings
├── terraform/            # work: terraform config
└── installs/
    ├── brew-install.sh   # role-aware Homebrew bundle installer
    ├── brew-dump.sh      # dump current brew state into a role Brewfile
    ├── Brewfile           # base: cross-platform CLI tools
    ├── Brewfile.macos     # macos: macOS casks and formulae
    ├── Brewfile.home      # home: personal apps and Mac App Store
    ├── Brewfile.work      # work: work-specific tools (gitignored)
    ├── Brewfile.linux     # linux: linux-specific packages
    ├── choco-install.ps1  # windows: native apps via Chocolatey
    ├── wsl-setup.sh       # windows: WSL2 bootstrap script
    ├── macos-defaults.sh  # macos: system defaults
    └── ...
```

## Roles

| Role        | Packages                                                                  | Machines     |
| ----------- | ------------------------------------------------------------------------- | ------------ |
| **base**    | zsh, bash, git, nvim, tmux, starship, ripgrep, atuin, common, gpg, cspell | all          |
| **macos**   | ghostty, macOS defaults, Brewfile.macos                                   | all macOS    |
| **home**    | aerospace, hammerspoon, archey4, Brewfile.home                            | home macOS   |
| **work**    | vscode, terraform, Brewfile.work                                          | work macOS   |
| **linux**   | Brewfile.linux                                                            | Linux / WSL2 |
| **windows** | choco-install.ps1 (native apps)                                           | Windows host |

## Setup

### Home macOS machine

```console
xcode-select --install
sudo xcodebuild -license accept
git clone https://github.com/bassco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh base macos home
```

### Work macOS machine

```console
xcode-select --install
git clone https://github.com/bassco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh base macos work
```

### Linux machine

```console
git clone https://github.com/bassco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/installs
./wsl-setup.sh       # or manually: install linuxbrew, then ../setup.sh base linux
```

### Windows (WSL2)

1. Run `installs/choco-install.ps1` in elevated PowerShell for native apps
2. Open WSL2 Debian/Ubuntu:

```console
git clone https://github.com/bassco/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/installs
./wsl-setup.sh
```

### Re-applying after updates

```console
cd ~/.dotfiles && git pull
./setup.sh            # re-applies saved roles from ~/.machine-role
```

## Syncing Brewfiles from an existing machine

To capture what's currently installed via Homebrew and update the role-specific Brewfile:

```console
cd ~/.dotfiles/installs

# preview what would be written
./brew-dump.sh --dry-run work

# update the Brewfile for your role
./brew-dump.sh work    # on your work machine
./brew-dump.sh linux   # on your linux machine
./brew-dump.sh home    # on your home machine
```

The script runs `brew bundle dump`, subtracts packages already in the shared Brewfiles (base + macos), and writes only role-specific entries to the target Brewfile.

## Spell checking (cspell)

cspell provides spell checking in neovim via nvim-lint with role-based word lists.

### Word lists

| File                              | Scope             | Machines       |
| --------------------------------- | ----------------- | -------------- |
| `~/.config/cspell/base-words.txt` | shared vocabulary | all            |
| `~/.config/cspell/work-words.txt` | work jargon       | work (overlay) |
| `~/.config/cspell/home-words.txt` | personal terms    | home (overlay) |

### Adding words in neovim

- Place cursor on an unknown word and press `<leader>cw`
- Choose **global** (appends to `base-words.txt`) or **project** (creates/updates `cspell.json` in cwd)

### Per-project dictionaries

Any project can have its own `cspell.json` at the root. cspell merges project words with the global config automatically.

## Importing a config file

```console
mkdir zsh
touch zsh/.aliases
stow --adopt zsh
```

This symlinks `~/.aliases` into the repo under the `zsh/` folder.

## Manual settings

### Remap Caps Lock to Escape

#### macOS

1. System Settings > Accessibility > Keyboard > enable **Keyboard Navigation**
2. System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys > set **Caps Lock** to **Escape**

#### Linux (Ubuntu/Debian)

Install [interception-tools](https://gitlab.com/interception/linux/tools) and [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc):

```console
sudo apt install interception-tools interception-caps2esc
```

Create `/etc/interception/udevmon.d/caps2esc.yaml`:

```yaml
- JOB: intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
```

Enable and start the service:

```console
sudo systemctl enable --now udevmon
```
