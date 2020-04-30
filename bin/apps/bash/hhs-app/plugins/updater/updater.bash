#!/usr/bin/env bash
#shellcheck disable=SC2181,SC2034,SC1090

#  Script: updater.bash
# Purpose: Update manager for HomeSetup
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="updater"

# Usage message
USAGE="
Usage: ${PLUGIN_NAME} ${PLUGIN_NAME} <option>

    Update manager for HomeSetup.
    
    Options:
      -v  |     --version : Display current program version.
      -h  |        --help : Display this help message.
      -c  |       --check : Fetch the last_update timestamp and check if HomeSetup needs to be updated.
      -u  |      --update : Check the current HomeSetup installation and look for updates.
      -s  |  --stamp-next : Stamp the next auto-update check for 7 days ahead.
"

UNSETS=(
  help version cleanup execute update_hhs stamp_next_update stamp_next_update
)

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

# shellcheck disable=SC2086,SC2120
# @purpose: Check the current HomeSetup installation and look for updates.
update_hhs() {

  local repo_ver is_different
  local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

  if [[ -n "${HHS_VERSION}" ]]; then
    clear
    repo_ver="$(curl -s --fail -m 3 ${VERSION_URL})"
    re="[0-9]+\.[0-9]+\.[0-9]+"

    if [[ ${repo_ver} =~ $re ]]; then
      if [[ ${repo_ver//./} -gt ${HHS_VERSION//./} ]]; then
        echo ''
        echo -e "${ORANGE}Your version of HomeSetup is not up-to-date: ${NC}"
        echo -e "=> Repository: ${GREEN}${repo_ver}${NC} , Yours: ${RED}${HHS_VERSION}${NC}"
        echo ''
        read -r -n 1 -sp "${YELLOW}Would you like to update it now (y/[n]) ?" ANS
        [[ -n "$ANS" ]] && echo "${ANS}${NC}"
        if [[ "$ANS" == 'y' || "$ANS" == 'Y' ]]; then
          pushd "${HHS_HOME}" &> /dev/null || quit 1
          git pull || quit 1
          popd &> /dev/null || quit 1
          if "${HHS_HOME}"/install.bash -q; then
            echo -e "${GREEN}Successfully updated HomeSetup !"
            sleep 1
            clear
            source ~/.bashrc
            echo -e "${HHS_MOTD}"
          else
            quit 1 "${PLUGIN_NAME}: Failed to install HomeSetup update !${NC}"
          fi
        else
          echo ''
        fi
      else
        echo -e "${GREEN}You version is up to date v${HHS_VERSION} !"
      fi
      stamp_next_update &> /dev/null
    else
      quit 1 "${PLUGIN_NAME}: Unable to fetch repository version !"
    fi
  else
    quit 1 "${PLUGIN_NAME}: HHS_VERSION was not defined !"
  fi
  echo -e "${NC}"

  quit 0
}

# @purpose: Fetch the last_update timestamp and check if HomeSetup needs to be updated.
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

# @purpose: Stamp the next update timestamp
stamp_next_update() {
  if [[ ! -f "${HHS_DIR}/.last_update" ]]; then
    # Stamp the next update check for today
    next_check=$(date "+%s%S")
  else
    # Stamp the next update check for next week
    if [[ "Darwin" == "${HHS_MY_OS}" ]]; then
      next_check=$(date -v+7d '+%s%S')
    else
      next_check=$(date -d '+7 days' '+%s%S')
    fi
  fi
  echo "${next_check}" > "${HHS_DIR}/.last_update"
  echo "${next_check}"

  return 0
}

# @purpose: HHS plugin required function
function help() {
  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
  quit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
}

# @purpose: HHS plugin required function
function execute() {
  [[ -z "$1" ]] && usage 1
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

  quit 0
}
