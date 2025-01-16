#!/usr/bin/env bash

#  Script: cleanup-packages.bash
# Purpose: Cleanup all python packages, leaving default packages installed.
# Created: Oct 29, 2024
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
NC="\033[m"

# Python site-packages directory.
echo -en "${BLUE}Ensuring pip... ${NC}"
if python3 -m ensurepip &>/dev/null; then
  echo -e "${GREEN}OK"
else
  echo -e "${RED}FAILED" && exit 1
fi

# Defining site-packages location.
echo -en "${BLUE}Defining site-packages location... ${NC}"
SITE_PACKAGES_DIR="$(pip3 show pip | grep Location | cut -d ' ' -f2)"
[[ -d "${SITE_PACKAGES_DIR}" ]] || { echo "site-packages folder '${SITE_PACKAGES_DIR}' not located!"; exit 1; }
echo -e "${GREEN}OK"

echo -n "pip
setuptools
wheel
dataclasses
enum34
typing-extensions
build
twine
" > "${SITE_PACKAGES_DIR}/default-packages.txt"

pushd "${SITE_PACKAGES_DIR}" &>/dev/null || { echo "site-packages folder not found!"; exit 1; }

echo -e "${BLUE}Cleaning up packages from: ${CYAN}'$(pwd)'${NC}"

# Save the installed packages.
echo -en "${BLUE}Freezing packages... ${NC}"
if pip3 list --format=freeze 1> "installed-packages.txt" 2>/dev/null; then
  echo -e "${GREEN}OK"
else
  echo -e "${RED}FAILED" && exit 1
fi

echo -en "${BLUE}Selecting default packages... ${NC}"
touch "removed-packages.txt"
# Loop through installed packages and uninstall those not in default-packages.txt
while IFS= read -r package; do
  package_name=$(echo "${package}" | cut -d'=' -f1)
  if ! grep -q "^${package_name}$" "default-packages.txt"; then
    echo "${package_name}" >> "removed-packages.txt"
  fi
done < <(\cat "installed-packages.txt")
\cat "default-packages.txt" "installed-packages.txt" | sort | uniq > "kept-packages.txt"
echo -e "${GREEN}OK"

# Uninstall packages
if [[ -s "removed-packages.txt" ]]; then
  echo -en "${BLUE}Uninstalling extraneous packages... ${NC}"
  if pip3 uninstall -y -r "removed-packages.txt" &>/dev/null; then
    echo -e "${GREEN}OK"
  else
    echo -e "${RED}FAILED" && exit 1
  fi
fi

# Upgrade default packages.
if [[ -s "kept-packages.txt" ]]; then
  echo -en "${BLUE}Installing default packages... ${NC}"
  if pip3 install --upgrade -r "kept-packages.txt" &>/dev/null; then
    echo -e "${GREEN}OK"
  else
    echo -e "${RED}FAILED"
  fi
fi

# Clean up
echo -en "${BLUE}Cleaning up... ${NC}"
if \
  \rm -f "default-packages.txt" "installed-packages.txt" "removed-packages.txt" "kept-packages.txt" &>/dev/null \
  && \rm -rf ./*-info/; then
  echo -e "${GREEN}OK"
else
  echo -e "${RED}FAILED"
fi

popd &>/dev/null || { echo "Unable to leave site-packages folder!"; exit 1; }

echo -e "${BLUE}Done.${NC}"
exit 0
