#!/usr/bin/env bash

#  Script: ext-tools.bash
# Purpose: Contains all extended HHS-App functions
# Created: Apr 29, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: Retrieve/Get/Set the current hostname.
function host-name() {

  local cur_hostn new_hostn
  
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "Usage: ${FUNCNAME[0]} [new_hostname]"
  elif [[ -z "${1}" ]]; then
    echo -en "${GREEN}Your current hostname is: ${PURPLE}"
    hostname
    quit $? "${NC}"
  else
    if __hhs_has hostname; then
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
    else
      quit 1 "You need 'hostname'installed to use this function !" 
    fi
  fi

  quit 0
}
