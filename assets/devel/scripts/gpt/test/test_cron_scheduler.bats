#!/usr/bin/env bats

# Test suite for cron-scheduler.bash

# Path to the script
SCRIPT_PATH="../cron-scheduler.bash"

# Path to the iso-to-cron.bash mock script
MOCK_ISO_TO_CRON="./iso-to-cron.bash"

# Setup: Create a mock iso-to-cron.bash script
setup() {
  # Create a temporary directory for the mock
  mkdir -p "$(dirname "${MOCK_ISO_TO_CRON}")"
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
  run bash "${SCRIPT_PATH}" -s "/path/to/script.sh" -i "2024-08-23T15:30:00Z"
  [ "$status" -eq 0 ]
  [[ "${output}" =~ SUCCESS ]]
}

# Test: Missing ISO date argument
@test "Missing ISO date argument" {
  run bash "${SCRIPT_PATH}" -s "/path/to/script.sh"
  [ "$status" -eq 2 ]
  [[ "${output}" =~ ERROR ]]
}

# Test: Missing script path argument
@test "Missing script path argument" {
  run bash "${SCRIPT_PATH}" -i "2024-08-23T15:30:00Z"
  [ "$status" -eq 2 ]
  [[ "${output}" =~ ERROR ]]
}

# Test: Invalid ISO date
@test "Invalid ISO date" {
  run bash "${SCRIPT_PATH}" -s "/path/to/script.sh" -i "2024-08-23T99:99:99Z"
  [ "$status" -eq 1 ]
  [[ "${output}" =~ ERROR ]]
}

# Test: Version option
@test "Version option" {
  run bash "${SCRIPT_PATH}" -v
  [ "$status" -eq 2 ]
  [[ "${output}" =~ 0.0.1 ]]
}

# Test: Help option
@test "Help option" {
  run bash "${SCRIPT_PATH}" -h
  [ "$status" -eq 2 ]
  [[ "${output}" =~ Usage ]]
}
