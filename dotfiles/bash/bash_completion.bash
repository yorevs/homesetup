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

# HomeSetup auto-completions dirctory
AUTO_CPL_D="${HHS_DIR}/bin"

# Represents all loaded auto-completions
BASH_COMPLETIONS=

# All HomeSetup available auto-completions
ALL_BASH_CPL_TYPES=(
  'git' 'docker-compose' 'docker-machine' 'docker' 'gradle'
  'cf' 'brew' 'kubectl' 'helm' 'hhs' 'ssh'
)

# Load all required auto-completions
case "${HHS_MY_SHELL}" in
  'bash')
    for completion in ${ALL_BASH_CPL_TYPES[*]}; do
      unset skip_completion
      case "${completion}" in
        'docker'*)
          docker info &>/dev/null && skip_completion='OK'
          ;;
        *)
          command -v "${completion}" &>/dev/null && skip_completion='OK'
          ;;
      esac
      if [[ "${skip_completion}" == 'OK' ]]; then
        if [[ -f "${AUTO_CPL_D}/${completion}-completion.bash" ]]; then
          echo "INFO" "Loading completion: ${AUTO_CPL_D}/${completion}-completion.bash"
          __hhs_source "${AUTO_CPL_D}/${completion}-completion.bash"
          BASH_COMPLETIONS+="${completion} "
        fi
      else
        echo "INFO" "Skipped completion: ${AUTO_CPL_D}/${completion}-completion.bash"
      fi
    done
    ;;
  *)
    echo "WARN" "\"${HHS_MY_SHELL}\" shell does not include any completions"
    ;;
esac

echo "INFO" "Loaded bash completions: ${BASH_COMPLETIONS[*]}"

# shellcheck disable=2206
export HHS_BASH_COMPLETIONS="${BASH_COMPLETIONS[*]}"
