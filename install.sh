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

while read -r -u 3 file; do
  if [ -e "$HOME/.dotignore" ] && grep -Fxq "$file" "$HOME/.dotignore"; then
    echo "\$HOME/.$file included in .dotignore file. Skipped!"
    continue
  fi

  if [ -e "$HOME/.$file" ] && [ -z "$FORCE" ]; then
    read -e -p "\$HOME/.$file exists, overwrite (y/n)?: " -n 1 answer

    if [[ $answer = [nN] ]]; then
      echo "\$HOME/.$file skipped!"
      continue
    fi
  fi

  cp -f $(realpath $(dirname $0))/$file $HOME/.$file
  echo "\$HOME/.$file installed!"
done 3< $(realpath $(dirname $0))/_files
