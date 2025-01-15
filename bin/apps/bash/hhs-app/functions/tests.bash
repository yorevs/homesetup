#!/usr/bin/env bash

#  Script: tests.bash
# Purpose: Contains HomeSetup test functions
# Created: Mar 04, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# shellcheck disable=SC2207
# @purpose: Run all HomeSetup automated tests.
# @param $1..$N [Opt] : The bats files/folders to test.
function tests() {

  local started finished log_file badge fail=0 pass=0 skip=0 status num details re_status re_len len re_skip
  local diff_time diff_time_sec diff_time_ms all_tests=("${@}") range_str

  command -v bats &> /dev/null || quit 1 "'Bats' application not available on your PATH !"

  log_file="${HHS_LOG_DIR}/hhs-tests.log"
  badge="${HHS_HOME}/check-badge.svg"

  # If no bat file is provided, then assume  that we want tio run all HHS tests.
  [[ ${#all_tests[@]} -eq 0 ]] && all_tests=("${HHS_HOME}/tests")
  echo -n '' > "${log_file}"

  # Execute bats tests
  re_skip='^(ok|not ok) ([0-9]+) (.+) in .* # skip .*'
  re_status='^(ok|not ok) ([0-9]+) (.+) in .*'
  re_len='^([0-9]+)\.\.([0-9]+)$'
  started="$(python3 -c 'import time; print(int(time.time() * 1000))')"

  echo -e "\n${WHITE}[$(date +'%H:%M:%S')] Running Bats tests from $(pwd)"
  echo -e "${WHITE}[$(date +'%H:%M:%S')] Logs will be available at:${log_file}\n"
  echo -e "  ${BLUE}|-Bats\t: ${WHITE}v$(__hhs_version bats | head -n 1)"
  echo -e "  ${BLUE}|-Bash\t: ${WHITE}v$(__hhs_version bash | head -n 1)"
  echo -e "  ${BLUE}|-User\t: ${WHITE}${USER}"
  echo -en "${NC}"

  [[ -d "${all_tests[*]}" ]] && all_tests=($(find "${all_tests[*]}" -maxdepth 1  -name "*.bats"))
  # If we did not find any test.
  [[ ${#all_tests[@]} -eq 0 ]] && quit 1 "There are no tests to execute!"

  for next in "${all_tests[@]}"; do
    while read -r result; do
      if [[ ${result} =~ ${re_skip} ]]; then
        status="${YELLOW} ${SKIP_ICN} SKIP${NC}"
        num="${BASH_REMATCH[2]}"
        details="${BASH_REMATCH[3]}"
        ((skip += 1))
      elif [[ ${result} =~ ${re_status} ]]; then
        status="${BASH_REMATCH[1]}"
        num="${BASH_REMATCH[2]}"
        details="${BASH_REMATCH[3]}"
        if [[ "${status}" == 'not ok' ]]; then
          status="${RED} ${FAIL_ICN} FAIL${NC}"
          ((fail += 1))
        elif [[ "${status}" == 'ok' ]]; then
          status="${GREEN} ${SUCCESS_ICN} PASS${NC}"
          ((pass += 1))
        else
          status="${YELLOW} ${ALERT_ICN} Unknown${NC}"
        fi
      elif [[ ${result} =~ ${re_len} ]]; then
        range_str="${YELLOW}${BASH_REMATCH[1]}..${BASH_REMATCH[2]}${NC}"
        echo -e "\n${CYAN}[${next##*/}] ${WHITE}Running tests [${range_str}]${NC}\n"
        len="${#BASH_REMATCH[2]}"
        continue
      else
        echo -e "${result}" >> "${log_file}" 2>&1
        continue
      fi
      echo -en "${status} "
      printf "${BLUE}TC-%${len}d${NC} %s\n" "${num}" "${details}"
    done < <(bats -rtT --print-output-on-failure "${next}" 2>&1)
  done

  finished="$(python3 -c 'import time; print(int(time.time() * 1000))')"
  diff_time=$((finished - started))
  diff_time_sec=$((diff_time / 1000))
  diff_time_ms=$((diff_time - (diff_time_sec * 1000)))

  echo -en "\n\n${WHITE}[$(date +'%H:%M:%S')] Finished running $((pass + fail + skip)) tests:\t"
  echo -e "${GREEN}${SUCCESS_ICN} Passed=${pass}   ${YELLOW}${SKIP_ICN} Skipped=${skip}   ${RED}${FAIL_ICN} Failed=${fail}${NC}"

  if [[ ${fail} -gt 0 && -s "${log_file}" ]]; then
    echo -e "${ORANGE}"
    echo -e "+----------------------------------------------+"
    echo -e "| -=- The following failures were reported -=- |"
    echo -e "+----------------------------------------------+"
    echo -e "${NC}"
    cat "${log_file}" | nl | awk '{printf "\033[33;1m%4d\033[m  %s\n", $1, substr($0, index($0,$2))}'
    echo ''
    curl 'https://badgen.net/badge/tests/failed/red' --output "${badge}" 2> /dev/null
    echo -e " ${RED}${FAIL_ICN}${WHITE}  Bats tests ${RED}FAILED${WHITE} in ${diff_time_sec}s ${diff_time_ms}ms ${NC}"
    quit 2
  else
    echo ''
    curl 'https://badgen.net/badge/tests/passed/green' --output "${badge}" 2> /dev/null
    echo -e " ${GREEN}${PASS_ICN}${NC}  ${WHITE}All Bats tests ${GREEN}PASSED${WHITE} in ${diff_time_sec}s ${diff_time_ms}ms ${NC}"
    quit 0
  fi
}

# @purpose: Run all terminal color palette tests.
function color-tests() {

  echo -e "\n${WHITE}[$(date +'%H:%M:%S')] Running HomeSetup color palette test${BLUE}\n"
  echo -e "  |-Terminal : ${TERM:-not-detected}"
  echo -e "  |-Terminal Program : ${TERM_PROGRAM:-not-detected}\n"

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

  echo -e "--- 16 Colors Low\n"
  for c in {30..37}; do
    echo -en "\033[0;${c}mC16-${c} "
  done
  echo -e "${NC}\n"
  echo -e "--- 16 Colors High\n"
  for c in {90..97}; do
    echo -en "\033[0;${c}mC16-${c} "
  done

  if [[ "${TERM##*-}" == "256color" ]]; then
    echo -e "${NC}\n"
    echo -e "--- 256 Colors\n"
    for c in {1..256}; do
      echo -en "\033[38;5;${c}m"
      printf "C256-%-.3d " "${c}"
      [[ "$(echo "$c % 12" | bc)" -eq 0 ]] && echo ''
    done
    echo -e "${NC}\n"
  fi

  quit 0 ''
}
