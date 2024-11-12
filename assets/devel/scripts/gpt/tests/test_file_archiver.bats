#!/usr/bin/env bats

# test_file_archiver.bats
# Purpose: Tests for file archiver script

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

# Test Setup
setup() {
    TEST_DIR="test_directory"
    SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/file-archiver.bash"
    mkdir -p "$TEST_DIR"
    touch -t "$(date -v -60d '+%Y%m%d%H%M')" "$TEST_DIR/old_file.txt"  # File older than 30 days
    touch -t "$(date '+%Y%m%d%H%M')" "$TEST_DIR/new_file.txt"  # Recent file
}

# Test Teardown
teardown() {
    rm -rf "$TEST_DIR"
}

# Test 1: Ensure the script fails without the mandatory directory argument
@test "Fails when no directory is provided" {
    run "$SCRIPT"
    assert_failure
    [[ "$output" =~ "The directory argument (-d) is mandatory." ]]
}

# Test 2: Ensure it archives files older than the default 30 days
@test "Archives files older than 30 days" {
    run "$SCRIPT" -d "$TEST_DIR"
    assert_success
    [ ! -f "$TEST_DIR/old_file.txt" ]    # The old file should be removed
    [ -n "$(find "$TEST_DIR" -name 'old_file.txt_*.tar.gz' -print -quit)" ] # The old file should be archived
}

# Test 3: Ensure it does not archive files that are not old enough
@test "Does not archive files newer than 30 days" {
    run "$SCRIPT" -d "$TEST_DIR"
    assert_success
    [ -f "$TEST_DIR/new_file.txt" ]    # The new file should remain untouched
}

# Test 4: Test custom days argument
@test "Archives files older than a custom number of days" {
    touch -t 202406010000 "$TEST_DIR/mid_file.txt"    # File older than 60 days but newer than 30
    run "$SCRIPT" -d "$TEST_DIR" -n 60
    assert_success
    [ ! -f "$TEST_DIR/mid_file.txt" ]    # The mid file should be archived
    [ -n "$(find "$TEST_DIR" -name 'mid_file.txt_*.tar.gz' -print -quit)" ] # The mid file should be archived
}

# Test 5: Ensure the script does not attempt to archive protected directories
@test "Fails when attempting to archive a protected directory" {
    run "$SCRIPT" -d "/etc"
    assert_failure
    [[ "$output" =~ "Attempting to modify a protected system directory" ]]
}
