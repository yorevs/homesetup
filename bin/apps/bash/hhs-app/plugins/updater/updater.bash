#!/usr/bin/env bash
#shellcheck disable=2181,2034,1090

#  Script: updater.bash
# Purpose: HomeSetup update manager
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="updater"

# Usage message
USAGE="
usage: ${PLUGIN_NAME} ${PLUGIN_NAME} [option] {check,update,stamp}

 _   _           _       _
| | | |_ __   __| | __ _| |_ ___ _ __
| | | | '_ \ / _\` |/ _\` | __/ _ \ '__|
| |_| | |_) | (_| | (_| | ||  __/ |
 \___/| .__/ \__,_|\__,_|\__\___|_|
      |_|

  HomeSetup update manager.

    options:
      -v  |   --version : Display current program version.
      -h  |      --help : Display this help message.

    arguments:
      check             : Fetch the last_update timestamp and check if HomeSetup needs to be updated.
      update            : Check the current HomeSetup installation and look for updates.
      stamp             : Stamp the next auto-update check for 7 days ahead.
"

UNSETS=(
  help version cleanup execute update_hhs stamp_next_update is_greater update_check
)

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && source "${HHS_DIR}/bin/app-commons.bash"

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
  unset -f "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {

  [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]] && usage 0
  [[ "$1" == "-v" || "$1" == "--version" ]] && version

  cmd="$1"
  shift
  args=("$@")

  shopt -s nocasematch
  case "$cmd" in
    check)
      update_check
    ;;
    update)
      update_hhs
    ;;
    stamp)
      stamp_next_update
    ;;
    *)
      usage 1 "Invalid ${PLUGIN_NAME} command: \"${cmd}\" !"
    ;;
  esac
  shopt -u nocasematch

  quit 0
}

# @purpose: Check whether the repository version is greater than installed version.
is_greater() {
  IFS='.'
  read -r -a curr_versions <<<"${HHS_VERSION}"
  read -r -a repo_versions <<<"${repo_ver}"
  IFS="${OLDIFS}"
  for idx in "${!repo_versions[@]}"; do
    if [[ ${repo_versions[idx]} -gt ${curr_versions[idx]} ]]; then
      echo ''
      echo -e "${ORANGE}Your version of HomeSetup is not up-to-date: ${NC}"
      echo -e "  => Repository: ${GREEN}v${repo_ver}${NC}, Yours: ${RED}v${HHS_VERSION}${NC}"
      echo ''
      return 0
    fi
  done

  echo -e "${GREEN}Your version of HomeSetup is up-to-date v${HHS_VERSION}${NC}"

  return 1
}

# shellcheck disable=SC2120
# @purpose: Check the current HomeSetup installation and look for updates.
update_hhs() {

  local repo_ver re
  local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

  if [[ -n "${HHS_VERSION}" ]]; then
    clear
    repo_ver="$(curl --silent --fail --connect-timeout 1 --max-time 1 "${VERSION_URL}")"
    re="[0-9]+\.[0-9]+\.[0-9]+"

    if [[ ${repo_ver} =~ $re ]]; then
      if is_greater "${repo_ver}"; then
        read -r -n 1 -sp "${YELLOW}Would you like to update it now (y/[n])? " ANS
        [[ -n "$ANS" ]] && echo "${ANS}${NC}"
        if [[ "$ANS" == 'y' || "$ANS" == 'Y' ]]; then
          pushd "${HHS_HOME}" &>/dev/null || quit 1
          git pull || quit 1
          popd &>/dev/null || quit 1
          if "${HHS_HOME}"/install.bash -q -r; then
            echo -e "${GREEN}Successfully updated HomeSetup !${NC}"
            sleep 1
            reset && source "${HOME}"/.bashrc
            echo -e "${HHS_MOTD}"
          else
            quit 1 "${PLUGIN_NAME}: Failed to install HomeSetup update !${NC}"
          fi
        fi
      fi
      stamp_next_update &>/dev/null
    else
      quit 1 "${PLUGIN_NAME}: Unable to fetch '.VERSION' from git repository !"
    fi
  else
    quit 1 "${PLUGIN_NAME}: HHS_VERSION is undefined. HomeSetup is not properly installed !"
  fi
  echo -e "${NC}"

  quit 0
}

# @purpose: Fetch the last_update timestamp and check if HomeSetup needs to be updated.
update_check() {

  if [[ $(date "+%s%S") -ge $(grep . "${HHS_DIR}"/.last_update) ]]; then
    update_hhs
    return $?
  fi

  stamp_next_update

  return 0
}

# @purpose: Stamp the next update timestamp
stamp_next_update() {

  # Stamp the next update check for next week
  if [[ "macOS" == "${HHS_MY_OS_RELEASE}" ]]; then
    \date -v+7d '+%s%S' 1>"${HHS_DIR}/.last_update" 2>/dev/null
  elif [[ "alpine" == "${MY_OS}" ]]; then
    \date -d "@$(( $(\date +%s) - 3 * 24 * 60 * 60 ))" '+%s%S' 1>"${HHS_DIR}/.last_update" 2>/dev/null
  else
    \date -d '+7 days' '+%s%S' 1>"${HHS_DIR}/.last_update" 2>/dev/null
  fi

  return 0
}
