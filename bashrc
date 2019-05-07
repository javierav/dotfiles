# vim: ft=sh

# BASHRC
# This file is executed if you’ve already logged into your machine and open a
# new terminal window (xterm) and also run when you start a new bash instance
# by typing /bin/bash in a terminal.


# load before bashrc
[[ -s "$HOME/.bashrc.before" ]] && source "$HOME/.bashrc.before"

source "$HOME/.dotfiles/bash_functions"
source "$HOME/.dotfiles/bash_exports"
source "$HOME/.dotfiles/bash_aliases"
source "$HOME/.dotfiles/bash_prompt"

# colors for ls command
eval `dircolors $HOME/.dotfiles/dircolors`

# bash completion
if [[ "$OSTYPE" =~ ^darwin ]] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  source "$(brew --prefix)/etc/bash_completion"
fi

# asdf
if [[ -e "$HOME/.asdf/asdf.sh" ]]; then
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"
fi

# direnv
if hash direnv 2> /dev/null; then
  eval "$(direnv hook bash)"
fi

# load after bashrc
[[ -s "$HOME/.bashrc.after" ]] && source "$HOME/.bashrc.after"
