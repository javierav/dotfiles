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
if hash dircolors 2> /dev/null; then
  eval `dircolors $HOME/.dotfiles/dircolors`
fi

# bash completion
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# asdf
[[ -r "/usr/local/opt/asdf/asdf.sh" ]] && source "/usr/local/opt/asdf/asdf.sh"

# direnv
if hash direnv 2> /dev/null; then
  eval "$(direnv hook bash)"
fi

# buildpacks.io pack command
if hash pack 2> /dev/null; then
  eval "$(pack completion)"
fi

# load after bashrc
[[ -s "$HOME/.bashrc.after" ]] && source "$HOME/.bashrc.after"
