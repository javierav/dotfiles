#!/usr/bin/env bash

# colors
OFF='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'

usage() {
  cat << EOF

  Usage: $0 [options]

  OPTIONS:
    -f force the installation
    -o <name> specify the file to install
    -s <name> specify the file to skip
    -p pretend
    -a ask before install
    -h print this help


  DOTIGNORE:

  Puts a .dotignore file in your \$HOME to avoid the installation of
  specific dotfiles. One filename per line.

EOF
}

# check dependencies
dependencies=(realpath md5sum awk)

for dep in "${dependencies[@]}"; do
  if ! hash "$dep" 2> /dev/null; then
    echo -e "${RED}Error. Please install the '$dep' command!$OFF\n"
    exit 1
  fi
done

# current path
current_path=$(realpath $(dirname $0))

# opts
while getopts "fo:s:pah" opts; do
 case ${opts} in
  f)
    FORCE="yes"
    ;;
  o)
    ONLY+=("$OPTARG")
    ;;
  p)
    PRETEND="yes"
    ;;
  s)
    SKIP+=("$OPTARG")
    ;;
  a)
    ASK="yes"
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
    echo -e "$BLUE\$HOME/.$file skipped! (included in .dotignore)$OFF"
    continue
  fi

  # skip due to only option
  included=0

  for o in "${ONLY[@]}"; do
    if [ "$o" == "$file" ]; then
      included=1
    fi
  done

  if [ $included -eq 0 ] && [ ${#ONLY[@]} -gt 0 ]; then
    echo -e "$BLUE\$HOME/.$file skipped!$OFF"
    continue
  fi

  # skip option
  for s in "${SKIP[@]}"; do
    if [ "$s" == "$file" ]; then
      continue 2
    fi
  done

  # ask for install
  if [ -n "$ASK" ]; then
    while true; do
      # print question
      read -e -p $'\033[0;33m'"Do you want to install \$HOME/.$file file? [y,n,h]: "$'\033[0m' -n 1 answer

      # print help
      if [[ $answer = [hH] ]]; then
        echo -e "y - install file"
        echo -e "n - not install file"
        echo -e "h - print this help"
        continue
      fi

      # install
      if [[ $answer = [yY] ]]; then
        break
      fi

      # skip
      if [[ $answer = [nN] ]]; then
        echo -e "$BLUE\$HOME/.$file skipped!$OFF"
        continue 2
      fi
    done
  fi

  # already exists a file at the same path
  if [ -e "$HOME/.$file" ] && [ -z "$FORCE" ]; then
    # checksum
    md5_dotfiles=$(md5sum "$current_path/$file" | awk '{ print $1 }')
    md5_home=$(md5sum "$HOME/.$file" | awk '{ print $1 }')

    # only if are different
    if [ "$md5_dotfiles" != "$md5_home" ]; then
      while true; do
        read -e -p $'\033[0;33m'"\$HOME/.$file exists and is different, overwrite [y,n,d,h]?: "$'\033[0m' -n 1 answer

        # print help
        if [[ $answer = [hH] ]]; then
          echo -e "y - overwrite"
          echo -e "n - not overwrite"
          echo -e "d - view diff"
          echo -e "h - print this help"
          continue
        fi

        # print diff
        if [[ $answer = [dD] ]]; then
          git diff "$HOME/.$file" "$current_path/$file"
          continue
        fi

        # overwrite
        if [[ $answer = [yY] ]]; then
          break
        fi

        # skip
        if [[ $answer = [nN] ]]; then
          echo -e "$BLUE\$HOME/.$file skipped!$OFF"
          continue 2
        fi
      done
    else
      # skip because are equal
      echo -e "$BLUE\$HOME/.$file skipped! (is equal)$OFF"
      continue
    fi
  fi

  if [ -z "$PRETEND" ]; then
    # copy the file
    cp -f "$current_path/$file" "$HOME/.$file"
    echo -e "$GREEN\$HOME/.$file installed!$OFF"
  else
    # pretend
    echo "[pretend] $current_path/$file -> $HOME/.$file"
  fi
done 3< "$current_path/_files"
