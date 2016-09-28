# vim: ft=sh

# BASHRC
# This file is executed if you’ve already logged into your machine and open a
# new terminal window (xterm) and also run when you start a new bash instance
# by typing /bin/bash in a terminal.


# load before bashrc
[[ -s "$HOME/.bashrc.before" ]] && source "$HOME/.bashrc.before"

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

# rbenv
if [[ -d "$HOME/.rbenv/bin" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
fi

if hash rbenv 2> /dev/null; then
  eval "$(rbenv init -)"
fi

# direnv
if hash direnv 2> /dev/null; then
  eval "$(direnv hook bash)"
fi

# load after bashrc
[[ -s "$HOME/.bashrc.after" ]] && source "$HOME/.bashrc.after"
