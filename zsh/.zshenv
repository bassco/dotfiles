# common ENV file used by .bashrc and .zshrc

[ -f "$HOME/.cargo/env" ] && { . "$HOME/.cargo/env"; }

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export GPG_TTY=$(tty)

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.krew/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Tell homebrew to not autoupdate every single time I run it (just once a week).

export GIT_USERNAME=andrew.basson
export GIT_USER=${GIT_USERNAME}
export GIT_PAGER='LESS=FRX less -S +c'
export GIT_EDITOR=${EDITOR}

export HOMEBREW_AUTO_UPDATE_SECS=604800

# silence direnv output
export DIRENV_LOG_FORMAT=

#ulimit -n 524288 unlimited

export GRADLE_USER_HOME="$HOME/.gradle"
# used by .bashrc too - so keep it last
# for asdf rust
#export RUST_WITHOUT=rust-docs

# use fd for fzf input
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

[ -f /Users/andrew.basson/.asdf/plugins/java/set-java-home.zsh ] && { . /Users/andrew.basson/.asdf/plugins/java/set-java-home.zsh; }

. ~/.aliases

# DO NOT COMMIT SECRETS TO GIT
[ -f "${HOME}/.secrets" ] && { . "${HOME}/.secrets"; }
