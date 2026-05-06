alias ls='eza --icons'
alias tree='eza -T'
alias grep='grep --color=auto'
alias cat='bat'
alias cd='z'
alias cds='zi'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh="kitty +kitten ssh"
fi

fastfetch

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
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
