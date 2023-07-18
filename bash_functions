# vim: ft=sh

# Include custom functions
[[ -s "$HOME/.bash_functions.local" ]] && source "$HOME/.bash_functions.local"


if hash pwgen 2> /dev/null; then
  newpass () {
    pwgen -cnys 64 1
  }
fi
