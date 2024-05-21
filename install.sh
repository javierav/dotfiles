#!/usr/bin/env bash

# files
FILES=(
  "link:asdfrc:.asdfrc"
  "link:bash_profile:.bash_profile"
  "link:bashrc:.bashrc"
  "link:default-gems:.default-gems"
  "link:gemrc:.gemrc"
  "link:gitconfig:.gitconfig"
  "link:gitignore:.gitignore"
)

# paths
SOURCE_PATH="$HOME/.dotfiles"
TARGET_PATH="$HOME"

print::usage() {
  cat << EOF

  Usage: $0 [options]

  OPTIONS:
    -f force the installation
    -o <name> specify the file to install
    -s <name> specify the file to skip
    -p pretend
    -a ask before install
    -i <path> specify the install directory. Default \$HOME.
    -h print this help


  DOTIGNORE:

  Puts a .dotignore file in your \$INSTALLDIR to avoid the installation of
  specific dotfiles. One filename per line.

EOF
}

print::message() {
  local color="$1"
  local message="$2"
  local off='\033[0m'
  local red='\033[0;31m'
  local green='\033[0;32m'
  local yellow='\033[0;33m'
  local blue='\033[0;34m'
  local purple='\033[0;35m'

  echo -e "${!color}$message$off"
}

check::dependencies() {
  local dependencies=(md5sum awk)

  for dep in "${dependencies[@]}"; do
    if ! hash "$dep" 2> /dev/null; then
      print::message red "Error. Please install the '$dep' command!"
      exit 1
    fi
  done
}

options::parse() {
  while getopts "fo:s:i:pah" opts; do
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
    i)
      TARGET_PATH="$OPTARG"
      ;;
    h)
      print::usage
      exit 1
   esac
  done
}

process::dotfiles() {
  for file in "${FILES[@]}"; do
    IFS=":" read -r operation source_file target_file <<< "$file"
    process::file "$operation" "$source_file" "$target_file"
  done
}

process::file() {
  local operation="$1"
  local source_file="$2"
  local target_file="$3"

  check::dotignore "$source_file" "$target_file" || return
  check::only "$source_file" "$target_file" || return
  check::skip "$source_file" "$target_file" || return
  install::ask "$target_file" || return
  install::diff "$source_file" "$target_file" || return
  install::perform "$operation" "$source_file" "$target_file"
}

check::dotignore() {
  local source_file="$1"
  local target_file="$2"

  if [ -e "$TARGET_PATH/.dotignore" ] && grep -Fxq "$source_file" "$TARGET_PATH/.dotignore"; then
    print::message blue "$TARGET_PATH/$target_file skipped! (included in .dotignore)"
    return 1
  fi
}

check::only() {
  local source_file="$1"
  local target_file="$2"
  local included=0

  for o in "${ONLY[@]}"; do
    if [ "$o" == "$source_file" ]; then
      included=1
    fi
  done

  if [ $included -eq 0 ] && [ ${#ONLY[@]} -gt 0 ]; then
    print::message blue "$TARGET_PATH/$target_file skipped! (not included in the only list)"
    return 1
  fi
}

check::skip() {
  local source_file="$1"
  local target_file="$2"

  for s in "${SKIP[@]}"; do
    if [ "$s" == "$source_file" ]; then
      print::message blue "$TARGET_PATH/$target_file skipped! (included in the skip list)"
      return 1
    fi
  done
}

install::ask() {
  local target_file="$1"

  if [ -n "$ASK" ]; then
    while true; do
      # print question
      read -e -p $'\033[0;33m'"Do you want to install $TARGET_PATH/$target_file file? [y,n,h]: "$'\033[0m' -n 1 answer

      if [[ $answer = [hH] ]]; then
        # print help
        echo -e "y - install file"
        echo -e "n - not install file"
        echo -e "h - print this help"
      elif [[ $answer = [yY] ]]; then
        # install
        return 0
      elif [[ $answer = [nN] ]]; then
        # skip
        print::message blue "$TARGET_PATH/$target_file skipped!"
        return 1
      fi
    done
  fi
}

install::diff() {
  local source_file="$1"
  local target_file="$2"

  if [ -e "$TARGET_PATH/$target_file" ] && [ -z "$FORCE" ]; then
    # checksum
    local source_md5=$(md5sum "$SOURCE_PATH/$source_file" | awk '{ print $1 }')
    local target_md5=$(md5sum "$TARGET_PATH/$target_file" | awk '{ print $1 }')

    # only if are different
    if [ "$source_md5" != "$target_md5" ]; then
      while true; do
        read -e -p $'\033[0;33m'"$TARGET_PATH/$target_file exists and is different, overwrite [y,n,d,h]?: "$'\033[0m' -n 1 answer

        if [[ $answer = [hH] ]]; then
          # print help
          echo -e "y - overwrite"
          echo -e "n - not overwrite"
          echo -e "d - view diff"
          echo -e "h - print this help"
        elif [[ $answer = [dD] ]]; then
          # print diff
          git diff "$TARGET_PATH/$target_file" "$SOURCE_PATH/$source_file"
        elif [[ $answer = [yY] ]]; then
          # overwrite
          return 0
        elif [[ $answer = [nN] ]]; then
          # skip
          print::message blue "$TARGET_PATH/$target_file skipped!"
          return 1
        fi
      done
    else
      # skip because are equal
      print::message blue "$TARGET_PATH/$target_file skipped! (is equal)"
      return 1
    fi
  fi
}

install::perform() {
  local operation="$1"
  local source_file="$2"
  local target_file="$3"

  if [ -z "$PRETEND" ]; then
    file::$operation "$source_file" "$target_file"
  else
    # pretend
    echo "[pretend] $SOURCE_PATH/$source_file -> $TARGET_PATH/$target_file"
  fi
}

file::copy() {
  local source_file="$1"
  local target_file="$2"

  cp --remove-destination "$SOURCE_PATH/$source_file" "$TARGET_PATH/$target_file"
  print::message green "$SOURCE_PATH/$source_file copied to $TARGET_PATH/$target_file"
}

file::link() {
  local source_file="$1"
  local target_file="$2"

  ln -s -f "$SOURCE_PATH/$source_file" "$TARGET_PATH/$target_file"
  print::message green "$SOURCE_PATH/$source_file linked into $TARGET_PATH/$target_file"
}

check::dependencies
options::parse "$@"
process::dotfiles
