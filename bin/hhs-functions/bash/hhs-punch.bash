#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2207

#  Script: hhs-punch.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: PUNCH-THE-CLOCK. This is a helper tool to aid with the timesheet.
# @param $1 [Con] : The week list punches from.
function __hhs_punch() {

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <args>"
    echo ''
    echo '    Options: '
    echo '      -l        : List all registered punches.'
    echo '      -e        : Edit current punch file.'
    echo '      -r        : Reset punches for the current week and save the previous one.'
    echo '      -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch.'
    echo ''
    echo '  Notes: '
    echo '    When no arguments are provided it will !!PUNCH THE CLOCK!!.'
    return 1
  else
    if [[ "-l" == "${1}" ]]; then
      python3 -m clitt widgets punch list
    elif [[ "-e" == "${1}" ]]; then
      python3 -m clitt widgets punch edit
    elif [[ "-r" == "${1}" ]]; then
      python3 -m clitt widgets punch reset
    elif [[ "-w" == "${1}" ]]; then
      python3 -m clitt widgets punch week ${2}
    else
      python3 -m clitt widgets punch
    fi
  fi

  return $?
}
