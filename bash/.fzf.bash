# Setup fzf
# ---------
FZF_DIR=$(asdf where fzf)

# which shell are we since we source this from bash, sh and zsh....
shell_suffix=$(ps -o comm= -p $$ |tr -d '-')
# Auto-completion
# ---------------
[ -f "$FZF_DIR/shell/completion.$shell_suffix" ] && { source "$FZF_DIR/shell/completion.$shell_suffix"; }

# Key bindings
# ------------
[ -f "$FZF_DIR/shell/key-bindings.$shell_suffix" ] && { source "$FZF_DIR/shell/key-bindings.$shell_suffix"; }
