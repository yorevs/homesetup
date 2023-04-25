#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains HomeSetup test functions
# Created: Mar 04, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# @purpose: Run all HomeSetup automated tests.
function tests() {
  
  local started finished  err_log output badge
  
  command -v bats &>/dev/null || quit 1 "The tool 'bats' must be installed to run the automated tests !"

  err_log=$(mktemp)
  badge="${HHS_HOME}/check-badge.svg"
  started=$(\date "+%s%S")

  pushd &>/dev/null "${HHS_HOME}"/tests/ || exit 128
  echo '' >"${err_log}"
  echo ''

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
      echo -e "${ORANGE}Running HomeSetup automated tests from [${result//\.\./ to }] ...${NC}"
      echo ''
    else
      echo -e "${result}" >>"${err_log}"
    fi
  done < <(bats --tap ./*.bats 2>&1)

  popd &>/dev/null || exit 128
  echo ''
  echo 'Finished running all tests.'
  
  finished=$(\date "+%s%S")
  diff_time=$((finished - started))
  diff_time_sec=$((diff_time/1000))
  diff_time_ms=$((diff_time-(diff_time_sec*1000)))

  if [[ "$(grep . "${err_log}")" != "" ]]; then
    echo ''
    echo '### The following errors were reported'
    cat "${err_log}"
    echo ''
    echo "@ To access the error report file open: \"${err_log}\" !"
    echo ''
    echo "${RED}TEST FAILED${NC} in ${diff_time_sec}s ${diff_time_ms}ms "
    curl 'https://badgen.net/badge/tests/failed/red' --output "${badge}" &>/dev/null
  else
    echo ''
    echo "${GREEN}TEST SUCCESSFULL${NC} in ${diff_time_sec}s ${diff_time_ms}ms "
    curl 'https://badgen.net/badge/tests/passed/green' --output "${badge}" &>/dev/null
  fi

  echo ''
}

# @purpose: Run all terminal color palette tests.
function color-tests() {

  echo ''
  echo -e "${ORANGE}--- Home Setup color palette test ${NC}"
  echo ''

  echo -en "${BLACK}  BLACK "
  echo -en "${RED}    RED "
  echo -en "${GREEN}  GREEN "
  echo -en "${ORANGE} ORANGE "
  echo -en "${BLUE}   BLUE "
  echo -en "${PURPLE} PURPLE "
  echo -en "${CYAN}   CYAN "
  echo -en "${GRAY}   GRAY "
  echo -en "${WHITE}  WHITE "
  echo -en "${YELLOW} YELLOW "
  echo -en "${VIOLET} VIOLET "
  echo -e "${NC}\n"

  echo "--- 16 Colors Low"
  echo ''
  for c in {30..37}; do
    echo -en "\033[0;${c}mC16-${c} "
  done
  echo -e "${NC}\n"

  echo "--- 16 Colors High"
  echo ''
  for c in {90..97}; do
    echo -en "\033[0;${c}mC16-${c} "
  done
  echo -e "${NC}\n"

  if [[ "${TERM##*-}" == "256color" ]]; then
    echo "--- 256 Colors"
    echo ''
    for c in {1..256}; do
      echo -en "\033[38;5;${c}m"
      printf "C256-%-.3d " "${c}"
      [[ "$(echo "$c % 12" | bc)" -eq 0 ]] && echo ''
    done
    echo -e "${NC}\n"
  fi

  echo ''

  quit 0
}
