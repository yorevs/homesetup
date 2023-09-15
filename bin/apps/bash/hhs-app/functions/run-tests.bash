#!/usr/bin/env bash

#  Script: built-ins.bash
# Purpose: Contains HomeSetup test functions
# Created: Mar 04, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: Run all HomeSetup automated tests.
function tests() {

  local started finished err_log output badge fails=0

  command -v bats &>/dev/null || quit 1 "The tool 'bats' must be installed to run the automated tests !"

  err_log="${TEMP}/homesetup-tests.log"
  badge="${HHS_HOME}/check-badge.svg"
  started=$(\date "+%s%S")

  pass_icn="\xef\x98\xab"
  test_pass_icn="\xef\x98\xac"
  fail_icn="\xef\x91\xa7"
  test_fail_icn="\xef\x91\xae"

  echo ''

  # Scan and execute bats tests
  echo -n '' > "${err_log}"
  while read -r result; do
    if [[ ${result} =~ ^(ok|not) ]]; then
      if [[ ${result} =~ ^not ]]; then
        output="${result//not ok /${RED} ${fail_icn} FAIL ${NC}}"
        fails=$((fails + 1))
      else
        output="${result//ok /${GREEN} ${pass_icn} PASS ${NC}}"
      fi
      echo -e "${output}"
    elif [[ ${result} =~ ^[0-9] ]]; then
      echo -e "${ORANGE}Running HomeSetup automated tests from [${result//\.\./ to }] ...${NC}"
      echo ''
    else
      echo -e "${result}" >>"${err_log}"
    fi
  done < <(bats -rtT "${HHS_HOME}/tests/" 2>&1)

  echo -e "\n${WHITE}Finished running all tests${NC}"

  finished=$(\date "+%s%S")
  diff_time=$((finished - started))
  diff_time_sec=$((diff_time/1000))
  diff_time_ms=$((diff_time-(diff_time_sec*1000)))

  if [[ $fails -gt 0 ]]; then
    echo ''
    echo -e "${RED}### There were errors reported ###${NC}"
    echo "Please access \"${err_log}\" for more details."
    echo ''
    cat -n "${err_log}"
    echo ''
    echo -e "${RED}${test_fail_icn}${NC}  Bats tests ${RED}FAILED${NC} in ${diff_time_sec}s ${diff_time_ms}ms "
    curl 'https://badgen.net/badge/tests/failed/red' --output "${badge}" 2>/dev/null
    echo ''
    quit 2
  else
    echo ''
    echo -e "${GREEN}${test_pass_icn}${NC}  Bats tests ${GREEN}PASSED${NC} in ${diff_time_sec}s ${diff_time_ms}ms "
    curl 'https://badgen.net/badge/tests/passed/green' --output "${badge}" 2>/dev/null
  fi

  echo ''
  quit 0
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
