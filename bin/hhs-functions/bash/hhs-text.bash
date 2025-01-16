#!/usr/bin/env bash

#  Script: hhs-text.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Highlight words from the piped stream.
# @param $1 [Req] : The word to highlight.
# @param $1 [Pip] : The piped input stream.
function __hhs_highlight() {

  local search file hl_color="${HHS_HIGHLIGHT_COLOR}"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} <text_to_highlight> [filename]"
    echo ''
    echo '  Notes: '
    echo '    filename: If not provided, stdin will be used instead.'
    return 1
  else
    search="${1:-.*}"
    file="${2:-/dev/stdin}"
    hl_color=${HHS_HIGHLIGHT_COLOR//\e[/}
    hl_color=${HHS_HIGHLIGHT_COLOR/m/}
    GREP_COLOR="${hl_color}" grep -Ei --color=always "${search}" "${file}"
  fi

  return 0
}

# @function: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function __hhs_json_print() {

  local json="${1}"

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} <json_string>"
    return 1
  else
    if __hhs_has jq; then
      echo "${json}" | jq
    elif __hhs_has json_pp; then
      echo "${json}" | json_pp -f json -t json -json_opt pretty indent escape_slash
    else
      echo "${BLUE}${json}${NC}"
    fi
  fi

  return $?
}

# @function: Convert string into it's decimal ASCII representation.
# @param $1 [Req] : The string to convert.
function __hhs_ascof() {

  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} <string>"
    return 1
  elif __hhs_has od; then
    echo ''
    echo -en "${GREEN}Dec:${NC}"
    echo -en "${@}" | od -An -t uC | head -n 1 | sed 's/^ */ /g'
    echo -en "${GREEN}Hex:${NC}"
    echo -en "${@}" | od -An -t xC | head -n 1 | sed 's/^ */ /g'
    echo -en "${GREEN}Str:${NC}"
    echo -e " ${*}"
    echo ''
  fi

  return 0
}

if __hhs_has "hexdump"; then

  # @function: Convert unicode to hexadecimal.
  # @param $1..$N [Req] : The unicode values to convert.
  function __hhs_utoh() {

    local result converted uni ret_val=1

    if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "usage: ${FUNCNAME[0]} <4d-unicode...>"
      echo ''
      echo '  Notes: '
      echo '    - unicode is a four digits hexadecimal number. E.g:. F205'
      echo '    - exceeding digits will be ignored'
      return 1
    else
      echo ''
      for next in "$@"; do
        hexa="${next:0:4}"
        # More digits will be ignored
        uni="$(printf '%04s' "${hexa}")"
        [[ ${uni} =~ [0-9A-Fa-f]{4} ]] || continue
        echo -e "[${HHS_HIGHLIGHT_COLOR}Unicode:'\u${uni}'${NC}]"
        converted=$(python3 -c "import struct; print(bytes.decode(struct.pack('<I', int('${uni}', 16)), 'utf_32_le'))" | hexdump -Cb)
        ret_val=$?
        result=$(awk '
        NR == 1 {printf "  Hex => "; print "\\\\x"$2"\\\\x"$3"\\\\x"$4}
        NR == 2 {printf "  Oct => "; print "\\"$2"\\"$3"\\"$4}
        NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
        ' <<<"${converted}")
        echo -e "${GREEN}${result}${NC}"
        echo ''
      done
    fi

    return ${ret_val}
  }
fi
