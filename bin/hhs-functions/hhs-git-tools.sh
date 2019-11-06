#!/usr/bin/env bash

#  Script: hhs-git-tools.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Checkout the previous branch in history (skips branch-to-same-branch changes ).
function __hhs_git-() {

    local currBranch prevBranch

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} "
    else
        # Get the current branch.
        currBranch="$(command git rev-parse --abbrev-ref HEAD)"
        # Get the previous branch. Skip the same branch change (that is what is different from git checkout -).
        prevBranch=$(command git reflog | grep 'checkout: ' | grep -v "from $currBranch to $currBranch" | head -n1 | awk '{ print $6 }')
        command git checkout "$prevBranch"
        return $?
    fi

    return 0
}