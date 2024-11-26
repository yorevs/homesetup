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

# Current script version.
VERSION="$(pip show hspylib-askai | grep Version)"

# Current plugin name
PLUGIN_NAME="ask"

UNSETS=(
  help version cleanup execute
)

# Usage message
USAGE="usage: ${APP_NAME} <question>

    _        _
   / \   ___| | __
  / _ \ / __| |/ /
 / ___ \\__ \   <
/_/   \_\___/_|\_\\

  HomeSetup AI integration ${VERSION}.

    arguments:
      question    : the question to make to the AI about HomeSetup.
"

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && source "${HHS_DIR}/bin/app-commons.bash"

# @purpose: HHS plugin required function
function help() {
  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin ${VERSION}"
  quit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset -f "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  local args

  [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]] && usage 0
  [[ "$1" == "-v" || "$1" == "--version" ]] && version

  [[ -n "${HHS_AI_ENABLED}" ]] || quit 1 "AskAI is not installed. Visit ${HHS_ASKAI_URL} for installation instructions"

  # Filter out options starting with - followed by letters
  args=()
  for arg in "$@"; do
    if [[ ! "$arg" =~ ^-[a-zA-Z] ]]; then
      args+=("$arg")
    fi
  done

  if python3 -m askai -r rag "${args[@]}" 2>&1; then
    quit 0
  fi

  quit 1 "Failed to execute AskAI"

}
