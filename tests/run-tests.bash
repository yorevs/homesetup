#!/usr/bin/env bash

#  Script: run-tests.bash
# Purpose: Execute all or filtered HomeSetup automated tests
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

ERR_LOG=$(mktemp)

# .bash_color is not being recognized, so, set the colors we use here.
if tput setaf 1 &>/dev/null; then
  NC=$(tput sgr0)
  RED=$(tput setaf 124)
  GREEN=$(tput setaf 64)
else
  export NC='\033[0;0;0m'
  export RED='\033[0;31m'
  export GREEN='\033[0;32m'
fi

echo ''
echo -e "Executing HomeSetup automated tests --------------------"

# TODO filter tests by category
# Scan and execute bats tests
while read -r result; do
  if [[ ${result} =~ ^(ok|not) ]]; then
    output="${result//not ok/"${RED}[ FAIL ]${NC}"}"
    output="${output//ok/"${GREEN}[ PASS ]${NC}"}"
    echo -e "${output}"
  elif [[ ${result} =~ ^[0-9] ]]; then
    echo -e "=> Running tests ${result//\.\./ to } ..."
    echo ''
  else
    echo -e "\n${result}\n" >> "${ERR_LOG}"
  fi
done < <(bats --tap ./*.bats 2>&1)

echo ''
echo '* Finished running all tests.'
echo "@ To see the error report access the file \"${ERR_LOG}\" !"
echo ''
