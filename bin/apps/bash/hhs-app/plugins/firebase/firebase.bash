#!/usr/bin/env bash

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current plugin name
PLUGIN_NAME="firebase"

UNSETS=(
  help version cleanup execute args action db_alias dotfiles
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
  unset -f "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {

  local args action db_alias dotfiles=()

  # shellcheck disable=SC2206
  args=(${@})
  action="${args[0]}"
  db_alias="${args[1]}"

  # Find all dotfiles
  dotfiles+=()
  IFS=''
  while read -r dotfile; do
    [[ "${dotfile}" != *.last_update ]] && dotfiles+=("${dotfile}")
  done < <(find "${HHS_DIR}" -maxdepth 1 -type f -name ".*" -exec basename {} \;)
  IFS="${OLDIFS}"

  echo ''
  pushd "${HHS_DIR}" &>/dev/null || exit 1

  if [[ 'upload' == "${action}" ]]; then
    python3 -m firebase upload dotfiles."${db_alias}" "${dotfiles[@]}"
  elif [[ 'download' == "${action}" ]]; then
    python3 -m firebase download dotfiles."${db_alias}"
  elif [[ 'setup' == "${action}" ]]; then
    python3 -m firebase setup
  else
    python3 -m firebase "${args[@]}"
  fi
  ret_val=$?

  popd &>/dev/null || exit 1
  echo -e "${NC}"

  quit ${ret_val}
}
