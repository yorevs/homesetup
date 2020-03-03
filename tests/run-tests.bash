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
# shellcheck disable=SC1090
\. "$HOME/.bash_colors"

pushd &> /dev/null "${HHS_HOME}"/tests/ || exit 128
echo '' > "${ERR_LOG}"

echo ''
echo -e "Executing HomeSetup automated tests --------------------"

# TODO filter tests by category
# Scan and execute bats tests
while read -r result; do
  if [[ ${result} =~ ^(ok|not) ]]; then
    if [[ ${result} =~ ^not ]]; then
      output="${result//not ok /${RED}[ FAIL ] ${NC}}"
    else
      output="${result//ok /${GREEN}[ PASS ] ${NC}}"
    fi
    echo -e "${output}"
  elif [[ ${result} =~ ^[0-9] ]]; then
    echo -e "=> Running tests ${result//\.\./ to } ..."
    echo ''
  else
    echo -e "${result}" >> "${ERR_LOG}"
  fi
done < <(bats --tap ./*.bats 2>&1)

popd &> /dev/null || exit 255
echo ''
echo 'Finished running all tests.'

if [[ "$( grep . "${ERR_LOG}")" != "" ]]; then
  echo ''
  echo '### The following errors were reported'
  cat "${ERR_LOG}"
  echo ''
  echo "@ To access the error report file open: \"${ERR_LOG}\" !"
  echo ''
   echo "${RED}TEST FAILED${NC}"
else
  echo ''
  echo "${GREEN}TEST SUCCESSFULL${NC}"
fi

echo ''
