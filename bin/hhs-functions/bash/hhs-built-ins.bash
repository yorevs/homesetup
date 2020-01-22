#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Change back the shell working directory by N directories
# @param $1 [Opt] : The amount of directories to jump back
function ..() {

  last_pwd=$(pwd)
  [ -z "$1" ] && cd .. && return 0
  if [ -n "$1" ]; then
    for x in $(seq 1 "$1"); do
      last_pwd=$(pwd)
      cd .. || return 1
    done
    pwd
  fi
  export OLDPWD="$last_pwd"

  return 1
}

# shellcheck disable=SC2012
# @function: List all file names sorted by name
# @param $1 [Opt] : The column to sort; 9 (filename) by default
function lss() {

  col="${1:-9}"
  command ls -la | sort -k "$col"

  return $?
}

# @function: List all directories recursively (Nth level depth) as a tree
# @param $1 [Req] : The max level depth to walk into
function lt() {

  if __hhs_has "tree"; then
    if [ -n "$1" ] && [ -n "$2" ]; then
      tree "$1" -L "$2"
    elif [ -n "$1" ]; then
      tree "$1"
    else
      tree '.'
    fi
  else
    ls -Rl
  fi

  return $?
}

# @function: Change the shell working directory. Replace the build-in 'cd' with a more flexible one.
function cd() {
  
  local flags path
  
  if [[ '-L' = "${1}" ]] || [[ '-P' = "${1}" ]]; then
    flags="${1}" && shift
  fi
  
  if [ -z "${1}" ]; then
    path="${HOME}"
  elif [ '..' = "${1}" ]; then
    path='..'
  elif [ '.' = "${1}" ]; then
    path=$(command pwd)
  elif [ '-' = "${1}" ]; then
    path="${OLDPWD}"
  elif [ -d "${1}" ]; then
    path="${1}"
  elif [ -e "${1}" ]; then
    path="$(dirname "${1}")"
  fi
  
  if [ ! -d "${path}" ]; then
    echo -e "${RED}Directory \"${1}\" was not found ! ${NC}"
    return 1
  fi
  
  # shellcheck disable=SC2086
  command cd ${flags} "${path}"
  
  return 0
}

# @function: Kills ALL processes specified by $1
# @param $1 [Req] : The process name to kill
function pk() {

  local force_flag=

  if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
    shift
    force_flag='-f'
  fi

  if [[ $# -gt 0 ]]; then
    for nproc in "${@}"; do
      __hhs_process_list -q $force_flag "${nproc}" kill
      echo -e "\033[3A" # Move up 3 times to beautify the output
    done
    echo -e '\n'
  else
    echo "Usage: ${FUNCNAME[0]} <process_name...>"
  fi

  return $?
}

# @function: Generate a random number int the range <min> <max>
# @param $1 [Req] : The minimum range of the number
# @param $2 [Req] : The maximum range of the number
function rand() {

  if [ -n "$1" ] && [ -n "$2" ]; then
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  else
    echo "Usage: ${FUNCNAME[0]} <min-val> <max-val>"
  fi
}

# @function: Convert unicode to hexadecimal
# @param $1..N [Req] : The unicodes to convert
if __hhs_has "python"; then

  function utoh() {

    local result converted uni

    if [[ $# -gt 0 ]]; then
      for x in "$@"; do
        uni="${x:0:4}" # More digits will be ignored
        echo -e "\n[Uni-$uni]: "
        converted=$(print-uni.py "$uni" | hexdump -Cb)
        result=$(awk '
        NR == 1 {printf "  Hex => "; print $2" "$3" "$4}
        NR == 2 {printf "  Oct => "; print $2" "$3" "$4}
        NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
      ' <<< "${converted}")
        echo -e "${result}"
        echo ''
      done
    else
      echo "Usage: ${FUNCNAME[0]} <unicode...>"
      echo ''
      echo '  Notes: unicode is a four digits hexadecimal'
    fi

    return $?
  }
fi
