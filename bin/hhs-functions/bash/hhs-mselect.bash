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
# @param $2 [Req] : The array of items.
function __hhs_mselect() {

  if [[ $# -eq 0 ]] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} <output_file> <items...>"
    echo ''
    echo '    Arguments: '
    echo '      output_file : The output file where the result will be stored.'
    echo ''
    echo '  Notes: '
    echo '    - If only one option is available, mselect will select it and return.'
    echo '    - A temporary file is suggested to used with this command: #> mktemp.'
    echo '    - The outfile must not exist or it be an empty file.'
    return 1
  fi

  if [ -d "$1" ] || [ -s "$1" ]; then
    echo -e "${RED}\"$1\" is a directory or an existing non-empty file !${NC}"
    return 1
  fi

  HHS_MENU_MAXROWS=${HHS_MENU_MAXROWS:=15}

  local all_options=() outfile sel_index=0 show_from=0 re_render=1 selector
  local index_len len show_to diff_index typed_index columns option_line
  
  outfile="$1"
  show_to="$((HHS_MENU_MAXROWS - 1))"
  diff_index="$((show_to - show_from))"
  shift
  all_options=("${@}")
  len=${#all_options[*]}
  echo "[DEBUG] MSELECT => IFS = $(ascof "$IFS")  LEN = ${len}  CONTENTS = [ ${all_options[*]} ]" >> /tmp/minput.txt

  # When only one option is provided, select the typed_index 0 and return
  [ "$len" -eq 1 ] && echo "0" > "$outfile" && return 0
  save-cursor-pos
  disable-line-wrap

  while :; do

    # Menu Renderization {
    if [ -n "$re_render" ]; then
      columns="$(($(tput cols) - 7))"
      hide-cursor
      # Restore the cursor to the home position
      restore-cursor-pos
      echo -e "${NC}"
      for idx in $(seq "$show_from" "$show_to"); do
        selector=' '
        [[ $idx -ge $len ]] && break # When the number of items is lower than the maxrows, skip the other lines
        option_line="${all_options[idx]:0:$columns}"
        # Erase current line before repaint
        echo -ne "\033[2K\r"
        [[ $idx -eq $sel_index ]] && echo -en "${HHS_HIGHLIGHT_COLOR}" && selector='>'
        printf " %.${#len}d  %0.4s %s" "$((idx + 1))" "$selector" "$option_line"
        # Check if the text fits the screen and print it, otherwise print '...'
        [[ ${#option_line} -ge $columns ]] && echo -e "\033[4D\033[K..."
        echo -e "${NC}"
      done
      echo ''
      echo -en "${YELLOW}[Enter] Select  [↑↓] Navigate  [Q] Quit  [1..${len:0:5}] Goto: \033[0K"
      unset re_render
      show-cursor
    fi
    # } Menu Renderization

    # Navigation input {
    IFS= read -rsn 1 keypress
    case "${keypress}" in
      'q' | 'Q') # Exit requested
        enable-line-wrap
        echo -e "\n${NC}"
        return 1
        ;;
      [[:digit:]]) # An index was typed
        typed_index="${keypress}"
        echo -en "${keypress}" && index_len=1
        while [[ ${#typed_index} -lt ${#len} ]]; do
          read -rs -n 1 numpress
          [ -z "${numpress}" ] && break
          [[ ! "${numpress}" =~ ^[0-9]*$ ]] && unset typed_index && break
          typed_index="${typed_index}${numpress}"
          echo -en "${numpress}" && index_len=$((index_len + 1))
        done
        echo -ne "\033[${index_len}D\033[K"
        if [[ $typed_index -ge 1 ]] && [[ $typed_index -le $len ]]; then
          show_to=$((typed_index - 1))
          [ "$show_to" -le "$diff_index" ] && show_to=$diff_index
          show_from=$((show_to - diff_index))
          sel_index=$((typed_index - 1)) && re_render=1
        fi
        ;;
      $'\033') # Handle escape '\e[nX' codes
        IFS= read -rsn2 keypress
        case "${keypress}" in
          [A) # Cursor up
            if [[ $sel_index -eq $show_from ]] && [[ $show_from -gt 0 ]]; then
              show_from=$((show_from - 1))
              show_to=$((show_to - 1))
            elif [[ $sel_index -eq 0 ]]; then
              continue
            fi
            if [[ $((sel_index - 1)) -ge 0 ]]; then
              sel_index=$((sel_index - 1)) && re_render=1
            fi
            ;;
          [B) # Cursor down
            if [[ $sel_index -eq $show_to ]] && [[ $((show_to + 1)) -lt $len ]]; then
              show_from=$((show_from + 1))
              show_to=$((show_to + 1))
            elif [[ $((sel_index + 1)) -ge $len ]]; then
              continue
            fi
            if [[ $((sel_index + 1)) -lt $len ]]; then
              sel_index=$((sel_index + 1)) && re_render=1
            fi
            ;;
        esac
        ;;
      $'') # Keep the current index and exit
        echo '' && break
        ;;
    esac
    # } Navigation input

  done

  show-cursor
  enable-line-wrap
  echo -e "${NC}"
  echo "$sel_index" > "$outfile"

  return 0
}
