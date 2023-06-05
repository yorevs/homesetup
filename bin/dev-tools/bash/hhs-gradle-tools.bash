#!/usr/bin/env bash

#  Script: hhs-gradle-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "gradle"; then

  # @function: Prefer using the wrapper instead of the installed command itself.
  # @param $1..$N [Req] : The gradle tasks to call.
  function __hhs_gradle() {
    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <gradle_task>"
      return 1
    elif [[ -f "./gradlew" ]]; then
      echo "./gradlew ${*}"
      ./gradlew "$@"
    else
      echo "gradle ${*}"
      \gradle "$@"
    fi

    return $?
  }

fi
