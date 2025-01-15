#!/usr/bin/env bash

#  Script: term.bash
# Purpose: Contains all extra HHS-App functions
# Created: Apr 29, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

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

# @purpose: Display a table of terminal shortcuts.
function shorts() {
  echo ''
  echo "
  +-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Terminal Shortcuts -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
  | Shortcut                | Description                                              |
  |-------------------------+----------------------------------------------------------|
  | Tab                     | Auto-complete command or file name                       |
  | Ctrl + _                | Undo the last action                                     |
  |-------------------------+----------------------------------------------------------|
  | Ctrl + T (with FZF)     | Select a file using fzf TUI                              |
  | Ctrl + R (with FZF)     | Search the history using fzf TUI                         |
  |-------------------------+----------------------------------------------------------|
  | Ctrl + A                | Move cursor to the beginning of the line                 |
  | Ctrl + E                | Move cursor to the end of the line                       |
  | Ctrl + K                | Cut text from the cursor to the end of the line          |
  | Ctrl + U                | Cut text from the cursor to the beginning of the line    |
  | Ctrl + Y                | Paste text that was cut with: Ctrl + K or Ctrl + U       |
  | Ctrl + L                | Clear the terminal screen                                |
  | Ctrl + C                | Cancel the current command                               |
  | Ctrl + D                | Logout of the current shell                              |
  | Ctrl + Z                | Suspend the current command                              |
  | Ctrl + R (no fzf)       | Reverse search through command history                   |
  | Ctrl + F                | Move cursor forward one character                        |
  | Ctrl + B                | Move cursor backward one character                       |
  | Ctrl + P                | Previous command in command history                      |
  | Ctrl + N                | Next command in command history                          |
  | Ctrl + S                | Stop output to the terminal                              |
  | Ctrl + Q                | Resume output to the terminal                            |
  | Ctrl + W                | Cut the word before the cursor                           |
  | Ctrl + T (no fzf)       | Swap the last two characters before the cursor           |
  | Ctrl + H                | Delete the character before the cursor                   |
  | Ctrl + J                | Equivalent to Enter key                                  |
  | Ctrl + V                | Insert a literal character (used for special characters) |
  |-------------------------+--------------------------------------------------------- |
  | Ctrl + X then Ctrl + E  | Edit command in the default editor                       |
  | Ctrl + X then Ctrl + C  | Close the current window                                 |
  | Ctrl + Shift + T        | Open a new terminal tab                                  |
  | Ctrl + Shift + N        | Open a new terminal window                               |
  " | __hhs_highlight '(Tab|Ctrl) [^|]*'

  return 0
}
