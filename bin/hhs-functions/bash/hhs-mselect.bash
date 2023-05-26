#!/usr/bin/env bash

#  Script: hhs-mselect.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Select an option from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The array of items.
function __hhs_mselect() {
  
  local outfile all_options=() all_options_str len ret_val
  
  if [[ $# -lt 3 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <title> <items...>"
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the result will be stored.'
    echo '      title       : The text to be displayed before rendering the items.'
    echo '      items       : The items to be displayed for selecting.'
    echo ''
    echo '    Examples: '
    echo '      Select a number from 1 to 100:'
    echo "        => ${FUNCNAME[0]} /tmp/out.txt 'Please select one option' {1..100} && cat /tmp/out.txt"
    echo ''
    echo '  Notes: '
    echo '    - If only one option is available, mselect will select it and return.'
    echo '    - A temporary file is suggested to used with this command: $ mktemp.'
    echo '    - The outfile must not exist or it be an empty file.'
    return 1
  fi

  HHS_TUI_MAX_ROWS=${HHS_TUI_MAX_ROWS:=15}
  outfile="$1"
  shift
  title="$1"
  shift
  all_options=("${@}")
  len=${#all_options[@]}

  [[ "${len}" -le 1 ]] && echo "${all_options[0]}" >"${outfile}" && return 0
  
  printf -v all_options_str '%s,' "${all_options[@]}"
  all_options_str="${all_options_str%,}"
  
  echo ''>"${outfile}"
  
  python3 -c """
from clitt.core.tui.mselect.mselect import mselect
from clitt.core.tui.tui_preferences import TUIPreferences

if __name__ == \"__main__\":
    TUIPreferences(max_rows=${HHS_TUI_MAX_ROWS})
    it = [\"${all_options_str//,/\",\"}\"]
    mselect(it, \"${title}\", \"${outfile}\")
"""

  ret_val=$?
  __hhs_clear && echo -e "${NC}"
  
  return ${ret_val}
}
