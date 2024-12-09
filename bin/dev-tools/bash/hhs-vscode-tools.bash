#!/usr/bin/env bash

#  Script: hhs-vscode-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "code"; then

  # @function: Prefer using the workspace file instead of the bare folder.
  # @param $1..$N [Req] : The code arguments to call.
  function __hhs_code() {

    local workspace_file

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "usage: ${FUNCNAME[0]} [vscode_args]"
      return 1
    fi

    workspace_file=$(find . -iname "*.code-workspace" | head -n 1)

    if [[ -n "${workspace_file}" && -s "${workspace_file}" ]]; then
      echo "code ${workspace_file} ${*}"
      code "${workspace_file}" "$@"
    else
      echo "code ${*}"
      \code "$@"
    fi

    return $?
  }

fi
