#!/usr/bin/env bash

# colors
OFF='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'

# title
echo -e "$PURPLE==============================="
echo " ARANDAIO'S DOTFILES INSTALLER "
echo -e "===============================$OFF\n"

# check dependencies
if ! hash realpath 2> /dev/null; then
  echo -e "${RED}Please install the 'realpath' command!"
  exit 1
fi

# opts
while getopts f opts; do
 case ${opts} in
  f) FORCE=true ;;
 esac
done

# install dotfiles
while read -r -u 3 file; do
  if [ -e "$HOME/.dotignore" ] && grep -Fxq "$file" "$HOME/.dotignore"; then
    echo -e "$BLUE\$HOME/.$file included in .dotignore file. Skipped!$OFF"
    continue
  fi

  if [ -e "$HOME/.$file" ] && [ -z "$FORCE" ]; then
    read -e -p $'\033[0;33m'"\$HOME/.$file exists, overwrite (y/n)?: "$'\033[0m' -n 1 answer

    if [[ $answer = [nN] ]]; then
      echo -e "$BLUE\$HOME/.$file skipped!$OFF"
      continue
    fi
  fi

  cp -f $(realpath $(dirname $0))/$file $HOME/.$file
  echo -e "$GREEN\$HOME/.$file installed!$OFF"
done 3< $(realpath $(dirname $0))/_files
