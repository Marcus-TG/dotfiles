alias ls='eza --icons'
alias tree='eza -T'
alias grep='grep --color=auto'
alias cat='bat'
alias cd='z'
alias cds='zi'
alias lg='lazygit'
alias ld='lazydocker'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
fastfetch

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Yazi shell integration — cd on quit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

export PATH="$HOME/.npm-global/bin:$PATH"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
# zoxide must be initialized last. _ZO_DOCTOR=0 silences a false-positive
# "initialize zoxide last" warning that only fires in non-interactive
# automation shells; zoxide is already last here.
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"
