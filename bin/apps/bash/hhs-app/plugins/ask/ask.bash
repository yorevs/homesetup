#!/usr/bin/env bash

#  Script: ask.bash
# Purpose: Manager for HomeSetup AskAI integration
# Created: Aug 19, 2024
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# Current plugin name
PLUGIN_NAME="ask"

UNSETS=(
  help version cleanup execute
)

# @purpose: HHS plugin required function
function help() {
  [[ -n "${HHS_AI_ENABLED}" ]] && python3 -m ${PLUGIN_NAME} -h
  exit $?
}

# @purpose: HHS plugin required function
function version() {
  [[ -n "${HHS_AI_ENABLED}" ]] && python3 -m ${PLUGIN_NAME} -v
  exit $?
}

# @purpose: HHS plugin required function
function cleanup() {
  unset -f "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {

  [[ -n "${HHS_AI_ENABLED}" ]] || quit 1 "AskAI is not installed. Visit ${HHS_ASKAI_URL} for installation instructions"

  if python3 -m askai -r rag "$@" 2>&1; then
    quit 0
  fi

  quit 1 "Failed to execute AskAI"
}
