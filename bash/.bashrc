idempotent_path_prepend() {
	for ((i = $#; i > 0; i--)); do
		ARG=${!i}
		PATH=${PATH//":$1"/}              #delete any instances in the middle or at the end
		PATH=${PATH/%":$1"/}              #delete any instances at the end
		PATH=${PATH/#"$1:"/}              #delete any instances at the beginning
		PATH=${PATH/#":"/}                #delete any empty left-overs at the beginning
		export PATH="$1${PATH:+":$PATH"}" #prepend $1 or if $PATH is empty set to $1
	done

}

idempotent_path_prepend "$HOME/bin" "$HOME/.local/bin" "$HOME/.krew/bin"
# lima/qemu not used
# idempotent_path_prepend "/opt/homebrew/opt/socket_vmnet/bin"
echo $PATH
export BASH_SILENCE_DEPRECATION_WARNING=1

source $(fzf --bash)
 [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# source the common stuff - maybe rename this file?
. ~/.zshenv
# eval "$(/opt/homebrew/bin/mise activate bash)"
