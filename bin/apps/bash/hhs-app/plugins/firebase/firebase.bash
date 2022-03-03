#!/usr/bin/env bash

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: HHS plugin required function
function help() {
  echo "Usage: hhs firebase execute {setup,upload,download} {db_alias}"
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  python3 -m firebase -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  ARGS=(${@})
  action="${ARGS[0]}"
  db_alias="${ARGS[1]}"
  dotfiles=(
    '.aliases' '.aliasdef' '.cmd_file' '.colors' '.env' '.path' 
    '.firebase' '.inputrc' '.profile' '.prompt' '.saved_dirs'
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
