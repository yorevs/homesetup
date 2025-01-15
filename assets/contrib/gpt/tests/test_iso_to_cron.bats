#!/usr/bin/env bats

# test_iso_to_cron.bats
# Purpose: Tests for ISO to Cron converter script

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

setup() {
    SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/iso-to-cron.bash"
}

@test "Version output" {
    run bash "$SCRIPT" -v
    assert_success
    [[ "$output" =~ ^iso-to-cron.bash\ version\ [0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "Help output" {
    run bash "$SCRIPT" -h
    assert_failure
    [[ "$output" =~ usage:.* ]]
}

@test "Convert ISO to cron" {
    run bash "$SCRIPT" -i "2024-08-23T15:30:00Z"
    assert_success
    [ "$output" = "30 15 23 08 *" ]
}

@test "Convert cron to ISO" {
  run bash "$SCRIPT" -c "30 15 23 8 *"
  assert_success
  assert_output "2024-08-23T15:30:00"
}

@test "iso_to_cron handles invalid date expression" {
  run bash "$SCRIPT" -c "invalid date"
  assert_failure
  assert_output --partial "ERROR"
}

@test "cron_to_iso handles invalid cron expression" {
  run bash "$SCRIPT" -c "invalid cron"
  assert_failure
  assert_output --partial "ERROR"
}

@test "cron_to_iso <-> iso_to_cron should succeed" {
  run bash "$SCRIPT" -c "30 15 23 8 *"
  assert_success
  run bash "$SCRIPT" -i "$output"
  assert_success
  assert_output --partial "30 15 23 08 *"
}

@test "Invalid option" {
    run bash "$SCRIPT" -x
    assert_failure
    [[ "$output" =~ ^ERROR:\ Invalid\ option\ .+$ ]]
}
