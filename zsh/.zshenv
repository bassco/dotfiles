# common ENV file used by .bashrc and .zshrc
export LANG=en_US.UTF-8

[ -f "$HOME/.cargo/env" ] && { . "$HOME/.cargo/env"; }

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export GPG_TTY=$(tty)

export GIT_PAGER='LESS=FRX less -S +c'
export GIT_EDITOR=${EDITOR}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# silence direnv output
#export DIRENV_LOG_FORMAT=

# use fd for fzf input
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# DO NOT COMMIT SECRETS TO GIT
[ -f "${HOME}/.secrets" ] && { . "${HOME}/.secrets"; }

export STARSHIP_CACHE="$HOME/.cache/starship"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

export LESS='FXMQRSi'

# source machine-local env overrides (e.g. ~/.zshenv-work or ~/.zshenv-home)
[ -f "${HOME}/.zshenv-local" ] && { . "${HOME}/.zshenv-local"; }
