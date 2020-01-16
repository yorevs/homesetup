#!/usr/bin/env bash
#shellcheck disable=SC2181

#  Script: updater.bash
# Purpose: Update manager for HomeSetup
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# shellcheck disable=SC2034
# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="updater"

# shellcheck disable=SC2034
# Usage message
USAGE="
Usage: ${APP_NAME} ${PLUGIN_NAME} <option>

    Update manager for HomeSetup.
    
    Options:
      -v  |     --version : Display current program version.
      -h  |        --help : Display this help message.
      -c  |       --check : Fetch the last_update timestamp and check if HomeSetup needs to be updated.
      -u  |      --update : Check the current HomeSetup installation and look for updates.
      -s  |  --stamp-next : Stamp the next auto-update check for 7 days ahead.
"

UNSETS=('help' 'version' 'cleanup' 'execute' 'update_hhs' 'stamp_next_update' 'stamp_next_update')

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# shellcheck disable=SC2086,SC2120
# @function: Check the current HomeSetup installation and look for updates.
update_hhs() {

  local repo_ver is_different
  local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

  if [ -n "$HHS_VERSION" ]; then
    clear
    repo_ver="$(curl -s --fail -m 3 $VERSION_URL)"
    if [ -n "$repo_ver" ]; then
      is_different=$(test -n "$repo_ver" -a "$HHS_VERSION" != "$repo_ver" && echo 1)
      if [ -n "$is_different" ]; then
        echo ''
        echo -e "${ORANGE}Your version of HomeSetup is not up-to-date: ${NC}"
        echo -e "=> Repository: ${GREEN}${repo_ver}${NC} , Yours: ${RED}${HHS_VERSION}${NC}"
        echo ''
        read -r -n 1 -sp "${YELLOW}Would you like to update it now (y/[n]) ?" ANS
        [ -n "$ANS" ] && echo "${ANS}${NC}"
        if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
          pushd "$HHS_HOME" &> /dev/null || return 1
          git pull || return 1
          popd &> /dev/null || return 1
          if "${HHS_HOME}"/install.bash -q; then
            echo -e "${GREEN}Successfully updated HomeSetup !"
            sleep 1
            clear
            # shellcheck disable=SC1090
            source ~/.bashrc
            echo -e "${HHS_MOTD}"
          else
            echo -e "${RED}Failed to install HomeSetup update !${NC}"
            return 1
          fi
        else
          echo ''
        fi
      else
        echo -e "${GREEN}You version is up to date v${repo_ver} !"
      fi
      stamp_next_update &> /dev/null
    else
      echo "${RED}Unable to fetch repository version !${NC}"
      return 1
    fi
  else
    echo "${RED}HHS_VERSION was not defined !${NC}"
    return 1
  fi
  echo -e "${NC}"

  return 0
}

# @function: Fetch the last_update timestamp and check if HomeSetup needs to be updated.
update_check() {

  local today next_check

  today=$(date "+%s%S")
  cur_check=$(grep . "${HHS_DIR}"/.last_update)
  next_check=$(stamp_next_update)
  if [[ ${today} -ge ${cur_check} ]]; then
    update_hhs
    return $?
  fi

  return 0
}

# @function: Stamp the next update timestamp
stamp_next_update() {
  if [ ! -f "${HHS_DIR}/.last_update" ]; then
    # Stamp the next update check for today
    next_check=$(date "+%s%S")
  else
    # Stamp the next update check for next week
    next_check=$(date -v+7d "+%s%S")
  fi
  echo "${next_check}" > "${HHS_DIR}/.last_update"
  echo "$next_check"

  return 0
}

function help() {
  usage 0
}

function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
  exit 0
}

function cleanup() {
  unset "${UNSETS[@]}"
}

function execute() {
  [ -z "$1" ] && usage 1
  cmd="$1"
  shift

  shopt -s nocasematch
  case "$cmd" in
    -h | --help)
      usage 0
      ;;
    -c | --check)
      update_check
      ;;
    -u | --update)
      update_hhs
      ;;
    -s | --stamp-next)
      stamp_next_update
      ;;
    *)
      usage 1 "Invalid ${PLUGIN_NAME} command: \"$cmd\" !"
      ;;
  esac
  shopt -u nocasematch

  exit 0
}
