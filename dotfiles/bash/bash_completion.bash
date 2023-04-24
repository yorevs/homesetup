#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: bash_completion.bash
# Purpose: This file is used to configure all bash auto completions
# Created: Jan 14, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file
#
# Thanks to: https://github.com/git/git/tree/master/contrib/completion
# Thanks to: Built-in docker scripts. *Requires bash_complete
# Thanks to: https://github.com/gradle/gradle-completion
# Thanks to: https://github.com/cloudfoundry/cli/blob/master/ci/installers/completion/cf
# Thanks to: https://github.com/Bash-it/bash-it/blob/master/completion/available/brew.completion.bash

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_completion"

# HomeSetup auto-completions directory
AUTO_CPL_D="${HHS_DIR}/bin"

# Represents all loaded auto-completions
BASH_COMPLETIONS=

# @function: Check and add completion for tool if found in HHS completions dir.
# @param $1 [Req] : The command to find completion script.
function __hhs_check_completion() {
  unset skip_completion
  completion=$(basename "${1}")
  completion=${completion//-completion.bash/}
  __hhs_log "DEBUG" "Checking completion: ${completion}"
  case "${completion}" in
  'docker'*)
    docker info &>/dev/null && skip_completion='NO'
    ;;
  *)
    command -v "${completion}" &>/dev/null && skip_completion='NO'
    ;;
  esac
  if [[ "${skip_completion}" == 'NO' ]]; then
    if [[ -f "${AUTO_CPL_D}/${completion}-completion.bash" ]]; then
      __hhs_log "INFO" "Loading completion: ${AUTO_CPL_D}/${completion}-completion.bash"
      __hhs_source "${AUTO_CPL_D}/${completion}-completion.bash"
      BASH_COMPLETIONS+="${completion} "
    fi
  else
    __hhs_log "WARN" "Skipped completion: ${AUTO_CPL_D}/${completion}-completion.bash"
  fi
}

# Load all required auto-completions
case "${HHS_MY_SHELL}" in
'bash')
  for completion in "${AUTO_CPL_D}/"*-completion.bash; do
    __hhs_check_completion "${completion}"
  done
  ;;
esac

# shellcheck disable=2206
export HHS_BASH_COMPLETIONS="${BASH_COMPLETIONS[*]}"
