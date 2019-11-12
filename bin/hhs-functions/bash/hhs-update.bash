#!/usr/bin/env bash
#shellcheck disable=SC2181

#  Script: hhs-paths.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# shellcheck disable=SC2086,SC2120
# @function: Check the current HomeSetup installation and look for updates.
function __hhs_update() {

  local repo_ver is_different
  local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} "
  else
    if [ -n "$HHS_VERSION" ]; then
      curl_opts=( -s --fail -m 3 )
      repo_ver=$(curl ${curl_opts[*]} "$VERSION_URL")
      if [ "$?" -eq 0 ] && [ -n "$repo_ver" ]; then
        is_different=$(test -n "$repo_ver" -a "$HHS_VERSION" != "$repo_ver" && echo 1)
        if [ -n "$is_different" ]; then
          echo -e "${YELLOW}You have a different version of HomeSetup: "
          echo -e "=> Repository: ${repo_ver} , Yours: ${HHS_VERSION}"
          read -r -n 1 -sp "Would you like to update it now (y/[n]) ?" ANS
          [ -n "$ANS" ] && echo "${ANS}${NC}"
          if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
            pushd "$HHS_HOME" &>/dev/null || return 1
            git pull || return 1
            popd &>/dev/null || return 1
            if "${HHS_HOME}"/install.bash -q; then
              echo -e "${GREEN}Successfully updated HomeSetup!"
              sleep 1
              reload
            else
              echo -e "${RED}Failed to install HomeSetup update !${NC}"
              return 1
            fi
          fi
        else
          echo -e "${GREEN}You version is up to date v${repo_ver} !"
        fi
        __hhs_stamp-next-update &> /dev/null
      else
        echo "${RED}Unable to fetch repository version !${NC}"
        return 1
      fi
    else
      echo "${RED}HHS_VERSION was not defined !${NC}"
      return 1
    fi
    echo "${NC}"
  fi

  return 0
}

# shellcheck disable=SC2086,SC2119
# @function: Check the last_update timestamp and check for updates if required
function __hhs_auto-update-check() {

  local today nextCheck

  today=$(date "+%s%S")
  nextCheck=$(__hhs_stamp-next-update)
  if [[ ${today} -ge ${nextCheck} ]]; then
    __hhs_update
  fi

  return 0
}

# @function: Stamp the next update timestamp
function __hhs_stamp-next-update() {
  if [ ! -f "${HHS_DIR}/.last_update" ]; then
    # Stamp the next update check for today
    nextCheck=$(date "+%s%S")
  else
    # Stamp the next update check for next week
    nextCheck=$(date -v+7d "+%s%S")
  fi
  echo "${nextCheck}" > "${HHS_DIR}/.last_update"
  echo $nextCheck

  return 0
}