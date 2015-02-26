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
dependencies=(realpath direnv)

for dep in "${dependencies[@]}"; do
  if ! hash $dep 2> /dev/null; then
    echo -e "${RED}Error. Please install the '$dep' command!\n"
    exit 1
  fi
done

# opts
while getopts "fo:s:ph" opts; do
 case ${opts} in
  f)
    FORCE="yes"
    ;;
  o)
    ONLY="$OPTARG"
    ;;
  p)
    PRETEND="yes"
    ;;
  s)
    SKIP+=("$OPTARG")
    ;;
  h)
    echo -e "Usage: ./install.sh [options]\n\nOptions:\n"
    echo -e "  -f force the installation"
    echo -e "  -o <name> specify the file to install"
    echo -e "  -s <name> specify the file to skip"
    echo -e "  -p pretend"
    echo -e "  -h print this help\n\n"

    echo -e "[.dotignore]\n"
    echo -e "Use this file in your \$HOME to avoid the installation of"
    echo -e "specific dotfiles. One filename per line. "

    echo ""

    exit 1
 esac
done

# install dotfiles
while read -r -u 3 file; do
  # skip due to dotignore
  if [ -e "$HOME/.dotignore" ] && grep -Fxq "$file" "$HOME/.dotignore"; then
    echo -e "$BLUE\$HOME/.$file included in .dotignore file. Skipped!$OFF"
    continue
  fi

  # skip due to only option
  if [ -n "$ONLY" ] && [ $file != $ONLY ]; then
    continue
  fi

  # skip option
  for s in "${SKIP[@]}"; do
    if [ "$s" == "$file" ]; then
      continue 2
    fi
  done

  # already exists a file at the same path
  if [ -e "$HOME/.$file" ] && [ -z "$FORCE" ]; then
    read -e -p $'\033[0;33m'"\$HOME/.$file exists, overwrite (y/n)?: "$'\033[0m' -n 1 answer

    # skip
    if [[ $answer = [nN] ]]; then
      echo -e "$BLUE\$HOME/.$file skipped!$OFF"
      continue
    fi
  fi

  if [ -z "$PRETEND" ]; then
    # copy the file
    cp -f $(realpath $(dirname $0))/$file $HOME/.$file
    echo -e "$GREEN\$HOME/.$file installed!$OFF"
  else
    # pretend
    echo "[pretend] $(realpath $(dirname $0))/$file -> $HOME/.$file"
  fi

  # exit due to only option
  if [ -n "$ONLY" ]; then
    exit 0
  fi
done 3< $(realpath $(dirname $0))/_files
