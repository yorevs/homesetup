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
load "${HHS_HOME}/bin/hhs-functions/bash/hhs-text.bash"
load "${HHS_HOME}/bin/hhs-functions/bash/hhs-toml.bash"

test_file=

setup() {

  test_file=$(mktemp)
  # Stub the toml entries
  echo "
    default.root.key.1 = any root value one
    default.root.key.2 = any root value two

    [tests]

    test.key.1 = any test value one
    test.key.2 = any test value two

    [my.group]

    valid_key_two = my valid value two
    valid_key_one = my valid value one
  " >> "${test_file}"
  echo "Toml file: ${test_file}"
}

teardown() {
  \rm -f "${test_file}"
}

# TC - 1
@test "when-invoking-with-help-option-then-toml-get-should-print-usage" {
  skip 'testing skip'
  run __hhs_toml_get -h
  [[ ${status} -eq 1 && ${lines[0]} == "Usage: __hhs_toml_get <file> <key> [group]" ]]
}

# TC - 2
@test "when-invoking-with-missing-file-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get
  [[ ${status} -eq 1 && ${output} == "error: The file parameter must be provided." ]]
}

# TC - 3
@test "when-invoking-with-missing-key-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get "${test_file}"
  [[ ${status} -eq 1 && ${output} == "error: The key parameter must be provided." ]]
}

# TC - 4
@test "when-invoking-with-invalid-file-then-toml-get-should-raise-an-error" {
  run __hhs_toml_get "non-existent.toml" "any_key"
  [[ ${status} -eq 1 && ${output} == "error: The file \"non-existent.toml\" does not exists or is empty." ]]
}

# TC - 5
@test "when-invoking-with-with-correct-options-then-toml-get-should-get-it" {
  run __hhs_toml_get "${test_file}" "valid_key_one" "my.group"
  expected="valid_key_one=my valid value one"
  [[ ${status} -eq 0 && ${output} =~ ${expected} ]]
}

# TC - 6
@test "when-invoking-without-group-then-toml-get-should-get-it" {
  run __hhs_toml_get "${test_file}" "default.root.key.2"
  expected="default.root.key.2=any root value two"
  [[ ${status} -eq 0 && ${output} =~ ${expected} ]]
}

# TC - 7
@test "when-invoking-with-with-incorrect-key-value-pair-then-should-raise-an-error" {
  run __hhs_toml_set "${test_file}" "test.key.1" "tests"
  expected="error: The key/value parameter must be on the form of 'key=value', but it was 'test.key.1'."
  [[ ${status} -eq 1 && ${output} =~ ${expected} ]]
}

# TC - 8
@test "when-invoking-with-with-correct-options-then-toml-set-should-set-it" {
  run __hhs_toml_set "${test_file}" "test.key.1=new updated value" "tests"
  expected="test.key.1=new updated value"
  run __hhs_toml_get "${test_file}" "test.key.1" "tests"
  [[ ${status} -eq 0 && ${output} =~ ${expected} ]]
}
