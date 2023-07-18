# vim: ft=sh

# BASHRC
# This file is executed if you’ve already logged into your machine and open a
# new terminal window (xterm) and also run when you start a new bash instance
# by typing /bin/bash in a terminal.


# load before bashrc
[[ -s "$HOME/.bashrc.before" ]] && source "$HOME/.bashrc.before"

# homebrew
if type /opt/homebrew/bin/brew &>/dev/null; then
  eval $(/opt/homebrew/bin/brew shellenv)

  # bash completion
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

source "$HOME/.dotfiles/bash_functions"
source "$HOME/.dotfiles/bash_exports"
source "$HOME/.dotfiles/bash_aliases"
source "$HOME/.dotfiles/bash_prompt"

# colors for ls command
if hash dircolors 2> /dev/null; then
  eval `dircolors $HOME/.dotfiles/dircolors`
fi

# asdf
[[ -r "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh" ]] && source "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
[[ -r "${HOMEBREW_PREFIX}/opt/asdf/etc/bash_completion.d/asdf.bash" ]] && source "${HOMEBREW_PREFIX}/opt/asdf/etc/bash_completion.d/asdf.bash"

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
