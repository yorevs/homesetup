#!/usr/bin/env bats

#  Script: hhs-aliases.bats
# Purpose: hhs-aliases tests.
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

load test_helper
load "${HHS_HOME}/bin/hhs-functions/bash/hhs-aliases.bash"

# This runs before each of the following tests are executed.
setup() {
  unset HHS_HIGHLIGHT_COLOR
  DIR="$(\cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && \pwd)"
  PATH="$DIR/../src:$PATH"
}

@test "should-print-usage-when-invoking-with-help-option" {
  run __hhs_aliases -h
  [[ ${status} -eq 1 ]]
  [[ "${lines[0]}" == "Usage: __hhs_aliases <alias> <alias_expr>" ]]
}

@test "should-add-alias" {
  run __hhs_aliases 'hhs-bats' ls -la
  result="${lines[0]}"
  [[ ${status} -eq 0 ]]
  [[ "${result}" == "Alias set: \"hhs-bats\" is 'ls -la'" ]]
  ised "/^alias hhs-bats=.*$/d" "${HHS_ALIASES_FILE}"
}

@test "should-remove-alias" {
  __hhs_aliases 'hhs-bats' 'ls -la'
  run __hhs_aliases -r 'hhs-bats'
  [[ ${status} -eq 0 ]]
  [[ "${lines[0]}" == "Alias removed: \"hhs-bats\"" ]]
}

@test "should-not-remove-invalid-alias" {
  run __hhs_aliases -r 'hhs-bats'
  [[ ${status} -eq 1 ]]
  [[ "${lines[0]}" == "error: Alias not found: \"hhs-bats\"" ]]
}
