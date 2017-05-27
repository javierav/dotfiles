# vim: ft=sh

captura() {
  cwd=$(pwd)
  cd ~/designs && pageres $1 1600x900
  cd $cwd
}

# Include custom functions
[[ -s "$HOME/.bash_functions.local" ]] && source "$HOME/.bash_functions.local"
