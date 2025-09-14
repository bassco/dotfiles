# $PATH is overwritten in login shells, messing with tmux
typeset -U path
[ -d "$HOME/.local/bin" ] && path=($HOME/.local/bin $path[@])
[ -d "$HOME/.cargo/bin" ] && path=($HOME/.cargo/bin $path[@])

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
