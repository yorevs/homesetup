#!/usr/bin/env bash

#  Script: hhs-utils.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Change back the shell working directory by N directories
# @param $1 [Opt] : The amount of directories to jump back
..() {
  [ -z "$1" ] && cd ..
  if [ -n "$1" ]; then
    last_pwd=$(pwd)
    for x in $(seq 1 "$1"); do
      cd .. || return 1
    done
    pwd
  fi
  export OLDPWD="$last_pwd"

  return 1
}

# @function: Create and/or open a file using the default editor
# @param $1 [Req] : The file path
edit() {
  [ -z "$1" ] && return 1
  [ -f "$1" ] || touch "$1" >/dev/null 2>&1
  [ -f "$1" ] && open "$1" && return 0
  return 1
}

# shellcheck disable=SC2012
# @function: List all file names sorted by name
# @param $1 [Opt] : The column to sort; 9 (filename) by default
lss() {
  col="${1:-9}"
  command ls -la | sort -k "$col"

  return $?
}

# @function: Create all folders using a dot notation path and immediatelly change into it
# @param $1 [Req] : The directory tree to create, using slash (/) or dot (.) notation path
mkcd() {
  if [ -n "$1" ] && [ ! -d "$1" ]; then
    dir="${1//.//}"
    mkdir -p "${dir}" || return 1
    last_pwd=$(pwd)
    for d in ${dir//\// }; do
      cd "$d" || return 1
    done
    export OLDPWD=$last_pwd
    echo "${GREEN}${dir}${NC}"
  else
    echo "Usage: ${FUNCNAME[0]} <dirtree | package>"
    echo ''
    echo 'E.g:. mkcd dir1/dir2/dir3 (dirtree)'
    echo 'E.g:. mkcd dir1.dir2.dir3 (package)'
  fi

  return 0
}

# @function: Kills ALL processes specified by $1
# @param $1 [Req] : The process name to kill
pk() {
  if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
    shift
    __hhs_process_list -f "$1" kill
  elif [ -n "$1" ]; then
    __hhs_process_list "$1" kill
  fi

  return $?
}

# @function: Generate a random number int the range <min> <max>
# @param $1 [Req] : The minimum range of the number
# @param $2 [Req] : The maximum range of the number
rand() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  else
    echo "Usage: ${FUNCNAME[0]} <min-val> <max-val>"
  fi
}

# @function: List all directories recursively (Nth level depth) as a tree
# @param $1 [Req] : The max level depth to walk into
if __hhs_has "tree"; then
  lt() {
    if [ -n "$1" ] && [ -n "$2" ]; then
      tree "$1" -L "$2"
    elif [ -n "$1" ]; then
      tree "$1"
    else
      tree '.'
    fi

    return $?
  }
fi

# @function: Convert unicode to hexadecimal
# @param $1..N [Req] : The unicodes to convert
if __hhs_has "python"; then
  utoh() {

    local result converted uni

    if [ -n "$1" ]; then
      for x in "$@"; do
        uni="${x:0:4}"
        echo -e "\n[Uni-$uni]: "
        converted=$(print-uni.py "$uni" | hexdump -Cb)
        result=$(awk '
        NR == 1 {printf "  Hex => "; print $2" "$3" "$4}
        NR == 2 {printf "  Oct => "; print $2" "$3" "$4}
        NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
      ' <<<"${converted}")
        echo -e "${result}"
        echo ''
      done
    else
      echo "Usage: ${FUNCNAME[0]} <unicode-1> [unicode-2 ... unicode-N]"
      echo "       unicode is a four hex digit"
    fi

    return $?
  }
fi
