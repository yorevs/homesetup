#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains all HHS-App built-in functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# @purpose: Provide a help for __hhs functions
function help() {

  usage 0
}

# @purpose: List all HHS App Plug-ins and Functions
# @param $1 [opt] : Instead of a formatted listing, flat the commands for completion.
function list() {

  if [[ "$1" == "opts" ]]; then
    for next in "${PLUGINS[@]}"; do echo -n "${next} "; done
    for next in "${HHS_APP_FUNCTIONS[@]}"; do echo -n "${next} "; done
    echo ''
    quit 0
  else
    echo ' '
    echo "${YELLOW}HomeSetup Application Manager"
    echo ' '
    echo " ${YELLOW}---- Plugins"
    echo ' '
    for idx in "${!PLUGINS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Registered plug-in => ${HHS_HIGHLIGHT_COLOR}\"${PLUGINS[$idx]}\"${NC}"
    done

    echo ' '
    echo " ${YELLOW}---- Functions"
    echo ' '
    for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
      printf "${WHITE}%.2d. " "$((idx + 1))"
      echo -e "Registered built-in function => ${HHS_HIGHLIGHT_COLOR}\"${HHS_APP_FUNCTIONS[$idx]}\"${NC}"
    done
  fi

  quit 0 ' '
}

# @purpose: Search for all __hhs_functions describing it's containing file name and line number.
function funcs() {

  register_hhs_functions

  echo "${YELLOW}Available HomeSetup Functions"
  echo ' '
  for idx in "${!HHS_FUNCTIONS[@]}"; do
    printf "${WHITE}%.2d. " "$((idx + 1))"
    echo -e "Registered __hhs_<function> => ${HHS_HIGHLIGHT_COLOR}\"${HHS_FUNCTIONS[$idx]}\"${NC}"
  done

  quit 0 ' '
}

# @purpose: Open the HomeSetup GitHub project board for the current version.
function board() {

  local repo_url="https://github.com/yorevs/homesetup/projects/1"

  echo "${GREEN}Opening HomeSetup board from: ${repo_url} ${NC}"
  open "${repo_url}" && quit 0 ' '

  quit 1 "Failed to open url \"${repo_url}\" !"
}

# @purpose: Retrieve/Get/Set the current hostname.
function host-name() {

  local cur_hostn new_hostn

  if [[ -z "${1}" ]]; then
    echo -en "${GREEN}Your current hostname is: ${PURPLE}"
    hostname
    quit $? "${NC}"
  else
    cur_hostn=$(hostname)
    new_hostn="${1}"
    [[ -z "${new_hostn}" ]] && read -r -p "${YELLOW}Enter new hostname (ENTER to cancel): ${NC}" new_hostn
    if [[ -n "${new_hostn}" && "${cur_hostn}" != "${new_hostn}" ]]; then
      if [[ "$(uname -s)" == "Darwin" ]]; then
        if sudo scutil --set HostName "${new_hostn}"; then
          echo "${GREEN}Your new hostname has changed from \"${cur_hostn}\" to ${PURPLE}\"${new_hostn}\" ${NC} !"
        else
          quit 2 "Failed to change your hostname !"
        fi
      else
        # Change the hostname in /etc/hosts & /etc/hostname
        if sudo ised "s/${cur_hostn}/${new_hostn}/g" /etc/hosts && sudo ised "s/${cur_hostn}/${new_hostn}/g" /etc/hostname; then
          echo "${GREEN}Your new hostname has changed from \"${cur_hostn}\" to ${PURPLE}\"${new_hostn}\" ${NC} !"
          read -rn 1 -p "${YELLOW}Press 'y' key to reboot now: ${NC}" ANS
          if [[ "$ANS" == "y" || "$ANS" == "Y" ]]; then
            sudo reboot
          fi
        else
          quit 2 "Failed to change your hostname !"
        fi
      fi
    else
      echo "${ORANGE}Your hostname hasn't changed !${NC}" && quit 1
    fi
  fi

  quit 0
}
