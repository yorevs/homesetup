#!/usr/bin/env bash

#  Script: hhs-text.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Echo a message in red color and to stderr.
function __hhs_errcho() {
  
  if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <message>"
    return 1
  else
    echo -e "${RED}${*}${NC}" 1>&2
    echo ''
  fi

  return $?
}

# @function: Highlight words from the piped stream.
# @param $1 [Req] : The word to highlight.
# @param $1 [Pip] : The piped input stream.
function __hhs_highlight() {

  local search file hl_color="${HHS_HIGHLIGHT_COLOR}" gflags="-Ei"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <text_to_highlight> [filename]"
    echo ''
    echo '  Notes: '
    echo '    filename: If not provided, stdin will be used instead'
    return 1
  else
    search="${1:-.*}"
    file="${2:-/dev/stdin}"
    hl_color=${HHS_HIGHLIGHT_COLOR//\e[/}
    hl_color=${HHS_HIGHLIGHT_COLOR/m/}
    while read -r stream; do
      echo "${stream}" | GREP_COLOR="${hl_color}" grep "${gflags}" "${search}"
    done < "${file}"
  fi

  return 0
}

# @function: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function __hhs_json_print() {

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <json_string>"
    return 1
  else
    if __hhs_has jq; then
      echo "$1" | jq
    elif __hhs_has json_pp; then
      echo "$1" | json_pp -f json -t json -json_opt pretty indent escape_slash
    else
      echo "$1"
    fi
  fi

  return 0
}

# @function: Create and/or open a file using the default editor
# @param $1 [Req] : The file path
function __hhs_edit() {

  if [[ -n "$1" ]]; then
    [[ -f "$1" ]] || touch "$1" > /dev/null 2>&1
    [[ -f "$1" ]] || __hhs_errcho "${FUNCNAME[0]}: Unable to create file \"$1\""
    if [[ -n "${HHS_DEFAULT_EDITOR}" ]] && ${HHS_DEFAULT_EDITOR} "$1"; then
      echo ''
    elif open "$1" > /dev/null 2>&1; then
      echo ''
    elif vi "$1"; then
      echo ''
    else
      __hhs_errcho "${FUNCNAME[0]}: Unable to find a editor that fits the file \"$1\""
      return 1
    fi

    return 0
  fi

  return 1
}
