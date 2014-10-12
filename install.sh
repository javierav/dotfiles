#!/usr/bin/env bash

echo "==============================="
echo " ARANDAIO'S DOTFILES INSTALLER "
echo "==============================="

while getopts f opts; do
 case ${opts} in
  f) FORCE=true ;;
 esac
done

for file in bash_profile bashrc functions exports aliases bash_prompt dircolors wgetrc gitconfig gitignore; do
  if [ ! -e "$HOME/.$file" ] || [ ! -z "$FORCE" ]; then
    cp -f $(realpath $(dirname $0))/$file $HOME/.$file
    echo "\$HOME/.$file installed!"
  else
    echo "\$HOME/.$file exists, skipping..."
  fi
done
