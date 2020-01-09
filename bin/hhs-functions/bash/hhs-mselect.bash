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
    echo "Usage: ${FUNCNAME[0]} <output_file> <option1 ...>"
    echo ''
    echo 'Notes: '
    echo '  - If only one option is available, mselect will select it and return.'
    echo '  - A temporary file is suggested to used with this function: [mktemp].'
    echo '  - The outfile must not exist or be empty.'
    return 1
  fi

  if [ -d "$1" ] || [ -s "$1" ]; then
    echo -e "${RED}\"$1\" is a directory or an existing non-empty file!${NC}"
    return 1
  fi

  HHS_MSELECT_MAXROWS=${HHS_MSELECT_MAXROWS:=15}

  local all_options=() outfile="$1" sel_index=0 show_from=0 re_render=1 len show_to diff_index typed_index columns option_line 

  show_to="$((HHS_MSELECT_MAXROWS - 1))"
  diff_index="$((show_to - show_from))"
  shift
  # shellcheck disable=SC2206
  all_options=(${@})
  len=${#all_options[*]}

  # When only one option is provided, select the typed_index 0 and return
  [ "$len" -eq 1 ] && echo "0" > "$outfile" && return 0
  save-cursor-pos
  disable-line-wrap

  while :; do
    columns="$(($(tput cols) - 7))"
    hide-cursor

    # Menu Renderization {
    if [ -n "$re_render" ]; then
      echo ''
      for idx in $(seq "$show_from" "$show_to"); do
        [[ $idx -ge $len ]] && break # When the number of items is lower than the maxrows, skip the other lines
        option_line="${all_options[idx]:0:$columns}"
        # Erase current line before repaint
        echo -ne "\033[2K\r"
        [[ $idx -eq $sel_index ]] && echo -en "${HHS_HIGHLIGHT_COLOR}" # Highlight the selected line
        printf " %.${#len}d  %0.4s %s" "$((idx + 1))" '>' "$option_line" # Print the option line
        # Check if the text fits the screen and print it, otherwise print '...'
        [[ ${#option_line} -ge $columns ]] && echo -e "\033[4D\033[K..."
        echo -e "${NC}"
      done
      echo ''
      echo -n "${YELLOW}[Enter] Select [↑↓] Navigate [Q] Quit [1..${len:0:5}] Goto: "
      re_render=
    fi
    # } Menu Renderization

    # Navigation input {
    read -rs -n 1 KEY_PRESS
    case "$KEY_PRESS" in
      'q' | 'Q') # Exit
        show-cursor
        enable-line-wrap
        echo -e "\n${NC}"
        return 1
        ;;
      [1-9]) # When a number is typed, try to scroll to index
        show-cursor
        typed_index="$KEY_PRESS"
        echo -en "$KEY_PRESS"
        while [[ $typed_index -lt $len ]]; do
          read -rs -n 1 ANS2
          [ -z "$ANS2" ] && break
          echo -en "$ANS2"
          typed_index="${typed_index}${ANS2}"
        done
        hide-cursor
        # Erase the index typed
        echo -ne "\033[$((${#typed_index} + 1))D\033[K"
        if [[ "$typed_index" =~ ^[0-9]*$ ]] && [[ $typed_index -ge 1 ]] && [[ $typed_index -le $len ]]; then
          show_to=$((typed_index - 1))
          [ "$show_to" -le "$diff_index" ] && show_to=$diff_index
          show_from=$((show_to - diff_index))
          sel_index=$((typed_index - 1))
        fi
        ;;
      $'\033') # Handle escape '\e[nX' codes
        read -rsn2 KEY_PRESS
        case "$KEY_PRESS" in
          [A) # Move the cursor upwards
            if [[ $sel_index -eq $show_from ]] && [[ $show_from -gt 0 ]]; then
              show_from=$((show_from - 1))
              show_to=$((show_to - 1))
              re_render=1
            elif [[ $sel_index -eq 0 ]]; then
              continue
            fi
            [ $((sel_index - 1)) -ge 0 ] && sel_index=$((sel_index - 1))
            ;;
          [B) # Move the cursor downwards
            if [[ $sel_index -eq $show_to ]] && [[ $((show_to + 1)) -lt $len ]]; then
              show_from=$((show_from + 1))
              show_to=$((show_to + 1))
              re_render=1
            elif [[ $((sel_index + 1)) -ge $len ]]; then
              continue
            fi
            [[ $((sel_index + 1)) -lt $len ]] && sel_index=$((sel_index + 1))
            ;;
        esac
        ;;
      '') # Select current item and exit
        echo '' && break
        ;;
    esac
    # } Navigation input

    # Erase current line and restore the cursor to the home position
    restore-cursor-pos
    re_render=1
  done

  show-cursor
  enable-line-wrap
  echo -e "${NC}"
  echo "$sel_index" > "$outfile"

  return 0
}
