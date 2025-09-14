# Setup fzf
# ---------
#FZF_DIR=$(mise where fzf)
# needed when using homebrew. ignored since we use asdf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$FZF_DIR/bin"
fi

# which shell are we since we source this from bash, sh and zsh....
shell_suffix=$(ps -o comm= -p $$ |tr -d '-')
# Auto-completion
# ---------------
[ -f "$FZF_DIR/shell/completion.$shell_suffix" ] && { source "$FZF_DIR/shell/completion.$shell_suffix"; }

# Key bindings
# ------------
[ -f "$FZF_DIR/shell/key-bindings.$shell_suffix" ] && { source "$FZF_DIR/shell/key-bindings.$shell_suffix"; }
