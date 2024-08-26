#!/usr/bin/env bats

# test_temperature_converter.bats
# Purpose: Tests for temperature converter script

# Load helper functions
load 'bats-support/load'
load 'bats-assert/load'

setup() {
  SCRIPT="../temperature-converter.bash"
}

@test "Convert 100°C to °F" {
  result="$(${SCRIPT} -t 100 -f C -o F)"
  [ "$result" == "212.00" ]
}

@test "Convert 0°C to °F" {
  result="$(${SCRIPT} -t 0 -f C -o F)"
  [ "$result" == "32.00" ]
}

@test "Convert 212°F to K" {
  result="$(${SCRIPT} -t 212 -f F -o K)"
  [ "$result" == "373.15" ]
}

@test "Convert 0°F to °C" {
  result="$(${SCRIPT} -t 0 -f F -o C)"
  [ "$result" == "-17.78" ] || [ "$result" == "-17.77" ]  # Adjust according to the actual output
}

@test "Convert 300K to °C" {
  result="$(${SCRIPT} -t 300 -f K -o C)"
  [ "$result" == "26.85" ]
}

@test "Convert 273.15K to °F" {
  result="$(${SCRIPT} -t 273.15 -f K -o F)"
  [ "$result" == "32.00" ]
}

@test "Invalid scale conversion request" {
  run ${SCRIPT} -t 100 -f C -o X
  assert_failure
  [[ "$output" == *"ERROR"* ]]
}

@test "Missing arguments" {
  run ${SCRIPT} -t 100 -f C
  assert_failure
  [[ "$output" == *"ERROR"* ]]
}
