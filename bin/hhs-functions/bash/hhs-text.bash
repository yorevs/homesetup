#!/usr/bin/env bash

#  Script: hhs-text.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Highlight words from the piped stream.
# @param $1 [Req] : The word to highlight.
# @param $1 [Pip] : The piped input stream.
function __hhs_highlight() {

  local search="$*"
  local hl_color="${HHS_HIGHLIGHT_COLOR}"
  local gflags="-Ei"

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [options]"
  else
    hl_color=${HHS_HIGHLIGHT_COLOR//\e[/}
    hl_color=${HHS_HIGHLIGHT_COLOR/m/}
    while read -r stream; do
      echo "${stream}" | GREP_COLOR="${hl_color}" grep "${gflags}" "${search}"
    done
  fi

  return 0
}

# @function: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function __hhs_json-print() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
    echo "Usage: ${FUNCNAME[0]} <json_string>"
    return 1
  else
    if __hhs_has jq; then
      echo "$1" | jq
    elif __hhs_has json_pp; then
      echo "$1" | json_pp -f json -t json -json_opt pretty indent escape_slash
    fi
  fi

  return 0
}

# @function: Create and/or open a file using the default editor
# @param $1 [Req] : The file path
function __hhs_edit() {
  if [ -n "$1" ]; then
    [ -f "$1" ] || touch "$1" > /dev/null 2>&1
    if [ -n "${HHS_DEFAULT_EDITOR}" ] && ${HHS_DEFAULT_EDITOR} "$1"; then
      echo ''
    elif [ -f "$1" ] && open "$1" > /dev/null 2>&1; then
      echo ''
    elif [ -f "$1" ] && vi "$1"; then
      echo ''
    else
      echo -e "${RED}Unable to find a editor thats fits the file \"$1\""
      return 1
    fi
    
    return 0
  fi
  
  return 1
}