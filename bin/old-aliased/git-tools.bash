#!/usr/bin/env bash

#  Script: hhs-git-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "git"; then

  # @function: Checkout the previous branch in history (skips branch-to-same-branch changes ).
  __hhs_git-() {

    local currBranch prevBranch

    # Get the current branch.
    currBranch="$(command git rev-parse --abbrev-ref HEAD)"
    # Get the previous branch. Skip the same branch change (that is what is different from git checkout -).
    prevBranch=$(command git reflog | grep 'checkout: ' | grep -v "from $currBranch to $currBranch" | head -n1 | awk '{ print $6 }')
    command git checkout "$prevBranch"

    return $?
  }

  # shellcheck disable=SC2044
  # @function: TODO Comment it
  __hhs_git_branch_all() {
    if [ -n "$1" ] && [ -n "$2" ]; then
      for x in $(find "$1" -maxdepth 1 -type d -iname "$2"); do
        cd "$x" || continue
        pwd
        git status | head -n 1 || continue
        cd - >/dev/null || continue
      done
    else
      echo "Usage: ${FUNCNAME[0]} <dirname> <fileext>"
      return 1
    fi

    return 0
  }

  # shellcheck disable=SC2044
  # @function: TODO Comment it
  __hhs_git_status_all() {
    if [ -n "$1" ]; then
      for x in $(find "$1" -maxdepth 1 -type d -iname "*.git"); do
        cd "$x" || continue
        pwd
        git status || continue
        cd - >/dev/null || continue
      done
    else
      echo "Usage: ${FUNCNAME[0]} <dirname>"
      return 1
    fi

    return 0
  }

  # @function: TODO Comment it
  __hhs_git_diff_show() {
    git diff "$1"^1 "$1" -- "$2"

    return $?
  }

fi
