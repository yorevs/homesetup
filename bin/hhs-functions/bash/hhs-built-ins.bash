#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Generate a random number int the range <min> <max> (all limits included).
# @param $1 [Req] : The minimum range of the number.
# @param $2 [Req] : The maximum range of the number.
function __hhs_random_number() {

  if [[ $# -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <min-val> <max-val>"
    return 1
  else
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  fi

  return 0
}

# @function: Display the decimal ASCII representation of a character.
# @param $1 [Req] : The character to display.
function __hhs_ascof() {

  [[ $# -eq 0 || '-h' == "$1" ]] && echo "Usage: ${FUNCNAME[0]} <character>" && return 1
  echo -n "${1}" | od -A n -t d1 | head -n 1 | awk '{print $1}' && return $?
}

# @function: Open a file or URL with the default program.
# @param $1..$N [Req] : The url or program arguments to be passed to open.
function __hhs_open() {
  if [[ "Darwin" == "${HHS_MY_OS}" ]]; then
    __hhs_has 'open' && \open "$@" && return 0
  elif [[ "Linux" == "${HHS_MY_OS}" ]]; then
    __hhs_has 'xdg-open' && \xdg-open "$@" && return 0
    __hhs_has 'vi' && \vi "$@" && return 0
  fi

  return $?
}

# @function: Create and/or open a file using the default editor
# @param $1 [Req] : The file path
function __hhs_edit() {

  local filename="$1" editor="${HHS_DEFAULT_EDITOR}"
  
  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <file_path>"
    return 1
  else
    [[ -f "${filename}" ]] || touch "${filename}" >/dev/null 2>&1
    [[ -f "${filename}" ]] || __hhs_errcho "${FUNCNAME[0]}: Unable to create file \"${filename}\""
    
    if [[ -n "${editor}" ]] && command -v "${editor}" && ${editor} "${filename}"; then
      return $?
    elif vi "${filename}"; then
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: Unable to find a editor for the file \"${filename}\""
    fi
  fi

  return 1
}

# @function: Convert unicode to hexadecimal
# @param $1..$N [Req] : The unicode values to convert
if __hhs_has "python3"; then

  function __hhs_utoh() {

    local result converted uni

    if [[ $# -gt 0 ]]; then
      for x in "$@"; do
        uni="${x:0:4}" # More digits will be ignored
        echo "[Unicode-'\u${uni}']"
        converted=$(python3 -c "import struct; print(bytes.decode(struct.pack('<I', int('${uni}', 16)), 'utf_32_le'))" | hexdump -Cb)
        result=$(awk '
        NR == 1 {printf "  Hex => "; print $2" "$3" "$4}
        NR == 2 {printf "  Oct => "; print $2" "$3" "$4}
        NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
      ' <<<"${converted}")
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
