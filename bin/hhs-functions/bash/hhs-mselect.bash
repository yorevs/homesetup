#!/usr/bin/env bash

#  Script: hhs-mselect.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Select an option from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The array of options.
function __hhs_mselect() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <option1 option2 ...>"
    echo ''
    echo 'Notes: '
    echo '  - If only one option is available, mselect will select it and return.'
    echo '  - A temporary file is suggested to used with this function: [mktemp].'
    echo '  - The outfile must not exist or be empty.'
    return 1
  fi

  test -d "$1" -o -s "$1" && echo -e "${RED}\"$1\" is a directory or an existing non-empty file!${NC}" && return 1

  HHS_MSELECT_MAXROWS=${HHS_MSELECT_MAXROWS:=15}

  local len all_options=() sel_index=0 show_from=0 show_to diff_index index='' outfile="$1" columns opt_str

  show_to="$((HHS_MSELECT_MAXROWS - 1))"
  diff_index="$((show_to - show_from))"
  shift
  # shellcheck disable=SC2206
  all_options=(${@})
  len=${#all_options[*]}

  # When only one option is provided, select the index 0 and return
  [ "$len" -eq 1 ] && echo "0" >"$outfile" && return 0
  save-cursor-pos
  disable-line-wrap

  while :; do
    columns="$(($(tput cols) - 7))"
    hide-cursor
    echo ''

    for i in $(seq "$show_from" "$show_to"); do
      opt_str="${all_options[i]:0:$columns}"
      # Erase current line before repaint
      echo -ne "\033[2K\r"
      [ "$i" -ge "$len" ] && break
      if [ "$i" -ne $sel_index ]; then
        # Print the unselected line
        printf " %.${#len}d  %0.4s %s" "$((i + 1))" ' ' "$opt_str"
      else
        # Print the selected line
        printf "${HHS_HIGHLIGHT_COLOR} %.${#len}d  %0.4s %s" "$((i + 1))" '>' "$opt_str"
      fi
      if [ "${#opt_str}" -ge "$columns" ]; then
        echo -e "\033[4D\033[K...${NC}"
      else 
        echo -e "${NC}"
      fi
    done

    echo "${YELLOW}"
    read -rs -n 1 -p "${YELLOW}[Enter] Select [↑↓] Navigate [Q] Quit [1..${len:0:5}] Goto: " KEY_PRESS

    case "$KEY_PRESS" in
    'q'|'Q') # Exit
      show-cursor
      enable-line-wrap
      echo -e "\n${NC}"
      return 1
      ;;
    [1-9]) # When a number is typed, try to scroll to index
      show-cursor
      index="$KEY_PRESS"
      echo -en "$KEY_PRESS"
      while [ "${#index}" -lt "${#len}" ]; do
        read -rs -n 1 ANS2
        [ -z "$ANS2" ] && break
        echo -en "$ANS2"
        index="${index}${ANS2}"
      done
      hide-cursor
      # Erase the index typed
      echo -ne "\033[$((${#index} + 1))D\033[K"
      if [[ "$index" =~ ^[0-9]*$ ]] && [ "$index" -ge 1 ] && [ "$index" -le "$len" ]; then
        show_to=$((index - 1))
        [ "$show_to" -le "$diff_index" ] && show_to=$diff_index
        show_from=$((show_to - diff_index))
        sel_index=$((index - 1))
      fi
      ;;
    $'\033') # Handle escape '\e[nX' codes
      read -rsn2 KEY_PRESS
      case "$KEY_PRESS" in
      [A) # Move the cursor upwards
        if [ "$sel_index" -eq "$show_from" ] && [ "$show_from" -gt 0 ]; then
          show_from=$((show_from - 1))
          show_to=$((show_to - 1))
        fi
        [ $((sel_index - 1)) -ge 0 ] && sel_index=$((sel_index - 1))
        ;;
      [B) # Move the cursor downwards
        if [ "$sel_index" -eq "$show_to" ] && [ "$((show_to + 1))" -lt "$len" ]; then
          show_from=$((show_from + 1))
          show_to=$((show_to + 1))
        fi
        [ $((sel_index + 1)) -lt "$len" ] && sel_index=$((sel_index + 1))
        ;;
      esac
      ;;
    '') # Select current item and exit
      echo '' && break
      ;;
    esac

    # Erase current line and restore the cursor to the home position
    restore-cursor-pos
  done

  show-cursor
  enable-line-wrap
  echo -e "${NC}"
  echo "$sel_index" >"$outfile"

  return 0
}
