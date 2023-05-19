#!/usr/bin/env bash

#  Script: hhs-mchoose.bash
# Created: Jan 14, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Choose options from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The array of items.
function __hhs_mchoose() {

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <output_file> <title> <items...>"
    echo ''
    echo '    Options: '
    echo '      -c  : All options are initially checked instead of unchecked.'
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the results will be stored.'
    echo '      title       : The text to be displayed before rendering the items.'
    echo '      items       : The items to be displayed for choosing. Must be greater than 1.'
    echo ''
    echo '    Examples: '
    echo '      Choose numbers from 1 to 20 (start with all options checked):'
    echo "        => ${FUNCNAME[0]} /tmp/out.txt 'Mark the desired options' {1..20} && cat /tmp/out.txt"
    echo '      Choose numbers from 1 to 20 (start with all options unchecked):'
    echo "        => ${FUNCNAME[0]} -c /tmp/out.txt 'Mark the desired options' {1..20} && cat /tmp/out.txt"
    echo ''
    echo '  Notes: '
    echo '    - A temporary file is suggested to used with this command: $ mktemp.'
    echo '    - The outfile must not exist or it be an empty file.'
    return 1
  fi

  HHS_TUI_MAX_ROWS=${HHS_TUI_MAX_ROWS:=15}

  local outfile title all_options=() len checked='False' ret_val

  [[ '-c' = "${1}" ]] && shift && checked='True'

  HHS_TUI_MAX_ROWS=${HHS_TUI_MAX_ROWS:=15}
  outfile="$1"
  shift
  title="$1"
  shift
  all_options=("${@}")
  len=${#all_options[@]}
  
  if [[ ${len} -le 1 ]] ; then
    __hhs_errcho "${FUNCNAME[0]}: Invalid number of items: \"${len}\""
    return 1
  fi
  
  printf -v all_options_str '%s,' "${all_options[@]}"
  all_options_str="${all_options_str%,}"
  
  echo ''>"${outfile}"

  python3 -c """
from clitt.core.tui.mchoose.mchoose import mchoose
from clitt.core.tui.tui_preferences import TUIPreferences

if __name__ == \"__main__\":
    TUIPreferences(max_rows=${HHS_TUI_MAX_ROWS})
    it = [\"${all_options_str//,/\",\"}\"]
    mchoose(it, ${checked}, \"${title}\", \"${outfile}\")
"""

  ret_val=$?
  __hhs_clear && echo -e "${NC}"
  
  return ${ret_val}
}
