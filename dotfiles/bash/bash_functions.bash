#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: bash_functions.bash
# Purpose: This file is used to define some shell tools
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_functions"

# Load all function files prefixed with 'hhs-`
for file in $(find "${HHS_HOME}/bin/hhs-functions/bash" -type f -name "hhs-*.bash" | sort --unique); do
  source "${file}" || __hhs_log "ERROR" "Unable to source file: ${file}"
done

# Load all functions that were previously aliased
for file in $(find "${HHS_HOME}/bin/dev-tools/bash" -type f -name "*.bash" | sort --unique); do
  source "${file}" || __hhs_log "ERROR" "Unable to source file: ${file}"
done

# Unalias any hhs found because we need this name to use for HomeSetup
unalias hhs &> /dev/null
__hhs_has 'hhs' && __hhs_log "ERROR" "'hhs' is already defined: $(command -v 'hhs')"

# @function: Invoke the hhs application manager
# @param $* [Opt] : All parameters are passed to hhs.bash
function __hhs() {
  if [[ -z "$1" ]]; then
    __hhs_change_dir "${HHS_HOME}" || return 1
  else
    hhs.bash "${@}" || return 1
  fi

  return $?
}
