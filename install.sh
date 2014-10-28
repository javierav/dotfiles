#!/usr/bin/env bash

echo "==============================="
echo " ARANDAIO'S DOTFILES INSTALLER "
echo "==============================="

# check dependencies
if ! hash realpath 2> /dev/null; then
  echo "Please install the 'realpath' command!"
  exit 1
fi

while getopts f opts; do
 case ${opts} in
  f) FORCE=true ;;
 esac
done

for file in bash_profile bashrc functions exports aliases bash_prompt dircolors wgetrc gitconfig gitignore gemrc; do
  if [ -e "$HOME/.$file" ] && [ -z "$FORCE" ]; then
    read -e -p "\$HOME/.$file exists, overwrite (y/n)?: " -n 1 answer

    if [[ $answer = [nN] ]]; then
      echo "\$HOME/.$file skipped!"
      continue
    fi
  fi

  cp -f $(realpath $(dirname $0))/$file $HOME/.$file
  echo "\$HOME/.$file installed!"
done
