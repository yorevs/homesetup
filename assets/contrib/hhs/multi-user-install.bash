#!/usr/bin/env bash

#  Script: multi-user-install.bash
# Purpose: Install HomeSetup for multiple users.
# Created: Apr 2, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

HHS_GITHUB_URL='https://github.com/yorevs/homesetup'

HHS_GROUP="${HHS_GROUP:-homesetup}"

INSTALL_DIR="${1:-/var/lib/homesetup}"

HHS_USERS=("${@:2}")

USAGE="usage: multi-user-install <install_dir> <username...>"

if [[ $# -le 1 || ${#HHS_USERS[@]} -eq 0 ]]; then
    echo "${USAGE}" && exit 1
fi

if [ "${EUID}" -ne 0 ]; then
    echo -e "\033[31mPlease execute as root (sudo)\033[m"
    exit 127
fi

# Add the HomeSetup group
if [[ -z $(getent group "${HHS_GROUP}") ]]; then
  echo -e "\033[31m==> Adding HomeSetup group\033[m"
  groupadd "${HHS_GROUP}"
fi

# Clone/Pull the repository
if [[ -d "${INSTALL_DIR}" ]]; then
  pushd "${INSTALL_DIR}" &>/dev/null || exit 1
  echo -e "\033[31m==> Pulling HomeSetup project\033[m"
  git pull &>/dev/null
  popd &>/dev/null || exit 1
else
  echo -e "\033[31m==> Cloning HomeSetup project\033[m"
  git clone "${HHS_GITHUB_URL}.git" "${INSTALL_DIR}" &>/dev/null
fi

# Change the group of HomeSetup files
echo -e "\033[31m==> Changing the group of HomeSetup files\033[m"
chgrp -R "${HHS_GROUP}" "${INSTALL_DIR}"

# Change the group of /temp dir
echo -e "\033[31m==> Changing the group of /temp dir\033[m"
chgrp -R "${HHS_GROUP}" "${TEMP}"

# Give read permissions to HomeSetup group
echo -e "\033[31m==> Giving read permissions to HomeSetup group\033[m"
chmod g+r -R "${INSTALL_DIR}"

# Give read permissions to HomeSetup group
echo -e "\033[31m==> Giving read permissions to HomeSetup group\033[m"
chmod g+r -R "${TEMP}"

# Add users to the HomeSetup group
for usr in "${HHS_USERS[@]}"; do
  echo -e "\033[31m==> Adding ${usr} to HomeSetup group\033[m"
  usermod -a -G "${HHS_GROUP}" "${usr}"
done
