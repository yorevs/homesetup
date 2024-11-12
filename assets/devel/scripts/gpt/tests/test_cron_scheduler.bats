#!/usr/bin/env bats

# Test suite for cron-scheduler.bash

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

# Path to the script
SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/cron-scheduler.bash"

# Mock directory
MOCK_DIR="${HHS_HOME}/assets/devel/scripts/gpt/tests/mocks"

# Path to the iso-to-cron.bash mock script
MOCK_ISO_TO_CRON="${MOCK_DIR}/iso-to-cron.bash"

# Setup: Create a mock iso-to-cron.bash script
setup() {
  # Create a temporary directory for the mock
  [[ -d "${MOCK_DIR}" ]] || mkdir -p "${MOCK_DIR}"
  # Mock iso-to-cron.bash script to return a fixed cron expression
  cat <<'EOF' > "${MOCK_ISO_TO_CRON}"
#!/usr/bin/env bash
if [[ "$1" == "-i" && "$2" == "2024-08-23T15:30:00Z" ]]; then
  echo "30 15 23 8 *"
else
  echo "Invalid ISO date" >&2
  exit 1
fi
EOF
  chmod +x "${MOCK_ISO_TO_CRON}"
}

# Teardown: Remove the mock iso-to-cron.bash script
teardown() {
  rm -f "${MOCK_ISO_TO_CRON}"
}

# Test: Valid ISO date and script path
@test "Valid ISO date and script path" {
  run bash "${SCRIPT}" -s "/path/to/script.sh" -i "2024-08-23T15:30:00Z"
  [ "$status" -eq 0 ]
  [[ "${output}" =~ SUCCESS ]]
}

# Test: Missing ISO date argument
@test "Missing ISO date argument" {
  run bash "${SCRIPT}" -s "/path/to/script.sh"
  assert_failure
  [[ "${output}" =~ ERROR ]]
}

# Test: Missing script path argument
@test "Missing script path argument" {
  run bash "${SCRIPT}" -i "2024-08-23T15:30:00Z"
  assert_failure
  [[ "${output}" =~ ERROR ]]
}

# Test: Invalid ISO date
@test "Invalid ISO date" {
  run bash "${SCRIPT}" -s "/path/to/script.sh" -i "2024-08-23T99:99:99Z"
  assert_failure
  [[ "${output}" =~ ERROR ]]
}

# Test: Version option
@test "Version option" {
  run bash "${SCRIPT}" -v
  assert_success
  [[ "${output}" =~ [0-9].[0-9].[0-9] ]]
}

# Test: Help option
@test "Help option" {
  run bash "${SCRIPT}" -h
  assert_failure
  [[ "${output}" =~ usage ]]
}
