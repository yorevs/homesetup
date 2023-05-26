#!/usr/bin/env bash

#  Script: hhs-dirs.bash
# Created: May 26, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
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


# @function: Provide a terminal form input with simple validation.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The form fields.
function __hhs_minput() {

  local outfile ret_val=1 title all_fields=() len

  if [[ $# -lt 3 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <title> <form_fields...>"
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the results will be stored.'
    echo '      title       : The text to be displayed before rendering the items.'
    echo '           fields : A list of form fields: Label|Mode|Type|Min/Max len|Perm|Value'
    echo ''
    echo '    Fields: '
    echo '      Field tokens (in-order):'
    echo '                    <Label> : The field label. Consisting only of alphanumeric characters and under‐scores.'
    echo '                     [Mode] : The input mode. One of {[text]|password|checkbox|select|masked}.'
    echo '                     [Type] : The input type. One of {letters|numbers|words|masked|[anything]}.'
    echo '              [Min/Max len] : The minimum and maximum length of characters allowed. Defaults to [0/30].'
    echo '                     [Perm] : The field permissions. One of {r|[rw]}. Where \"r\" for Read Only ; \"rw\" for Read & Write.'
    echo ''
    echo '    Examples: '
    echo '      Form with 4 fields (Name,Age,Password,Role,Accept Conditions): '
    echo "        => ${FUNCNAME[0]} /tmp/out.txt 'Please fill the form below:'     'Name|||5/30|rw|'     'Age|masked|masked|1/3|| ;###'     'Password|password||5|rw|'     'Role|select||4/5|rw|Admin;<User>;Guest'     'Locked||||r|locked value'     'Accept Conditions|checkbox||||' && cat /tmp/out.txt "
    echo ''
    echo '  Notes: '
    echo '    - Optional fields will assume a default value if they are not specified.'
    echo '    - A temporary file is suggested to used with this command: $ mktemp.'
    return 1
  fi

  outfile="${1}"
  shift
  title="${1:-Please fill all fields of the form below}"
  shift

  all_fields=("${@}")
  len=${#all_fields[*]}
  
  if [[ ${len} -lt 1 ]] ; then
    __hhs_errcho "${FUNCNAME[0]}: Invalid number of fields: \"${len}\""
    return 1
  fi
  
  printf -v all_fields_str '%s,' "${all_fields[@]}"
  all_fields_str="${all_fields_str%,}"
  
  echo ''>"${outfile}"
  
  python3 -c """
from clitt.core.tui.minput.input_validator import InputValidator
from clitt.core.tui.minput.minput import MenuInput, minput

if __name__ == \"__main__\":
    it = [\"${all_fields_str//,/\",\"}\"]
    form_fields = MenuInput.builder() \
        .from_tokenized(it) \
        .build()
    minput(form_fields, \"${title}\", \"${outfile}\")
"""

  ret_val=$?
  __hhs_clear && echo -e "${NC}"
  
  return ${ret_val}
}
