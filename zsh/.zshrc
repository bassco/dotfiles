# profile zsh startup
# $ ZSH_PROFILE_STARTUP=1 zsh -i -c exit
if [ -n "${ZSH_PROFILE_STARTUP:+x}" ]
then
  zmodload zsh/zprof
fi

# Let's pretend that we follow standards
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# completions
autoload -Uz compinit && compinit
bindkey -e  # emacs key bindings (OMZ default)

# plugins via homebrew
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(zoxide init zsh)"

typeset -aU path fpath
path=(
  $HOME/.cargo/bin
  $HOME/.local/bin
  $HOME/.krew/bin
  $path
)

. ~/.aliases

# make the prompt pretty
eval "$(starship init zsh)"
#export ATUIN_NOBIND="true"
#eval "$(atuin init zsh)"

[ -h ~/.fzf.zsh ] && source ~/.fzf.zsh

# Src: https://gist.github.com/nikvdp/f72ff1776815861c5da78ceab2847be2
#
# make sure you have `tac` [1] (if on on macOS) and `atuin` [2] installed, then drop the below in your ~/.zshrc
#
# [1]: https://unix.stackexchange.com/questions/114041/how-can-i-get-the-tac-command-on-os-x
# [2]: https://github.com/ellie/atuin

atuin-setup() {
  ! hash atuin && return
  bindkey '^E' _atuin_search_widget

  export ATUIN_NOBIND="true"
  eval "$(atuin init zsh)"
  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
    selected=$(atuin search --cmd-only --limit ${ATUIN_LIMIT:-5000} | tac |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${LBUFFER} +m" fzf)
    local ret=$?
    if [ -n "$selected" ]; then
      # the += lets it insert at current pos instead of replacing
      LBUFFER+="${selected}"
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-atuin-history-widget
  bindkey '^R' fzf-atuin-history-widget
}

atuin-setup

# source machine-local rc overrides (e.g. ~/.zshrc-work or ~/.zshrc-home)
[ -f "${HOME}/.zshrc-local" ] && { . "${HOME}/.zshrc-local"; }

# must be sourced last
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [ -n "${ZSH_PROFILE_STARTUP:+x}" ]
then
  zprof
fi
