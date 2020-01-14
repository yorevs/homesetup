#  Script: vault.bash
# Purpose: Wrapper to vault application
# Created: Jan 06, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

VAULT_DIR="${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault"

function help() {
  python "${VAULT_DIR}/vault.py" -h
  exit $?
}

function version() {
  python "${VAULT_DIR}/vault.py" -v
  exit $?
}

function cleanup() {
  exit 0
}

function execute() {
  python "${VAULT_DIR}/vault.py" "${@}"
  exit $?
}
