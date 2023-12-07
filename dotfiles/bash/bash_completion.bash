#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: bash_completion.bash
# Purpose: This file is used to configure all bash auto completions
# Created: Jan 14, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions
#
# Thanks to: https://github.com/git/git/tree/master/contrib/completion
# Thanks to: Built-in docker scripts. *Requires bash_complete
# Thanks to: https://github.com/gradle/gradle-completion
# Thanks to: https://github.com/cloudfoundry/cli/blob/master/ci/installers/completion/cf
# Thanks to: https://github.com/Bash-it/bash-it/blob/master/completion/available/brew.completion.bash

# Do not source this file multiple times
if list_contains "${HHS_ACTIVE_DOTFILES}" "bash_completion"; then
  __hhs_log "WARN" "bash_completion was already loaded!"
fi

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_completion"

# HomeSetup auto-completions directory
AUTO_CPL_D="${HHS_DIR}/bin"

# Represents all loaded auto-completions
BASH_COMPLETIONS=

# @function: Check and add completion for tool if found in HHS completions dir.
# @param $1 [Req] : The command to find completion script.
function __hhs_check_completion() {

  local cpl_filter skip_completion completion="$1"

  if [[ $# -le 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <bash_command>"
    return 1
  fi

  case "${completion}" in
    'docker'*)
      [[ -n "${HHS_HAS_DOCKER}" ]] && skip_completion='NO'
    ;;
    *)
      command -v "${completion}" &>/dev/null && skip_completion='NO'
    ;;
  esac

  if [[ "${skip_completion}" == 'NO' ]]; then
    if [[ -f "${AUTO_CPL_D}/${completion}-completion.bash" ]]; then
      echo -e "${BLUE}Loading completion: ${AUTO_CPL_D}/${completion}-completion.bash ${NC}"
      __hhs_source "${AUTO_CPL_D}/${completion}-completion.bash"
      BASH_COMPLETIONS+="${completion} "
      return 0
    fi
  else
    echo -e "${YELLOW}Skipped completion: ${AUTO_CPL_D}/${completion}-completion.bash ${NC}"
  fi

  return 1
}

# @function: Load all available auto-completions.
function __hhs_load_completions() {

  local cpl_filter completion cpl

  cpl_filter=$1
  case "${HHS_MY_SHELL}" in
    'bash')
      for cpl in "${AUTO_CPL_D}/"*-completion.bash; do
        completion=$(basename "${cpl}")
        completion=${completion//-completion.bash/}
        if [[ -z "${cpl_filter}" || "${completion}" == "${cpl_filter}" ]]; then
          if __hhs_check_completion "${completion}" &>/dev/null; then
            echo -e "${GREEN}Completion ${completion} was loaded !${NC}"
          fi
        fi
      done
    ;;
  esac

  return 0
}

export HHS_BASH_COMPLETIONS="${BASH_COMPLETIONS[*]}"
