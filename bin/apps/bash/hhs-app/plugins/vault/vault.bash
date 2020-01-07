#  Script: vault.bash
# Purpose: Wrapper to vault application
# Created: Jan 06, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

function help() {
  python "$(command -v vault.py)" -h
  exit $?
}

function version() {
  python "$(command -v vault.py)" -v
  exit $?
}

function cleanup() {
  exit 0
}

function execute() {
  python "$(command -v vault.py)" "${@}"
  exit $?
}
