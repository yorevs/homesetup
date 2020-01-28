#!/usr/bin/env bash

#  Script: hhs-minput.bash
# Created: Jan 16, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Retrieve the current cursor position on screen. ## This is a very expensive call
function __hhs_minput_curpos() {

  local row col

  # Sometimes the cursor position is not comming, so make sure we have data to retrieve
  while
    [ -z "$row" ] || [ -z "$col" ]
    exec < /dev/tty
    disable-echo
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    enable-echo
    if [[ ${#pos} -gt 0 ]]; then
      row="${pos[0]:2}"
      col="${pos[1]}"
      if [[ $row =~ ^[1-9]+$ ]] && [[ $col =~ ^[1-9]+$ ]]; then
        echo "$((row - 1)),$((col - 1))"
        return 0
      else
        unset row
        unset col
      fi
    fi
  do :; done

  return 1
}

# @function: Select an option from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The form fields.
function __hhs_minput() {

  UNSELECTED_BG='\033[40m'
  SELECTED_BG='\033[44m'
  SECURE_ICN='\357\200\243'
  INSECURE_ICN='\357\201\204'
  LOCKED_ICN='\357\212\250'
  ERROR_ICN='\357\201\227'

  if [[ $# -lt 2 ]] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <fields...>"
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the result will be stored.'
    echo '        fields    : A list of form fields: Label|Mode|Type|Min/Max len|Perm|Value'
    echo ''
    echo '    Fields: '
    echo "            <Label> : The field label. Consisting only of alphanumeric characters and under‐scores."
    echo '             [Mode] : The input mode. One of {[input]|password}.'
    echo '             [Type] : The input type. One of {letter|number|alphanumeric|[any]}.'
    echo '      [Min/Max len] : The minimum and maximum length of characters allowed. Defauls to [0/30].'
    echo '             [Perm] : The field permissions. One of {r|[rw]}. Where \"r\" for Read Only ; \"rw\" for Read & Write.'
    echo '            [Value] : The initial value of the field. This field may not be blank if the field is read only.'
    echo ''
    echo '  Notes: '
    echo '    - Optional fields will assume a default value if they are not specified.'
    echo '    - A temporary file is suggested to used with this command: #> mktemp.'
    echo '    - The outfile must not exist or be an empty file.'
    echo ''
    echo '  Examples: '
    echo '    minput /tmp/out.txt "Name|||5/30|rw|" "Age||number|1/3||" "Password|password||5|rw|" "Role|||||Admin"'
    return 1
  fi

  local outfile="${1}" label_size value_size form_title all_fields=() cur_field=() field_parts=() all_pos=()
  local f_label f_mode f_type f_max_min_len f_perm f_value f_row f_col f_pos err_msg dismiss_timeout re_render=1
  local len minlen offset margin maxlen idx tab_index cur_row cur_col val_regex mi_modes mi_types file_contents

  if [ -d "$1" ] || [ -s "$1" ]; then
    echo -e "${RED}\"$1\" is a directory or an existing non-empty file !${NC}"
    return 1
  fi

  shift
  form_title="${form_title:-Please fill all fields of the form below}"

  # Validate field syntax => "Label:Mode:Type:Min/Max len:Perm:Value" ...{
  mi_modes=('input' 'password')
  mi_types=('letter' 'number' 'alphanumeric' 'any')
  label_size=10 # Default Label column length
  value_size=30 # Default Value column length
  all_fields=("${@}")
  for idx in "${!all_fields[@]}"; do
    field="${all_fields[${idx}]}"
    IFS='|' read -rsa field_parts <<< "${field}"
    f_label="${field_parts[0]}"
    [[ ! $f_label =~ ^[a-zA-Z0-9_]+$ ]] && echo "${RED}Invalid label \"${f_mode}\". Must contain only [a-zA-Z0-9_] characters ${NC}" && return 1
    f_mode="${field_parts[1]}"
    f_mode=${f_mode:-input}
    [[ ! "${mi_modes[*]}" == *"${f_mode}"* ]] && echo "${RED}Invalid mode \"${f_mode}\". Valid modes are: [${mi_modes[*]}] ${NC}" && return 1
    f_type="${field_parts[2]}"
    f_type=${f_type:-any}
    [[ ! "${mi_types[*]}" == *"${f_type}"* ]] && echo "${RED}Invalid type \"${f_type}\". Valid types are: [${mi_types[*]}] ${NC}" && return 1
    f_max_min_len="${field_parts[3]}"
    f_max_min_len="${f_max_min_len:-0/30}"
    [[ ! ${f_max_min_len} =~ ^[0-9](\/[0-9]+$)* ]] && echo "${RED}Invalid Min/Max length \"${f_max_min_len}\" ${NC}" && return 1
    minlen=${f_max_min_len%/*}
    maxlen=${f_max_min_len##*/}
    [[ ${minlen} -gt ${maxlen} ]] && echo "Maximum length \"${maxlen}\" must be greater than Minimum length \"${minlen}\"" && return 1
    f_perm="${field_parts[4]}"
    f_perm=${f_perm:-rw}
    [[ ! "r rw" == *"${f_perm}"* ]] && echo "${RED}Invalid permission \"${f_perm}\". Valid permissions are: [r rw] ${NC}" && return 1
    f_value="${field_parts[5]:0:${maxlen}}"
    [[ "r" == "${f_perm}" ]] && [ -z "${f_value}" ] && echo "Read only fields can't have empty values." && return 1
    [[ ${#f_label} -gt ${label_size} ]] && label_size=${#f_label}
    [[ ${maxlen} -gt ${value_size} ]] && value_size=${maxlen}
    all_fields[${idx}]="${f_label}|${f_mode}|${f_type}|${f_max_min_len}|${f_perm}|${f_value}"
  done
  # }

  len=${#all_fields[*]}
  disable-line-wrap
  tab_index=0
  clear

  echo -e "\033[2K${YELLOW}${form_title}${NC}\n"
  save-cursor-pos

  while :; do

    # Menu Renderization {
    if [ -n "$re_render" ]; then
      hide-cursor
      # Restore the cursor to the home position
      restore-cursor-pos
      enable-echo
      for idx in "${!all_fields[@]}"; do
        field="${all_fields[${idx}]}"
        IFS='|' read -rsa field_parts <<< "${field}"
        f_label="${field_parts[0]}"
        f_mode="${field_parts[1]}"
        f_type="${field_parts[2]}"
        f_max_min_len="${field_parts[3]}"
        f_perm="${field_parts[4]}"
        f_value="${field_parts[5]}"
        maxlen=${f_max_min_len##*/}
        if [[ ${tab_index} -ne ${idx} ]]; then
          printf "${UNSELECTED_BG}  %${label_size}s: " "${f_label}"
        else
          printf "${SELECTED_BG}  %${label_size}s: " "${f_label}"
          f_pos="${all_pos[${idx}]:-$(__hhs_minput_curpos)}" # Buffering the all positions to avoid calling __hhs_minput_curpos
          f_row="${f_pos%,*}" && f_col="${f_pos#*,}"
          f_col="$((f_col + ${#f_value}))"
          all_pos[${idx}]="${f_pos}"
        fi
        offset=${#f_value}
        margin=$((10 - (${#maxlen} + ${#offset})))
        [ "input" = "${f_mode}" ] && icon="${INSECURE_ICN}" && printf "%-${value_size}s" "${f_value}"
        [ "password" = "${f_mode}" ] && icon="${SECURE_ICN}" && printf "%-${value_size}s" "$(sed -E 's/./\*/g' <<< "${f_value}")"
        [ "r" = "${f_perm}" ] && icon="${LOCKED_ICN}"
        printf " ${icon}  %d/%d" "${#f_value}" "${maxlen}" # Remaining/max characters
        printf "%*.*s${UNSELECTED_BG}\033[0K" 0 "${margin}" "$(printf '%0.1s' " "{1..60})"
        # Display any previously set error message
        if [[ ${tab_index} -eq ${idx} ]] && [ -n "${err_msg}" ]; then
          err_msg="${err_msg}"
          dismiss_timeout=$((1 + (${#err_msg} / 25)))
          printf "${RED} ${ERROR_ICN}  %s" "${err_msg}"
          disable-echo
          # Discard any garbage typed by the user while showing the error
          IFS= read -rsn1000 -t ${dismiss_timeout} err_msg < "/dev/tty"
          enable-echo
          echo -en "\033[$((${#err_msg} + 4))D\033[0K${NC}" # Remove the message after the timeout
          unset err_msg
        fi
        echo -e '\n'
        # Keep the selected field on hand
        if [[ ${tab_index} -eq ${idx} ]]; then
          IFS='|' read -rsa cur_field <<< "${all_fields[${idx}]}"
          cur_row="${f_row}"
          cur_col="${f_col}"
        fi
      done
      echo -e "${UNSELECTED_BG}"
      echo -en "${YELLOW}[Enter] Submit  [↑↓] Navigate  [Tab] Next  [Esc] Quit\033[0K"
      echo -en "${NC}"
      unset re_render
    fi
    # } Menu Renderization

    # Position the cursor to edit the current field
    tput cup "${cur_row}" "${cur_col}"

    # Navigation input {
    show-cursor
    IFS= read -rsn1 keypress
    disable-echo
    case "${keypress}" in
      $'\011') # Handle TAB => Validate and move next. First case statement because next one also captures it
        minlen=${cur_field[3]%/*}
        if [[ ${minlen} -le ${#cur_field[5]} ]]; then
          if [[ $((tab_index + 1)) -lt $len ]]; then
            tab_index=$((tab_index + 1))
          else
            tab_index=0
          fi
        else
          err_msg="This field does not match the minimum length of ${minlen}"
        fi
        ;;
      $'\177') # Handle backspace
        if [ "rw" = "${cur_field[4]}" ] && [[ ${#cur_field[5]} -ge 1 ]]; then
          cur_field[5]="${cur_field[5]::${#cur_field[5]}-1}"
          all_fields[${tab_index}]="${cur_field[0]}|${cur_field[1]}|${cur_field[2]}|${cur_field[3]}|${cur_field[4]}|${cur_field[5]}"
        elif [ "r" = "${cur_field[4]}" ]; then
          err_msg="This field is read only !"
        fi
        ;;
      [[:alpha:]] | [[:digit:]] | [[:space:]] | [[:punct:]]) # Handle an input
        f_mode="${cur_field[1]}"
        f_type="${cur_field[2]}"
        maxlen=${cur_field[3]##*/}
        if [ "rw" = "${cur_field[4]}" ] && [[ ${#cur_field[5]} -lt maxlen ]]; then
          case "${f_type}" in
            'letter') val_regex='^[a-zA-Z ]*$' ;;
            'number') val_regex='^[0-9]*$' ;;
            'alphanumeric') val_regex='^[a-zA-Z0-9 ]*$' ;;
            *) val_regex='.*' ;; # FIXME This expression is rejecting á, ç and similar.
          esac
          if [[ "${keypress}" =~ ${val_regex} ]]; then
            # Append value to the current field if the value matches the input type
            cur_field[5]="${cur_field[5]}${keypress}"
            all_fields[${tab_index}]="${cur_field[0]}|${cur_field[1]}|${cur_field[2]}|${cur_field[3]}|${cur_field[4]}|${cur_field[5]}"
          else
            err_msg="This field only accept ${f_type}s !"
          fi
        elif [ "r" = "${cur_field[4]}" ]; then
          err_msg="This field is read only !"
        fi
        ;;
      $'\033') # Handle escape '\e[nX' codes
        IFS= read -rsn2 -t 1 keypress
        case "${keypress}" in
          [A) # Cursor up
            if [[ $((tab_index - 1)) -ge 0 ]]; then
              tab_index=$((tab_index - 1))
            else
              continue
            fi
            ;;
          [B) # Cursor down
            if [[ $((tab_index + 1)) -lt $len ]]; then
              tab_index=$((tab_index + 1))
            else
              continue
            fi
            ;;
          *) # Escape pressed
            if [[ "${#keypress}" -eq 1 ]]; then
              break
            fi
            ;;
        esac
        ;;
      $'') # Validate & Save the form and exit
        file_contents=''
        for idx in ${!all_fields[*]}; do
          f_max_min_len=$(cut -d '|' -f4 <<< "${all_fields[${idx}]}")
          minlen="${f_max_min_len%/*}"
          f_label=$(tr '[:lower:]' '[:upper:]' <<< "${all_fields[${idx}]%%|*}")
          f_value="${all_fields[${idx}]##*|}"
          if [[ ${#f_value} -lt ${minlen} ]]; then
            err_msg="Field \"${f_label}\" doesn't meet the required length of ${minlen} !"
            tab_index=${idx}
            unset file_contents
            break
          else
            file_contents+="${f_label}=${f_value}\n"
          fi
        done
        if [ -n "${file_contents}" ]; then
          echo -en "${file_contents}" > "${outfile}"
          break
        fi
        ;;
      *)
        unset keypress
        ;;
    esac
    # } Navigation input
    re_render=1
  done
  cls
  echo -e "${NC}"

  return 0
}
