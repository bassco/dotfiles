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
