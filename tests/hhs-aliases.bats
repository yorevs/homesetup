#!/usr/bin/env bats

#  Script: hhs-aliases.bats
# Purpose: hhs-aliases tests.
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

load test_helper

@test "should-print-usage-when-invoking-with-help-option" {
  run __hhs_aliases -h
  [[ ${status} -eq 1 ]]
  [[ ${lines[0]} == "Usage: __hhs_aliases [-s|--sort] [alias] [alias_expr]" ]]
}

@test "should-add-alias" {
  expected="Alias set: .*hhs-bats.* is .*'ls -la'.*"
  actual=$(__hhs_aliases hhs-bats 'ls -la')
  [[ ${actual} =~ ${expected} ]]
}

@test "should-remove-alias" {
  expected="Alias removed: .*has.*"
  actual=$(__hhs_aliases -r has)
  [[ ${actual} =~ ${expected} ]]
}

@test "should-not-remove-invalid-alias" {
  expected="Alias not found: .*hhs-bats.*"
  actual=$(__hhs_aliases -r hhs-bats)
  [[ ${actual} =~ ${expected} ]]
}
