#!/usr/bin/env bash

#  Script: hhs-utils.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Change back the shell working directory by N directories
..() { 
  [ -z "$1" ] && cd ..
  if [ -n "$1" ]; 
    then 
      old_pwd=$(pwd)
      for x in $(seq 1 "$1"); do 
        pushd "$x" || return 1
        cd ..
      done
  fi

  export OLDPWD="$old_pwd"; 
  
  return 1
}

# shellcheck disable=SC2012
# @function: List all file names sorted by name
lss() { 
  col="$1"
  [ -z "$1" ] && col=9 # by default, sort by the filename
  command ls -la | sort -k "$col"

  return $?
}

# @function: Create all folders using a dot notation path and immediatelly change into it
mkcd() { 
  if [ -n "$1" ] && [ ! -d "$1" ]; then 
    # Create the java package like dirs using dot notation: E.g java.lang.util => java/lang/util
    dir="${1//.//}"
    mkdir -p "${dir}" || return 1
    pushd "${dir}" >/dev/null || return 1
    echo "${GREEN}Directory created: ${dir} ${NC}"
  fi

  return 0
}

# @function: Kills ALL processes specified by $1
pk() { 
  [ -n "$1" ] && plist "$1" kill

  return $?
}

# @function: Generate a random number int the range <min> <max>
rand() { 
  if [ -n "$1" ] && [ -n "$2" ]; then
    echo "$(( RANDOM % ($2 - $1 + 1 ) + $1 ))"
  else
    echo "Usage: rand <min> <max>"
  fi
}

# @function: List all directories recursively (Nth level depth) as a tree
lt() {
  if __hhs_has "tree"; then
    if [ -n "$1" ] && [ -n "$2" ]; then
      tree "$1" -L "$2"
    else
      tree "$1"
    fi

    return $?
  fi

  return 1
}

# @function: Convert unicode to hexadecimal
utoh() { 
  if __hhs_has "python"; then
    print-uni.py "$@" | hexdump -Cb;
    
    return $?
  fi

  return 1
}
