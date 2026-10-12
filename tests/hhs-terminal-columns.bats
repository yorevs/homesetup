#!/usr/bin/env bats

load test_helper
load_bats_libs

setup() {
  # Force environment-based detection even when the runner owns a terminal.
  stty() { return 1; }
}

@test "terminal columns uses the configured non-terminal width" {
  COLUMNS=132 run __hhs_terminal_columns
  assert_success
  assert_output '132'
}

@test "terminal columns detects changes on each call" {
  COLUMNS=100 run __hhs_terminal_columns
  assert_output '100'
  COLUMNS=160 run __hhs_terminal_columns
  assert_output '160'
}

@test "terminal columns accepts a one-column terminal" {
  COLUMNS=1 run __hhs_terminal_columns
  assert_success
  assert_output '1'
}

@test "terminal columns rejects missing or invalid widths without a default" {
  local value
  for value in '' 0 -1 abc 08 '80; echo invalid'; do
    COLUMNS="${value}" run __hhs_terminal_columns
    assert_failure
    assert_output ''
  done
}

@test "environment values adapt to narrow and wide terminal widths" {
  source "${HHS_FUNCTIONS_DIR}/hhs-built-ins.bash"
  export HHS_ENV_FILE="${BATS_TEST_TMPDIR}/env"
  export HHS_WIDTH_TEST_VALUE=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
  __hhs_terminal_columns() { printf '%s\n' "${COLUMNS}"; }

  COLUMNS=60 run __hhs_envs HHS_WIDTH_TEST_VALUE
  assert_success
  assert_output --partial 'abcdefghijk...'

  COLUMNS=120 run __hhs_envs HHS_WIDTH_TEST_VALUE
  assert_success
  assert_output --partial "${HHS_WIDTH_TEST_VALUE}"

  COLUMNS=10 run __hhs_envs HHS_WIDTH_TEST_VALUE
  assert_success
  assert_output --partial 'a...'
}
