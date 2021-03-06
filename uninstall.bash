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

# Import pre-defined Bash Colors
[[ -f ~/.bash_colors ]] && \. ~/.bash_colors

# Define the user HOME
HOME=${HOME:-~}

# Shell type
SHELL_TYPE="${SHELL##*/}"

# Define the HomeSetup directory.
HHS_HOME=${HHS_HOME:-${HOME}/HomeSetup}

# Dotfiles source location
DOTFILES_DIR="${HHS_HOME}/dotfiles/${SHELL_TYPE}"

# .dotfiles we will handle
ALL_DOTFILES=()

# Find all dotfiles used by HomeSetup according to the current shell type
while IFS='' read -r dotfile; do
  ALL_DOTFILES+=("${dotfile}")
done < <(find "${DOTFILES_DIR}" -maxdepth 1 -name "*.${SHELL_TYPE}" -exec basename {} \;)

# Purpose: Quit the program and exhibits an exit message if specified.
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

# Usage message.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
  quit "$1" "$USAGE"
}

check_installation() {

  if [[ -n "${HHS_HOME}" && -d "${HHS_HOME}" ]]; then

    echo -e ''
    echo -e "${WHITE}### Uninstallation Settings ###"
    echo -e "${BLUE}"
    echo -e "  Uninstall Type: remove"
    echo -e "     Install Dir: ${HHS_HOME}"
    echo -e "        Dotfiles: ${ALL_DOTFILES[*]}"
    echo -e "${NC}"

    echo -e "${ORANGE}"
    read -rn 1 -p "HomeSetup will be completely removed and backups restored. Continue y/[n] ?" ANS
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

uninstall_dotfiles() {

  # Remove dotfiles
  echo -e "Removing installed dotfiles ..."
  for next in ${ALL_DOTFILES[*]}; do
    dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
    [[ -f "${dotfile}" ]] && \rm -fv "${dotfile}"
  done

  # shellcheck disable=SC2164
  cd "${HOME}"
  [[ -d "${HHS_HOME}" ]] && \rm -rfv "${HHS_HOME:?}"
  [[ -L "${HHS_DIR}/bin" ]] && \rm -rf "${HHS_DIR:?}/bin"
  echo ''

  # Restore backups
  if [[ -d "${HHS_DIR}" ]]; then
    BACKUPS=("$(find "${HHS_DIR}" -iname "*.orig")")
    echo "Restoring backups ..."
    for next in ${BACKUPS[*]}; do
      [[ -f "${next}" ]] && \cp -v "${next}" "${HOME}/$(basename "${next%.*}")"
    done
    echo ''
  fi
  echo ''

  export PS1='\[\h:\W \u \$ '
  export PS2="$PS1"

  cd "${HOME}" || cd ..

  # Uninstall HomeSetup python library
  echo "${WHITE}Removing HomeSetup python library"
  pip uninstall -y hhslib &> /dev/null

  # Remove .hhs folder
  echo -e "${ORANGE}"
  [[ -z ${QUIET} ]] && read -rn 1 -p 'Also delete HomeSetup config (.hhs) files y/[n] ? ' ANS
  echo -e "${NC}"
  [[ -n "$ANS" ]] && echo ''
  if [[ "$ANS" == "y" || "$ANS" == 'Y' ]]; then
    [[ -d "${HHS_DIR}" ]] && \rm -fv "${HHS_DIR}"
    \rm -fv .prompt .aliasdef .functions .env .aliases 2> /dev/null
  fi

  # Unset aliases and envs
  echo "Unsetting aliases and variables ..."
  unalias -a
  unset "${!HHS_@}"

  echo 'HomeSetup has been uninstalled !'
  echo ''
  echo "* Your old PS1 (prompt) and aliases will be restored next time you open the terminal."
  echo "* Your temporary PS1 => '$PS1'"
  echo ''
}

check_installation

echo '@@@ HomeSetup needs to close this terminal to finish the removal.'
