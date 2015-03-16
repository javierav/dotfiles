#!/usr/bin/env bash

# colors
OFF='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'

title() {
  echo -e "    $PURPLE==============================="
  echo -e "     ARANDAIO'S DOTFILES INSTALLER "
  echo -e "    ===============================$OFF\n"
}

usage() {
  cat << EOF
    Usage: $0 [options]

    Install the arandaio's dotfiles


    OPTIONS:
      -f force the installation
      -o <name> specify the file to install
      -s <name> specify the file to skip
      -p pretend
      -h print this help


    DOTIGNORE:

    Puts a .dotignore file in your \$HOME to avoid the installation of
    specific dotfiles. One filename per line.

EOF
}

# print title
title

# check dependencies
dependencies=(realpath md5sum awk)

for dep in "${dependencies[@]}"; do
  if ! hash $dep 2> /dev/null; then
    echo -e "${RED}Error. Please install the '$dep' command!$OFF\n"
    exit 1
  fi
done

# current path
current_path=$(realpath $(dirname $0))

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
    usage
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
    # checksum
    md5_dotfiles=$(md5sum $current_path/$file | awk '{ print $1 }')
    md5_home=$(md5sum $HOME/.$file | awk '{ print $1 }')

    # only if are different
    if [ $md5_dotfiles != $md5_home ]; then
      read -e -p $'\033[0;33m'"\$HOME/.$file exists and is different, overwrite (y/n)?: "$'\033[0m' -n 1 answer

      # skip
      if [[ $answer = [nN] ]]; then
        echo -e "$BLUE\$HOME/.$file skipped!$OFF"
        continue
      fi
    else
      # skip because are equal
      echo -e "$BLUE\$HOME/.$file skipped! (is equal)$OFF"
      continue
    fi
  fi

  if [ -z "$PRETEND" ]; then
    # copy the file
    cp -f $current_path/$file $HOME/.$file
    # replace variables
    sed -i "s|__DOTFILES_PATH__|$current_path|g" $HOME/.$file
    echo -e "$GREEN\$HOME/.$file installed!$OFF"
  else
    # pretend
    echo "[pretend] $current_path/$file -> $HOME/.$file"
  fi

  # exit due to only option
  if [ -n "$ONLY" ]; then
    exit 0
  fi
done 3< $current_path/_files
