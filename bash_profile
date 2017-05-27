# vim: ft=sh

# BASH_PROFILE
# This file is executed for login shells (when you type username and password)
# via console, either sitting at the machine, or remotely via ssh to configure
# your shell before the initial command prompt.


# load before bash_profile
[[ -s "$HOME/.bash_profile.before" ]] && source "$HOME/.bash_profile.before"

# load bashrc to avoid code duplication
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# load after bash_profile
[[ -s "$HOME/.bash_profile.after" ]] && source "$HOME/.bash_profile.after"
