export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

#path=(
#	/opt/homebrew/bin
#	/opt/homebrew/sbin
#	$path
#)

eval "$(/opt/homebrew/bin/mise activate zsh --shims)"
