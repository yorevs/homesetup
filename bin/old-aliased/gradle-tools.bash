#!/usr/bin/env bash

#  Script: hhs-gradle-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "gradle"; then

    # @function: Prefer using the wrapper instead of the command itself, but, use the command if the wrapper was not found
    __hhs_gradlew() {
        if [ -f "./gradlew" ]; then
            ./gradlew "$@"
        else
            command gradle "$@"
        fi
    }

fi
