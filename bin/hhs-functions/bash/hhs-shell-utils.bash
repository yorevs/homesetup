#!/usr/bin/env bash

#  Script: hhs-shell-utils.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Search for previous issued commands from history using filters.
# @param $1 [Req] : The searching command.
function __hhs_history() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [command]"
    return 1
  elif [ "$#" -eq 0 ]; then
    history | sort -k2 -k 1,1nr | uniq -f 1 | sort -n | grep "^ *[0-9]*  "
  else
    history | sort -k2 -k 1,1nr | uniq -f 1 | sort -n | grep "$*"
  fi

  return $?
}

# @function: Prints all environment variables on a separate line using filters.
# @param $1 [Opt] : Filter environments.
function __hhs_envs() {

  local pad pad_len filter name value columns

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [regex_filter]"
    return 1
  else
    pad=$(printf '%0.1s' "."{1..60})
    pad_len=40
    columns="$(($(tput cols) - pad_len - 9))"
    filter="$*"
    [ -z "$filter" ] && filter="^[a-zA-Z0-9_]*.*"
    echo ' '
    echo "${YELLOW}Listing all exported environment variables matching [ $filter ]:"
    echo ' '
    IFS=$'\n'
    shopt -s nocasematch
    for v in $(env | sort); do
      name=$(echo "$v" | cut -d '=' -f1)
      value=$(echo "$v" | cut -d '=' -f2-)
      if [[ ${name} =~ ${filter} ]]; then
        echo -en "${HHS_HIGHLIGHT_COLOR}${name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
        echo -en " ${GREEN}=> ${NC}${value:0:$columns} "
        [ "${#value}" -ge "$columns" ] && echo "...${NC}" || echo "${NC}"
      fi
    done
    shopt -u nocasematch
    IFS="$HHS_RESET_IFS"
    echo ' '
  fi

  return 0
}

# @function: Select a shell from the existing shell list
function __hhs_select-shell() {

  local sel_index sel_shell mselect_file avail_shells=()

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} "
  else
    clear
    echo "${YELLOW}@@ Please select your new default shell:"
    echo "-------------------------------------------------------------"
    echo -en "${NC}"
    IFS=$'\n' read -d '' -r -a avail_shells <<< "$(grep '/.*' '/etc/shells')"
    # Add the brew bash/zsh as options
    [ -f '/usr/local/bin/bash' ] && avail_shells+=('/usr/local/bin/bash')
    [ -f '/usr/local/bin/zsh' ] && avail_shells+=('/usr/local/bin/zsh')
    mselect_file=$(mktemp)
    if __hhs_mselect "$mselect_file" "${avail_shells[*]}"; then
      sel_index=$(grep . "$mselect_file")
      sel_shell=${avail_shells[$sel_index]}
      if [ -n "${sel_shell}" ] && [ -f "${sel_shell}" ]; then
        if command chsh -s "${sel_shell}"; then
          clear
          export SHELL="${sel_shell}"
          echo "${ORANGE}Your default shell has changed to => ${GREEN}'$SHELL'"
          echo "${ORANGE}Next time you open a terminal window you will use \"$SHELL\" as your default shell"
        else
          echo "${RED}Unable to change shell to ${sel_shell} ${NC}"
        fi
      fi
    fi
    IFS="$HHS_RESET_IFS"
    echo -e "${NC}"

    [ -f "$mselect_file" ] && command rm -f "$mselect_file"
  fi

  return 0
}
