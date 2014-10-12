# vim: ft=sh

source .functions
source .exports
source .aliases
source .bash_prompt

# colors for ls command
eval `dircolors ./.dircolors`

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
