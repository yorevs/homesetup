#!/usr/bin/env bash

#  Script: askai.bash
# Purpose: Manager for HomeSetup AskAI integration
# Created: Aug 19, 2024
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# Current plugin name
PLUGIN_NAME="askai"

UNSETS=(
  help version cleanup execute args action db_alias dotfiles
)

PROMPTS_DIR="${HHS_DIR}/askai/prompts"

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

  local args

  # shellcheck disable=SC2206
  args=(${@})
  python3 -m askai -p "${PROMPTS_DIR}/homesetup.txt" "${args[@]}"
  ret_val=$?
  quit ${ret_val}
}
