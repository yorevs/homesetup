#!/usr/bin/env bash

#  Script: ext-tools.bash
# Purpose: Contains all extended HHS-App functions
# Created: Apr 29, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: Retrieve/Get/Set the current hostname.
# @param $1 [opt] : The new hostname. If not provided, current hostname is retrieved.
function host-name() {

  local cur_hostname new_hostname

  if [[ "$(uname -s)" == "Darwin" ]]; then
    sed_flag="-E"
  else
    sed_flag="-r"
  fi

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "Usage: ${FUNCNAME[0]} [new_hostname]"
  elif [[ -z "${1}" ]]; then
    echo -en "${GREEN}Your current hostname is: ${PURPLE}"
    hostname
    quit $? "${NC}"
  else
    if __hhs_has hostname; then
      cur_hostname=$(hostname)
      new_hostname="${1}"
      [[ -z "${new_hostname}" ]] && read -r -p "${YELLOW}Enter new hostname (ENTER to cancel): ${NC}" new_hostname
      if [[ -n "${new_hostname}" && "${cur_hostname}" != "${new_hostname}" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
          if sudo scutil --set HostName "${new_hostname}"; then
            echo "${GREEN}Your new hostname has changed from \"${cur_hostname}\" to ${PURPLE}\"${new_hostname}\" ${NC} !"
          else
            quit 2 "Failed to change your hostname !"
          fi
        else
          # Change the hostname in /etc/hosts & /etc/hostname
          if sudo sed ${sed_flag} "s/${cur_hostname}/${new_hostname}/g" /etc/hosts && sudo sed ${sed_flag} "s/${cur_hostname}/${new_hostname}/g" /etc/hostname; then
            echo "${GREEN}Your new hostname has changed from \"${cur_hostname}\" to ${PURPLE}\"${new_hostname}\" ${NC} !"
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
      quit 1 "You need 'hostname' installed to use this function !"
    fi
  fi

  quit 0
}
