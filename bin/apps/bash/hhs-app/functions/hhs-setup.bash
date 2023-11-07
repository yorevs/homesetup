#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains all HHS initialization functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current hhs-setup version
VERSION="1.0.0"

USAGE="
Usage: ${APP_NAME}

 _   _                      ____       _
| | | | ___  _ __ ___   ___/ ___|  ___| |_ _   _ _ __
| |_| |/ _ \\| '_ \` _ \\ / _ \\___ \\ / _ \ __| | | | '_ \\
|  _  | (_) | | | | | |  __/___) |  __/ |_| |_| | |_) |
|_| |_|\\___/|_| |_| |_|\\___|____/ \\___|\\__|\\__,_| .__/
                                                |_|

  HomeSetup Initialization Setup.
  >> Settings version v${VERSION}.
"

DEFAULT_SETTINGS="
# HomeSetup initialization settings file.
# @version: v${VERSION}
HHS_SET_LOCALES=1
HHS_EXPORT_SETTINGS=1
HHS_RESTORE_LAST_DIR=1
"

# shellcheck disable=SC1090
# @purpose: Setup HomeSetup.
function setup() {

  local file_ver all_settings=()

  [[ "$1" == '-h' || "$1" == '--help' ]] && echo "${USAGE}" && quit 0

  # Create the settings file if it does not exist or it's empty.
  [[ -s "${HHS_SETUP_FILE}" ]] || echo "${DEFAULT_SETTINGS}" >"${HHS_SETUP_FILE}"

  # Read all settings, but first, check the file version
  file_ver="$(head -1 "${HHS_SETUP_FILE}")"
  if [[ -z "${file_ver}" || ${file_ver} != "${VERSION}" ]]; then
    echo "${DEFAULT_SETTINGS}" >"${HHS_SETUP_FILE}"
    quit 1 "HomeSetup setup file has changed. Recreated it using defaults."
  fi

  while read -r setting; do
    all_settings+=(setting)
    echo "S:: ${setting}"
  done <"${HHS_SETUP_FILE}"

  echo "ALL: ${all_settings[*]}"
}
