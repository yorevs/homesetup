#!/usr/bin/env bats

#  Script: hhs-toml.bats
# Purpose: hhs-toml tests.
# Created: Dec 05, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

load test_helper
load "${HHS_HOME}/bin/hhs-functions/bash/hhs-toml.bash"

test_file=

# This runs before each of the following tests are executed.
setup() {
  test_file=$(mktemp)
}

@test "when-invoking-with-help-option-then-toml-get-should-print-usage" {
  run __hhs_toml_get -h
  [[ ${status} -eq 1 ]]
  [[ ${lines[0]} == "Usage: __hhs_toml_get <file> <key> [group]" ]]
}

@test "when-invoking-with-missing-file-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get
  [[ ${status} -eq 1 ]]
  [[ ${lines[0]} == "error: The file parameter must be provided." ]]
}

@test "when-invoking-with-missing-key-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get "${test_file}"
  [[ ${status} -eq 1 ]]
  [[ ${lines[0]} == "error: The key parameter must be provided." ]]
}

@test "when-invoking-with-invalid-file-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get "non-existent.toml" "any-key"
  [[ ${status} -eq 1 ]]
  [[ ${lines[0]} == "error: The \"file non-existent.toml\" does not exists or is empty." ]]
}
