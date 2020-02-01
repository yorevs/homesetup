#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions


# @function: Generate a random number int the range <min> <max>
# @param $1 [Req] : The minimum range of the number
# @param $2 [Req] : The maximum range of the number
function __hhs_random_number() {

  if [[ $# -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <min-val> <max-val>"
    return 1
  else
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  fi
  
  return 0
}

# @function: Display the decimal ASCII representation of a character
# @param $1 [Req] : The character to display
function __hhs_ascof() {
  
  echo -n "${1}" | od -A n -t d1 | head -n 1 | awk '{print $1}' && return $?
}

# @function: Convert unicode to hexadecimal
# @param $1..N [Req] : The unicodes to convert
if __hhs_has "python"; then

  function __hhs_utoh() {

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
