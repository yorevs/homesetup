#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: bash_functions.bash
# Purpose: This file is used to define some shell tools
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# Fontawesome icons
CROSS_ICN="\xef\x81\x97"
CHECK_ICN="\xef\x81\x98"
STAR_ICN="\xef\x80\x85"
ALIAS_ICN="\xef\x87\xba \xef\x81\xa1"
FUNC_ICN="\xef\x84\xae"

# Load bash environment variables to use in here
[[ -f "${HOME}/.bash_env" ]] && source "${HOME}/.bash_env"

# Load bash colors to use in here
[[ -f "${HOME}/.bash_colors" ]] && source "${HOME}/.bash_colors"

# Load all function files prefixed with 'hhs-`
for file in $(find "${HHS_HOME}/bin/hhs-functions/bash" -type f -name "hhs-*.bash" | sort); do
  source "$file"
done

# Load all functions that were previously aliased
for file in $(find "${HHS_HOME}/bin/dev-tools/bash" -type f -name "*.bash" | sort); do
  source "$file"
done

# Unalias any hhs found because we need this name to use for HomeSetup
unalias hhs &> /dev/null

# @function: Invoke the hhs application manager
# @param $* [Opt] : All parameters are passed to hhs.bash
function hhs() {
  if [[ -z "$1" ]]; then
    cd "${HHS_HOME}" || return 1
  else
    hhs.bash "${@}" || return 1
  fi

  return 0
}
