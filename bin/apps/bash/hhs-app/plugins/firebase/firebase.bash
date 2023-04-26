#!/usr/bin/env bash

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Current plugin name
PLUGIN_NAME="firebase"

UNSETS=(
  help version cleanup execute ARGS action db_alias dotfiles
)

# @purpose: HHS plugin required function
function help() {
  python3 -m ${PLUGIN_NAME} -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python3 -m ${PLUGIN_NAME} -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  
  local ARGS action db_alias dotfiles
  
  ARGS=(${@})
  action="${ARGS[0]}"
  db_alias="${ARGS[1]}"
  dotfiles=(
    '.aliases' '.aliasdef' '.cmd_file' '.colors' '.env' '.path'
    'firebase.properties' '.inputrc' '.profile' '.prompt' '.saved_dirs'
  )
  pushd "${HHS_DIR}" &>/dev/null || exit 1
  if [[ 'upload' == "${action}" ]]; then 
    python3 -m firebase upload dotfiles."${db_alias}" "${dotfiles[@]}"
  elif [[ 'download' == "${action}" ]]; then
    python3 -m firebase download dotfiles."${db_alias}"
  elif [[ 'setup' == "${action}" ]]; then 
    python3 -m firebase setup 
  else
    python3 -m firebase "${ARGS[@]}"
  fi
  popd &>/dev/null || exit 1

  exit $?
}
