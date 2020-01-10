#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: uninstall.bash
# Purpose: Uninstall HomeSetup
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME
"

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

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

  # Dotfiles used by HomeSetup
  ALL_DOTFILES=(
    "bash_aliases"
    "bash_colors"
    "bash_env"
    "bash_functions"
    "bash_profile"
    "bash_prompt"
    "bashrc"
  )

  if [ -n "$HHS_HOME" ] && [ -d "$HHS_HOME" ]; then

    echo "${BLUE}"
    echo '#'
    echo '# Uninstall settings:'
    echo "# - HHS_HOME: $HHS_HOME"
    echo "# - METHOD: Remove"
    echo "# - FILES: ${ALL_DOTFILES[*]}"
    echo "#${NC}"

    echo "${RED}"
    read -r -n 1 -p "HomeSetup will be completely removed and backups restored. Continue y/[n] ?" ANS
    echo "${NC}"
    [ -n "$ANS" ] && echo ''

    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
      uninstall_dotfiles
    else
      quit 1 "Uninstallation cancelled!"
    fi
  else
    quit 2 "Installation files were not found or removed !"
  fi
}

uninstall_dotfiles() {

  echo -e "Removing installed dotfiles ..."
  for next in ${ALL_DOTFILES[*]}; do
    test -n "$next" -a -f "$HOME/.${next}" && command rm -fv "$HOME/.${next}"
  done

  # shellcheck disable=SC2164
  cd "$HOME"
  [ -d "$HHS_HOME" ] && command rm -rfv "$HHS_HOME"
  [ -L "$HHS_DIR/bin" ] || [ -d "$HHS_DIR/bin" ] && command rm -f "$HHS_DIR/bin"
  echo ''

  if [ -d "$HHS_DIR" ]; then
    BACKUPS=("$(find "$HHS_DIR" -iname "*.orig")")
    echo "Restoring backups ..."
    for next in ${BACKUPS[*]}; do
      [ -f "${next}" ] && command cp -v "${next}" "${HOME}/$(basename "${next%.*}")"
    done
    echo ''
    [ -d "$HHS_DIR" ] && command rm -rfv "$HHS_DIR"
  fi
  echo ''

  echo "Unsetting aliases and variables ..."
  unalias -a
  unset HHS_HOME
  unset HHS_DIR
  unset HHS_VERSION
  export PS1='\[\h:\W \u \$ '
  export PS2="$PS1"

  echo "HomeSetup successfully removed."
  echo "* To reload your old dotfiles type: #> \. ~/.bashrc"
  echo "* Your old PS1 (prompt) and aliases will be restored next time you open the terminal."
  echo "* Your temporary PS1 => '$PS1'"
  echo ''
}

check_installation
