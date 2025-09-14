# common ENV file used by .bashrc and .zshrc
export LANG=en_US.UTF-8

[ -f "$HOME/.cargo/env" ] && { . "$HOME/.cargo/env"; }

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export GPG_TTY=$(tty)

export GIT_USERNAME=andrew.basson
export GIT_USER=${GIT_USERNAME}
export GIT_PAGER='LESS=FRX less -S +c'
export GIT_EDITOR=${EDITOR}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# silence direnv output
export DIRENV_LOG_FORMAT=

#ulimit -n 524288 unlimited

#export GRADLE_USER_HOME="$HOME/.gradle"
#export RUST_WITHOUT=rust-docs

# use fd for fzf input
source <(/opt/homebrew/bin/fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# setup golang env vars
#export ASDF_GOLANG_MOD_VERSION_ENABLED=true
#[ -f "$HOME/.asdf/plugins/golang/set-env.$shell_suffix" ] && { . "$HOME/.asdf/plugins/golang/set-env.$shell_suffix"; }

# DO NOT COMMIT SECRETS TO GIT
[ -f "${HOME}/.secrets" ] && { . "${HOME}/.secrets"; }

# socket_vmnet for lima and qemu
#export PATH=/opt/homebrew/opt/socket_vmnet/bin:$PATH

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TF_IN_AUTOMATION=true

# sops age private key location
export SOPS_AGE_KEY_FILE="$HOME/.config/mise/age.txt"

# pretty things
# eval "$(/opt/homebrew/bin/starship init zsh)"
