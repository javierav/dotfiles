# vim: ft=sh

source "__DOTFILES_PATH__/bash_functions"
source "__DOTFILES_PATH__/bash_exports"
source "__DOTFILES_PATH__/bash_aliases"
source "__DOTFILES_PATH__/bash_prompt"

# colors for ls command
eval `dircolors __DOTFILES_PATH__/dircolors`

# bash completion
if [[ "$OSTYPE" =~ ^darwin ]] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# direnv
if hash direnv 2> /dev/null; then
  eval "$(direnv hook $0)"
fi

# rbenv
eval "$(rbenv init -)"

# load local bash_profile
[[ -s "$HOME/.bash_profile.local" ]] && source "$HOME/.bash_profile.local"
