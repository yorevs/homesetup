#  Script: firbase-plugin.bash
# Purpose: Manage your HomeSetup Firebase files
# Created: Jan 06, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

USAGE="
  Usage: ap usage here
"

function help() {
  echo ">> help ${0##*/}"
}

function getver() {
  echo ">> getver ${0##*/}"
}

function cleanup() {
  echo ">> cleanup ${0##*/}"
}

function execute() {
  echo ">> execute ${0##*/} Arguments: ${*}"
}