#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Generate a random number int the range <min> <max> (all limits included).
# @param $1 [Req] : The minimum range of the number.
# @param $2 [Req] : The maximum range of the number.
function __hhs_random() {

  if [[ $# -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <min> <max>"
    return 1
  else
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  fi

  return 0
}

# @function: Convert string into it's decimal ASCII representation.
# @param $1 [Req] : The string to convert.
function __hhs_ascof() {
  
  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <character>"
    return 1
  fi
  echo "${GREEN}Str:${NC} ${*}"
  echo -n "${GREEN}Hex:${NC}"
  echo -n "${@}" | od -A n -t d1 | head -n 1 | sed 's/ \{2,\}/ /g'
  
  return $?
}

# @function: Convert unicode to hexadecimal
# @param $1..$N [Req] : The unicode values to convert
function __hhs_utoh() {

  local result converted uni ret_val=1
  
  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <4d-unicode>"
    echo ''
    echo '  Notes: '
    echo '    - unicode is a four digits hexadecimal. E.g:. FADE'
    echo '    - digits exceeding four will be ignored.'
    return 1
  else
    for x in "$@"; do
      uni="${x:0:4}" # More digits will be ignored
      echo "[Unicode:'\u${uni}']"
      converted=$(python3 -c "import struct; print(bytes.decode(struct.pack('<I', int('${uni}', 16)), 'utf_32_le'))" | hexdump -Cb)
      ret_val=$?
      result=$(awk '
      NR == 1 {printf "  Hex => "; print "\\\\x"$2"\\\\x"$3"\\\\x"$4}
      NR == 2 {printf "  Oct => "; print "\\"$2"\\"$3"\\"$4}
      NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
    ' <<<"${converted}")
      echo -e "${result}"
      echo ''
    done
  fi

  return ${ret_val}
}


# @function: Open a file or URL with the default program.
# @param $1 [Req] : The url or filename to open.
function __hhs_open() {
  
  local filename="$1"
  
  if __hhs_has open && \open "${filename}"; then
    return $?
  elif __hhs_has xdg-open && \xdg-open "${filename}"; then
    return $?
  else
    __hhs_errcho "${FUNCNAME[0]}: Unable to open \"${filename}\". No suitable application found !"
  fi

  return 1
}

# @function: Create and/or open a file using the default editor.
# @param $1 [Req] : The file path.
function __hhs_edit() {

  local filename="$1" editor="${HHS_DEFAULT_EDITOR}"
  
  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <file_path>"
    return 1
  else
    [[ -s "${filename}" ]] || touch "${filename}" >/dev/null 2>&1
    [[ -s "${filename}" ]] || __hhs_errcho "${FUNCNAME[0]}: Unable to create file \"${filename}\""
    
    if [[ -n "${editor}" ]] && __hhs_has "${editor}" && ${editor} "${filename}"; then
      return $?
    elif __hhs_has gedit && \gedit "${filename}"; then
      return $?
    elif __hhs_has emacs && \emacs "${filename}"; then
      return $?
    elif __hhs_has vim && \vim "${filename}"; then
      return $?
    elif __hhs_has vi && \vi "${filename}"; then
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: Unable to find a suitable editor for the file \"${filename}\" !"
    fi
  fi

  return 1
}
