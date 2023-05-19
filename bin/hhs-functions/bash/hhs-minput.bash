#!/usr/bin/env bash

#  Script: hhs-minput.bash
# Created: Jan 16, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Provide a terminal form input with simple validation.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The form fields.
function __hhs_minput() {

  local outfile ret_val=1 title all_fields=() len mi_modes=() mi_types=()

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
    echo "        => ${FUNCNAME[0]} /tmp/out.txt 'Please fill the form:' 'Name|||5/30|rw|' 'Age||numbers|1/3||' 'Password|password||5|rw|' 'Role||||r|Admin' 'Accept Conditions|checkbox||||' "
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
