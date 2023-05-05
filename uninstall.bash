#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090

#  Script: uninstall.bash
# Purpose: Uninstall HomeSetup
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME
"

# Import pre-defined Bash Colors.
[[ -f ~/.bash_colors ]] && \. ~/.bash_colors

# Define the user HOME
HOME=${HOME:-~}

# Shell type
SHELL_TYPE="${SHELL##*/}"

# Define the HomeSetup directory
HHS_HOME=${HHS_HOME:-${HOME}/HomeSetup}

# Dotfiles source location
DOTFILES_DIR="${HHS_HOME}/dotfiles/${SHELL_TYPE}"

# Backup prefix
ORIG_PREFIX="orig"

# HomeSetup configuration directory
HHS_DIR=${HHS_DIR:-"$(basename "$(dirname /Users/hjunior/.hhs/hhsrc.log)")"}

# Flag indicating HHS_DIR removal
REMOVE_HHS_DIR=

# Flag indicating HSPyLib removal
REMOVE_HSPYLIB=

# .dotfiles we will handle
ALL_DOTFILES=()

# Uninstallation type
UNINSTALL_TYPE='normal'

# Find all dotfiles used by HomeSetup according to the current shell type
while IFS='' read -r dotfile; do
  ALL_DOTFILES+=("${dotfile}")
done < <(find "${DOTFILES_DIR}" -maxdepth 1 -name "*.${SHELL_TYPE}" -exec basename {} \;)

# Purpose: Quit the program and exhibits an exit message if specified
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {

  # Unset all declared functions
  unset -f \
    quit usage check_inst_method install_dotfiles \
    clone_repository activate_dotfiles

  test "$1" != '0' -a "$1" != '1' && echo -e "${RED}"
  test -n "$2" -a "$2" != "" && echo -e "${2}"
  test "$1" != '0' -a "$1" != '1' && echo -e "${NC}"
  echo ''
  exit "$1"
}

# Usage message
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
  quit "$1" "$USAGE"
}

check_installation() {

  if [[ -n "${HHS_HOME}" && -d "${HHS_HOME}" ]]; then
    
    echo -e "${ORANGE}"
    [[ -z ${QUIET} ]] && read -rn 1 -p \
      "Also delete HomeSetup config (${HHS_DIR}) files y/[n] ? " REMOVE_HHS_DIR
    [[ -n "${REMOVE_HHS_DIR}" ]] && echo ''
    [[ -z ${QUIET} ]] && read -rn 1 -p \
      "Also uninstall HomeSetup python library and apps (hspylib, vault, clitt and firebase) y/[n] ? " REMOVE_HSPYLIB
    [[ -n "${REMOVE_HSPYLIB}" ]] && echo ''
    
    [[ -n "${REMOVE_HHS_DIR}" ]] && UNINSTALL_TYPE+=' +hhs-dir'
    [[ -n "${REMOVE_HSPYLIB}" ]] && UNINSTALL_TYPE+=' +lib-dir'
    
    echo -e "${NC}"
    echo -e "${WHITE}### Uninstallation Settings ###"
    echo -e "${BLUE}"
    echo -e "  Uninstall Type: ${UNINSTALL_TYPE}"
    echo -e "     Install Dir: ${HHS_HOME}"
    echo -e "        Dotfiles: ${ALL_DOTFILES[*]}"
    echo -e "${NC}"

    echo -e "${YELLOW}"
    read -rn 1 -p "HomeSetup will be completely removed and all backups restored. Continue y/[n] ?" ANS
    echo -e "${NC}"
    [[ -n "$ANS" ]] && echo ''
    if [[ "$ANS" == "y" || "$ANS" == "Y" ]]; then
      uninstall_dotfiles
    else
      quit 1 "Uninstallation cancelled !"
    fi
  else
    quit 2 "Installation files were not found or removed !"
  fi
}

# Remove dotfiles
uninstall_dotfiles() {
  
  cd "${HOME}" || cd ..

  # Remove installed HomeSetup dotfiles
  echo -e "\n${BLUE}Removing installed HomeSetup dotfiles ...${NC}"
  for next in ${ALL_DOTFILES[*]}; do
    dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
    [[ -f "${dotfile}" ]] && \rm -fv "${dotfile}"
  done

  # Removing HomeSetup folders
  [[ -d "${HHS_HOME}" ]] && \rm -rfv "${HHS_HOME:?}"
  [[ -L "${HHS_DIR}/bin" ]] && \rm -rfv "${HHS_DIR:?}/bin"
  
  # Remove HomeSetup .hhs folder
  [[ -n "${REMOVE_HHS_DIR}" ]] && echo ''
  if [[ "${REMOVE_HHS_DIR}" == "y" || "${REMOVE_HHS_DIR}" == 'Y' ]]; then
    [[ -d "${HHS_DIR}" ]] && \rm -rfv "${HHS_DIR:?}" &> /dev/null
  fi

  # Restore original dotfiles
  if [[ -d "${HHS_DIR}" ]]; then
    echo -e "\n${BLUE}Restoring original dotfiles ...${NC}"
    BACKUPS=("$(find "${HHS_DIR}" -iname "*.${ORIG_PREFIX}")")
    for next in ${BACKUPS[*]}; do
      [[ -f "${next}" ]] && \cp -v "${next}" "${HOME}/$(basename "${next%.*}")"
    done
  fi

  # Uninstall HomeSetup python library
  if [[ "${REMOVE_HSPYLIB}" == "y" || "${REMOVE_HSPYLIB}" == 'Y' ]]; then
    # HsPyLib-Vault
    echo -e "\n${BLUE}Removing HomeSetup Vault${NC}"
    python3 -m pip uninstall -y hspylib-vault &> /dev/null \
      || echo -e "${RED}# Unable to uninstall HomeSetup vault !\n${NC}"
    # HsPyLib-Firebase
    echo -e "\n${BLUE}Removing HomeSetup Firebase${NC}"
    python3 -m pip uninstall -y hspylib-firebase &> /dev/null \
      || echo -e "${RED}# Unable to uninstall HomeSetup firebase !\n${NC}"
    # HsPyLib-Clitt
    echo -e "\n${BLUE}Removing HomeSetup Clitt${NC}"
    python3 -m pip uninstall -y hspylib-clitt &> /dev/null \
      || echo -e "${RED}# Unable to uninstall HomeSetup clitt !\n${NC}"
  fi
    
  # Restoring prompts
  export PS1='\[\h:\W \u \$ '
  export PS2="$PS1"
  
  # Removing HomeSetup folder
  [[ -d "${HHS_HOME}" ]] && quit 2 "Failed to uninstall HomeSetup !"

  # Unset aliases and envs
  echo "Unsetting aliases and variables ..."
  unalias -a
  unset "${!HHS_@}"

  echo 'HomeSetup has been successfully uninstalled !'
  echo ''
  echo "* Your old PS1 (prompt) and aliases will be restored next time you open the terminal."
  echo "* Your temporary PS1 => '$PS1'"
  echo ''
}

check_installation

echo '!!! HomeSetup will be gone after you open a new terminal !!!'
