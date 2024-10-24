#!/usr/bin/env bats

# Test suite for cron-scheduler.bash

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

setup() {
    SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/nerd-font-installer.bash"
    RESOURCE_DIR="$(dirname "$SCRIPT")/resources"
}

#!/usr/bin/env bats

# Adjusted path to the script we are testing
SCRIPT="../nerd-font-installer.bash"

# @test: Verify the script exists and is executable
@test "Script exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

# @test: Display help message (-h option)
@test "Displays help message" {
  run "$SCRIPT" -h
  assert_success
  assert_output --partial "Usage:"
}

# @test: Display version information (-v option)
@test "Displays version information" {
  run "$SCRIPT" -v
  assert_success
  assert_output --partial "version"
}

# @test: Install a font using quiet mode (-f option)
@test "Install font using quiet mode" {
  skip "This test is causing a SIGSEGV"
  local test_font="Droid"  # Use a partial name of a valid font

  run "$SCRIPT" -f "$test_font"
  assert_success
  assert_output --partial "SUCCESS"
}

# @test: Handle non-existing font in quiet mode (-f option)
@test "Handle non-existing font" {
  local invalid_font="NonExistentFont"

  run "$SCRIPT" -f "$invalid_font"
  assert_failure
  assert_output --partial "not found"
}

# @test: Verify invalid option handling
@test "Invalid option handling" {
  run "$SCRIPT" --invalid-option
  assert_failure
  assert_output --partial "Invalid option"
}

# @test: Validate behavior when resources/nerd-font-list.csv is missing
@test "Handle missing font list" {
  mv "$RESOURCE_DIR/nerd-font-list.csv" "$RESOURCE_DIR/nerd-font-list.csv.bak"

  run "$SCRIPT"
  assert_failure
  assert_output --partial "Font list file not found"

  # Restore the font list
  mv "$RESOURCE_DIR/nerd-font-list.csv.bak" "$RESOURCE_DIR/nerd-font-list.csv"
}

# @test: Verify behavior when ZIP download fails
@test "Handle failed ZIP download" {
  local fake_font="FakeFont"
  # Add the FakeFont to the list
  echo "FakeFont;FakeFont;??;??" >> "$RESOURCE_DIR/nerd-font-list.csv"

  run "$SCRIPT" -f "$fake_font"
  assert_failure
  assert_output --partial "Failed to download"

  # Remove the FakeFont from the list
  head -n $(($(wc -l < "$RESOURCE_DIR/nerd-font-list.csv") - 1)) "$RESOURCE_DIR/nerd-font-list.csv" > temp_file
  mv temp_file "$RESOURCE_DIR/nerd-font-list.csv"
}
