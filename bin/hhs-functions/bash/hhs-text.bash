#!/usr/bin/env bash

#  Script: hhs-text.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Echo a message in red color into stderr.
# @param $1 [Req] : The message to be echoed.
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

  local search file hl_color="${HHS_HIGHLIGHT_COLOR}"

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
    GREP_COLOR="${hl_color}" grep -Ei --color=always "${search}" "${file}"
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
