#!/usr/bin/env bash

#  Script: minput.bash
# Created: Jan 16, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# rl; \rm -f /tmp/out.txt; minput /tmp/out.txt "Name:input:alpha:10/30:rw:Hugo" "Password:password:any:8/30:rw:1234" "Age:input:num:1/3::41" "Role:::5:r:Admin"

function __hhs_cursor_position() {
  exec < /dev/tty
  oldstty=$(stty -g)
  stty raw -echo min 0
  # on my system, the following line can be replaced by the line below it
  echo -en "\033[6n" > /dev/tty
  # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
  IFS=';' read -r -d R -a pos
  stty "$oldstty"
  [ "${1}" = "row" ] && echo "$((${pos[0]:2} - 1))"
  [ "${1}" = "col" ] && echo "$((pos[1] - 1))"

  return 0
}

# @function: Select an option from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The form fields.
function __hhs_minput() {

  if [[ $# -eq 0 ]] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <fields...>"
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the result will be stored.'
    echo '        fields    : A list of form fields matching the folowing syntax:'
    echo '                    <Label:Mode:Type:Max/Min len:Perm:Value>'
    echo '    Fields: '
    echo '             *Label : The field label to be displayed.'
    echo '               Mode : The input mode. One of {input|password}.'
    echo '               Type : The input type. One of {str|num|alpha|any}'
    echo '        Max/Min len : The maximum and minimum amount of characters allowed to be typed.'
    echo '               Perm : The field permissions. One of {r|rw} where (r == Read Only ; rw == Read & Write).'
    echo '              Value : This field is optional. The initial value of the field.'
    echo ''
    echo '    Defaults: '
    echo '      Type = any'
    echo '      Min/Max len = 0/30'
    echo '      Perm = rw'
    echo '      Value = <empty>'
    echo ''
    echo '  Notes: '
    echo '    - Fields marked with * are mandatory'
    echo '    - Optional fields will assume a default value if they are not specified.'
    echo '    - A temporary file is suggested to used with this command: #> mktemp.'
    echo '    - The outfile must not exist or it be an empty file.'
    echo ''
    echo '  Examples: '
    echo '    minput /tmp/out.txt "Name:input:alpha:10/30:rw:" "Age:input:num:::" "Password:password:any:8:rw:"'
    return 1
  fi

  local input_pad len re_render=1 all_fields=() form_values=() outfile="$1" cur_row cur_col
  local f_label f_mode f_type f_max_min_len f_perm f_value minlen maxlen tab_index cur_index
  local exit_row exit_col err_msg cur_field=()

  if [ -d "$1" ] || [ -s "$1" ]; then
    echo -e "${RED}\"$1\" is a directory or an existing non-empty file !${NC}"
    return 1
  fi

  shift
  # shellcheck disable=SC2206
  all_fields=(${@})
  input_pad=$(printf '%0.1s' "_"{1..100})
  len=${#all_fields[*]}
  save-cursor-pos
  disable-line-wrap
  tab_index=0

  while :; do

    # Menu Renderization {
    if [ -n "$re_render" ]; then
      cur_index=0
      hide-cursor
      # Restore the cursor to the home position
      restore-cursor-pos
      echo -e "${NC}"
      for field in "${all_fields[@]}"; do
        # TODO: Validate field syntax => Label:Mode:Type:Max/Min:Perm:Value
        IFS=':'
        # shellcheck disable=SC2206
        field_parts=(${field})
        IFS="$HHS_RESET_IFS"
        f_label="${field_parts[0]}"
        f_mode="${field_parts[1]}"
        f_type="${field_parts[2]}"
        f_max_min_len="${field_parts[3]}" f_perm="${field_parts[4]}"
        f_value="${field_parts[5]}"
        f_mode=${f_mode:-input}
        f_type=${f_type:-any}
        f_max_min_len="${f_max_min_len:-0/30}"
        minlen=${f_max_min_len%/*}
        maxlen=${f_max_min_len##*/}
        f_perm=${f_perm:-rw}
        printf "${WHITE}%10s: " "${f_label}" # Label
        f_row="$(__hhs_cursor_position row)" # Get current cursor row
        f_col="$(__hhs_cursor_position col)" # Get current cursor column
        f_col="$((f_col + ${#f_value}))"     # Increment the row by the length of the current value
        # shellcheck disable=SC2207
        field_parts+=("${f_row}")
        field_parts+=("${f_col}")
        [ "password" = "${f_mode}" ] || printf "${CYAN}%s" "${f_value}"                            # Value
        [ "password" = "${f_mode}" ] && printf "${CYAN}%s" "$(sed -E 's/./\*/g' <<< "${f_value}")" # Hidden value
        printf "${NC}%*.*s" 0 $((maxlen - ${#f_value})) "${input_pad}"                             # Input space
        printf "${NC} (%s/%s)\n" "${#f_value}" "${maxlen}"                                         # Typed/Remaining characters
        [ -n "${err_msg}" ] && echo -e "${RED}### ${err_msg}${NC}" && sleep 1
        echo ''
        {
          printf "TAB-I: %-3s L: %-20s V: %-20s M: %8s \tT: %5s \tMin: %2s \tMax: %2s \tP: %2s \Pos: (%s,%s) \n" "${tab_index}" "${f_label}" "${f_value}" "${f_mode}" "${f_type}" "${minlen}" "${maxlen}" "${f_perm}" "${f_row}" "${f_col}"
        } >> /tmp/minput.log
        if [[ $tab_index -eq $cur_index ]]; then
          cur_row=${f_row}
          cur_col=${f_col}
          cur_field=("${field_parts[@]}")
        fi
        cur_index=$((cur_index + 1))
      done
      echo ''
      echo -en "${YELLOW}[Enter] Submit [↑↓] Navigate [Esc] Quit \033[0K"
      echo -en "${NC}"
      exit_row="$(__hhs_cursor_position row)"
      exit_col="$(__hhs_cursor_position col)"
      re_render=
      # Position the cursor on the current tab index
      tput cup "${cur_row}" "${cur_col}"
      show-cursor
    fi
    # } Menu Renderization

    # Navigation input {
    read -rs -n 1 KEY_PRESS
    case "$KEY_PRESS" in
      $' ' | [a-zA-Z0-9])
        [ -z "$KEY_PRESS" ] && KEY_PRESS=' '
        # Append value to the current field
        cur_field[5]+="${KEY_PRESS}"
        [ "password" = "${cur_field[1]}" ] && printf "${CYAN}%s" "$(sed -E 's/./\*/g' <<< "${KEY_PRESS}")"
        [ "password" = "${cur_field[1]}" ] || printf "${CYAN}%s" "${KEY_PRESS}"
        # TODO: update all_fields with the updated value
        ;;
      $'\033') # Handle escape '\e[nX' codes
        read -rsn2 -t 1 KEY_PRESS
        case "$KEY_PRESS" in
          [A) # Cursor up
            if [[ $((tab_index - 1)) -ge 0 ]]; then
              tab_index=$((tab_index - 1)) && re_render=1
            fi
            ;;
          [B) # Cursor down
            if [[ $((tab_index + 1)) -lt $len ]]; then
              tab_index=$((tab_index + 1)) && re_render=1
            fi
            ;;
          *)
            if [[ ${#KEY_PRESS} -eq 1 ]]; then
              enable-line-wrap
              # Restore exit position
              tput cup "${exit_row}" "${exit_col}"
              echo -e "\n${NC}"
              return 1
              echo '' && break
            fi
            ;;
        esac
        ;;
      $'')
        # TODO validate and submit form
        echo "ENTER typed. Submit form" >> /tmp/minput.log
        ;;
      *)
        echo "Unknown thing typed" >> /tmp/minput.log
        ;;
    esac
    # } Navigation input

  done
  # Restore exit position
  tput cup "${exit_row}" "${exit_col}"
  show-cursor
  enable-line-wrap
  echo -e "\n${NC}"
  echo "${form_values[*]}" > "$outfile"

  return 0
}
