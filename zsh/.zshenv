# common ENV file used by .bashrc and .zshrc
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export GPG_TTY=$(tty)

export GIT_USERNAME=Andrew.Basson-Makersite
export GIT_USER=${GIT_USERNAME}
export GIT_PAGER='LESS=FRX less -S +c'
export GIT_EDITOR=${EDITOR}

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# silence direnv output
#export DIRENV_LOG_FORMAT=

#ulimit -n 524288 unlimited

#export GRADLE_USER_HOME="$HOME/.gradle"
#export RUST_WITHOUT=rust-docs

# use fd for fzf input
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# DO NOT COMMIT SECRETS TO GIT
[ -f "${HOME}/.secrets" ] && { . "${HOME}/.secrets"; }

# lima amnd qemu require socket vmnet
# https://lima-vm.io/docs/installation/
# https://adonis0147.github.io/post/qemu-socket-vmnet/
# export PATH=/opt/homebrew/opt/socket_vmnet/bin:$PATH

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TF_IN_AUTOMATION=true

export STARSHIP_CACHE="$HOME/.cache/starship"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

export LESS='FXMQRSi'

