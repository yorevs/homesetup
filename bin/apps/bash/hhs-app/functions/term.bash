#!/usr/bin/env bash

#  Script: term.bash
# Purpose: Contains HHS-App terminal related functions.
# Created: Apr 29, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

# @purpose: Retrieve/Get/Set the current hostname.
# @param $1 [opt] : The new hostname. If not provided, current hostname is retrieved.
function host-name() {

  local cur_hostname new_hostname ret

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "usage: ${FUNCNAME[0]} [new_hostname]"
  elif [[ -z "${1}" ]]; then
    cur_hostname=$(hostname)
    [[ $ret -eq 0 ]] && echo -e "${GREEN}Your current hostname is: ${HHS_HIGHLIGHT_COLOR}$(cur_hostname)${NC}"
    quit 0
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
          if sudo esed "s/${cur_hostname}/${new_hostname}/g" /etc/hosts &&
             sudo esed "s/${cur_hostname}/${new_hostname}/g" /etc/hostname; then
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
        echo "${ORANGE}Your hostname hasn't changed !${NC}" && quit 2
      fi
    else
      quit 1 "You need 'hostname' installed to use this function !"
    fi
  fi

  quit 0
}

# @purpose: Set/Unset shell options.
function shopts() {

  local mchoose_file title sel_options name option item all_items=()

  while read -r option; do
    name="${option%%=*}" && value="${option#*=}"
    all_items+=("${name// /}=${value// /}")
  done <"${HHS_SHOPTS_FILE}"

  title="${BLUE}Terminal Options${ORANGE}\n"
  title+="Please check the desired terminal options:"
  mchoose_file=$(mktemp)

  if __hhs_mchoose "${mchoose_file}" "${title}" "${all_items[@]}"; then
    read -r -d '' -a sel_options < <(grep . "${mchoose_file}")
    for item in "${all_items[@]}"; do
      option="${item%%=*}"
      if list_contains "${sel_options[*]}" "${option}"; then
        shopt -s "${option}"
      else
        shopt -u "${option}"
      fi
    done
    \rm -f "${mchoose_file}"&>/dev/null
    \shopt | awk '{print $1" = "$2}' >"${HHS_SHOPTS_FILE}" ||
      quit 2 "Unable to create the Shell Options file !"
  fi

  quit 0
}

# @purpose: Display HomeSetup shortcuts/cheatsheets.
function sheets() {
  local filters=("${@}") all_files all_sheets=() mselect_file sel_sheet filter_re mselect_file sheet
  local cheatsheets_dir="${HHS_HOME}/docs/misc/cheatsheets"

  # shellcheck disable=SC2207,SC2211
  all_files=( $(find "${cheatsheets_dir}" -type f -iname "*.*") )
  for file in "${all_files[@]}"; do
    sheet=$(basename "${file}")
    sheet_name=$(echo "${sheet}" | sed 's/\.[^.]*$//' | tr '-' ' ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}; print}')
    filter_re=".*${filters[*]// /|}.*"
    shopt -s nocasematch
    if [[ -z "${filters[*]}" || ${sheet} =~ ${filter_re} || ${sheet_name,,} =~ ${filter_re} ]]; then
      all_sheets+=( "${sheet}" )
    fi
    shopt -u nocasematch
  done

  mselect_file=$(mktemp)
  if __hhs_mselect "${mselect_file}" "Available Cheatsheets (${filter_re}):" "${all_sheets[@]}"; then
    sel_sheet=$(grep . "${mselect_file}")
    sel_file="${cheatsheets_dir}/${sel_sheet}"
    if __hhs_has glow && [[ ${sel_sheet#*.} =~ [Mm][Dd] ]]; then
      glow --style "auto" --mouse --pager --width 120 --all "${sel_file}"
    elif [[ ${sel_sheet#*.} =~ [Pp][Dd][Ff] ]]; then
      open "${sel_file}"
    elif __hhs_has bat; then
      bat --theme "auto" --paging=always --terminal-width=120 "${sel_file}"
    else
      cat "${cheatsheets_dir}/${sel_sheet}"
    fi
    echo ''
    return 0
  fi

  return 1
}
