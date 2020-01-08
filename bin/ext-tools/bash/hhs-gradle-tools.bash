#!/usr/bin/env bash

#  Script: hhs-gradle-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "gradle"; then

  # @function: Prefer using the wrapper instead of the command itself, but, 
  # use the command if the wrapper was not found on current folder.
  function __hhs_gradlew() {
    if [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <gradle_task>"
      return 1
    elif [ -f "./gradlew" ]; then
      ./gradlew "$@"
    else
      command gradle "$@"
    fi
    
    return $?
  }

fi
