#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: bash_completions.bash
# Purpose: This file is used to configure all bash auto completions
# Created: Jan 14, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file

AUTO_CPL_TYPES=()

case "${HHS_MY_SHELL}" in

  bash)
    AUTO_CPL_D="${HHS_DIR}/bin"

    # If bash_completion is installed source it
    if [[ -f /usr/local/etc/bash_completion ]]; then
      \. /usr/local/etc/bash_completion
      AUTO_CPL_TYPES+=('Bash_Completion')
    fi

    # Enable tab completion for `git`
    # Thanks to: https://github.com/git/git/tree/master/contrib/completion
    if command -v git &> /dev/null; then
      if [[ -f "$AUTO_CPL_D/git-completion.bash" ]]; then
        \. "$AUTO_CPL_D/git-completion.bash"
        AUTO_CPL_TYPES+=('Git')
      fi
    fi

    # Enable tab completion for `docker`
    # Thanks to: Built in docker scripts. *Requires bash_complete
    if command -v docker &> /dev/null &&command -v _filedir &> /dev/null; then
      if [[ -f "$AUTO_CPL_D/docker-compose-completion.bash" ]]; then
        \. "$AUTO_CPL_D/docker-compose-completion.bash"
        AUTO_CPL_TYPES+=('Docker-Compose')
      fi
      if [[ -f "$AUTO_CPL_D/docker-machine-completion.bash" ]]; then
        \. "$AUTO_CPL_D/docker-machine-completion.bash"
        AUTO_CPL_TYPES+=('Docker-Machine')
      fi
      if [[ -f "$AUTO_CPL_D/docker-completion.bash" ]]; then
        \. "$AUTO_CPL_D/docker-completion.bash"
        AUTO_CPL_TYPES+=('Docker')
      fi
    fi

    # Enable tab completion for `gradle`
    # Thanks to: https://github.com/gradle/gradle-completion
    if command -v gradle &> /dev/null; then
      if [[ -f "$AUTO_CPL_D/gradle-completion.bash" ]]; then
        \. "$AUTO_CPL_D/gradle-completion.bash"
        AUTO_CPL_TYPES+=('Gradle')
      fi
    fi

    # Enable tab completion for `cf`
    # Thanks to: https://github.com/cloudfoundry/cli/blob/master/ci/installers/completion/cf
    if command -v cf &> /dev/null; then
      if [[ -f "$AUTO_CPL_D/pcf-completion.bash" ]]; then
        \. "$AUTO_CPL_D/pcf-completion.bash"
        AUTO_CPL_TYPES+=('PCF')
      fi
    fi

    # Enable tab completion for `HomeSetup`
    \. "$AUTO_CPL_D/hhs-completion.bash"
    AUTO_CPL_TYPES+=('HomeSetup')
    ;;

esac

export HHS_AUTO_COMPLETIONS="${AUTO_CPL_TYPES[*]}"

unset AUTO_CPL_TYPES