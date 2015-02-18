# vim: ft=sh

source "$HOME/.bash_functions"
source "$HOME/.bash_exports"
source "$HOME/.bash_aliases"
source "$HOME/.bash_prompt"

# colors for ls command
eval `dircolors $HOME/.dircolors`

# bash completion
if [[ "$OSTYPE" =~ ^darwin ]] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# direnv
eval "$(direnv hook $0)"

# load local bash_profile
[[ -s "$HOME/.bash_profile.local" ]] && source "$HOME/.bash_profile.local"
