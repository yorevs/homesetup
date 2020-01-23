#!/usr/bin/env bash
# shellcheck disable=SC2206,SC2207

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

  echo '' > /tmp/minput.log # Reset logs
  
  BLACK_BG='\033[40m'
  BLUE_BG='\033[44m'
  SEL_COLOR='\033[1;36m'
  UNSEL_COLOR='\033[0;97m'
  RO_COLOR='\033[0;97m'
  
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

  local input_pad len re_render=1 all_fields=() outfile="$1" cur_field=() field_parts=()
  local f_label f_mode f_type f_max_min_len f_perm f_value f_row f_col label_size=10 value_size=30
  local minlen maxlen cur_index tab_index cur_row cur_col exit_row exit_col err_msg

  if [ -d "$1" ] || [ -s "$1" ]; then
    echo -e "${RED}\"$1\" is a directory or an existing non-empty file !${NC}"
    return 1
  fi

  shift
  all_fields=(${@})
  input_pad=$(printf '%0.1s' " "{1..100})
  len=${#all_fields[*]}
  save-cursor-pos
  disable-line-wrap
  tab_index=0

  while :; do

    # Menu Renderization {
    if [ -n "$re_render" ]; then
      echo "[DEBUG] Render started" >> /tmp/minput.log
      hide-cursor
      # Restore the cursor to the home position
      restore-cursor-pos
      echo -e "${NC}"
      for cur_index in ${!all_fields[*]}; do
        field="${all_fields[$cur_index]}"
        # TODO: Validate field syntax => Label:Mode:Type:Max/Min:Perm:Value
        IFS=':'
        field_parts=(${field})
        f_label="${field_parts[0]}"
        f_mode="${field_parts[1]}"
        f_mode=${f_mode:-input}
        f_type="${field_parts[2]}"
        f_type=${f_type:-any}
        f_max_min_len="${field_parts[3]}"
        f_perm="${field_parts[4]}"
        f_perm=${f_perm:-rw}
        f_max_min_len="${f_max_min_len:-0/30}"
        minlen=${f_max_min_len%/*}
        maxlen=${f_max_min_len##*/}
        f_value="${field_parts[5]}"
        [[ $tab_index -ne $cur_index ]] || printf "${BLUE_BG}%${label_size}s: " "${f_label}"
        [[ $tab_index -eq $cur_index ]] || printf "${BLACK_BG}%${label_size}s: " "${f_label}"
        f_row="$(__hhs_cursor_position row)"
        f_col="$(__hhs_cursor_position col)"
        f_col="$((f_col + ${#f_value}))"
        [ "input" = "${f_mode}" ] && printf "%-${value_size}s" "${f_value}"
        [ "password" = "${f_mode}" ] && printf "%-${value_size}s" "$(sed -E 's/./\*/g' <<< "${f_value}")"
        # printf " %*.*s " 0 $((maxlen - value_size)) "${input_pad}"
        printf "(%${#maxlen}d/%${#maxlen}d)\n" "${#f_value}" "${maxlen}"
        [ -n "${err_msg}" ] && echo -e "${RED}### ${err_msg}${NC}" && sleep 1
        echo ''
        {
          printf "[DEBUG] IDX: %-3s \tTAB-IDX: %-3s \tL: %-20s V: \"%-20s\" \tLen: %s \tM: %8s \tT: %5s \tMin: %2s \tMax: %2s \tP: %2s \Pos: (%s,%s) \n" "${cur_index}" "${tab_index}" "${f_label}" "${f_value}" "${#f_value}" "${f_mode}" "${f_type}" "${minlen}" "${maxlen}" "${f_perm}" "${f_row}" "${f_col}"
        } >> /tmp/minput.log
        # Keep the selected field on hand
        if [[ $tab_index -eq $cur_index ]]; then
          cur_field=(${field_parts[@]})
          cur_row="${f_row}"
          cur_col="${f_col}"
        fi
      done
      echo -e "${BLACK_BG}"
      echo -en "${YELLOW}[Enter] Submit [↑↓] Navigate [Esc] Quit \033[0K"
      echo -en "${NC}"
      # Save the exit cursor position
      exit_row="$(__hhs_cursor_position row)"
      exit_col="$(__hhs_cursor_position col)"
      re_render=
      # Position the cursor on the current tab index
      tput cup "${cur_row}" "${cur_col}"
      show-cursor
      echo "[DEBUG] Render finished" >> /tmp/minput.log
    fi
    IFS="$HHS_RESET_IFS"
    # } Menu Renderization

    # Navigation input {
    IFS= read -rsn1 KEY_PRESS
    case "$KEY_PRESS" in
      $' ' | [a-zA-Z0-9])
        maxlen=${cur_field[3]##*/}
        if [ "rw" = "${cur_field[4]}" ] && [[ ${#cur_field[5]} -lt maxlen ]]; then
          # Append value to the current field
          cur_field[5]="${cur_field[5]}${KEY_PRESS}"
          all_fields[$tab_index]="${cur_field[0]}:${cur_field[1]}:${cur_field[2]}:${cur_field[3]}:${cur_field[4]}:${cur_field[5]}"
          re_render=1
          echo -e "[DEBUG] +CUR_FIELDS: \"${all_fields[$tab_index]}\"" >> /tmp/minput.log
        fi
        ;;
      $'\177') # Backspace
        if [ "rw" = "${cur_field[4]}" ] && [[ ${#cur_field[5]} -ge 1 ]]; then
          # Delete the previous character
          cur_field[5]="${cur_field[5]::${#cur_field[5]}-1}"
          all_fields[$tab_index]="${cur_field[0]}:${cur_field[1]}:${cur_field[2]}:${cur_field[3]}:${cur_field[4]}:${cur_field[5]}"
          re_render=1
          echo -e "[DEBUG] -CUR_FIELDS: \"${all_fields[$tab_index]}\"" >> /tmp/minput.log
        fi
        ;;
      $'\011') # TAB => same as Down arrow
        if [[ $((tab_index + 1)) -lt $len ]]; then
          tab_index=$((tab_index + 1)) && re_render=1
          echo "[DEBUG] TAB pressed" >> /tmp/minput.log
        fi
        ;;
      $'\033') # Handle escape '\e[nX' codes
        IFS= read -rsn2 -t 1 KEY_PRESS
        case "$KEY_PRESS" in
          [A) # Cursor up
            if [[ $((tab_index - 1)) -ge 0 ]]; then
              tab_index=$((tab_index - 1)) && re_render=1
              echo "[DEBUG] CURSOR UP" >> /tmp/minput.log
            fi
            ;;
          [B) # Cursor down
            if [[ $((tab_index + 1)) -lt $len ]]; then
              tab_index=$((tab_index + 1)) && re_render=1
              echo "[DEBUG] CURSOR DOWN" >> /tmp/minput.log
            fi
            ;;
          *) # Escape pressed
            if [[ ${#KEY_PRESS} -eq 1 ]]; then
              echo "[WARN] ESC typed. Exit issued" >> /tmp/minput.log
              break
            fi
            ;;
        esac
        ;;
      $'')
        # TODO validate and write form values to outfile or show error and continue
        echo "[INFO] ENTER typed. Submit issued" >> /tmp/minput.log
        break
        ;;
      *)
        echo "[WARN] Unknown character typed: $KEY_PRESS" >> /tmp/minput.log
        continue
        ;;
    esac
    # } Navigation input

  done
  # Restore exit position
  tput cup "${exit_row}" "${exit_col}"
  show-cursor
  enable-line-wrap
  echo -e "\n${NC}"

  return 0
}
