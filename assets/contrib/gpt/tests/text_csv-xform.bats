#!/usr/bin/env bats

# Test suite for csv-xform.bash

# Load helper functions
load "${HHS_HOME}/tests/bats/bats-support/load"
load "${HHS_HOME}/tests/bats/bats-assert/load"

# Path to the script
SCRIPT="${HHS_HOME}/assets/devel/scripts/gpt/src/csv-xform.bash"

# Test: Script exists and is executable
@test "Script file exists and is executable" {
  [ -f "$SCRIPT" ]
  [ -x "$SCRIPT" ]
}

# Test: Transform a 2-column CSV file into a 4-column format
@test "Transforms 2-column CSV file into 4-column format" {
  # Create a temporary 2-column CSV file for testing
  echo -e "1234,abcd\n4321,dcba\nAaaa,Bbbb\nSsss,Ffff" > test_input.csv

  run "$SCRIPT" test_input.csv 4

  assert_success
  assert_output --partial "1234,abcd,4321,dcba"$'\n'"Aaaa,Bbbb,Ssss,Ffff"

  # Clean up
  rm test_input.csv
}

# Test: Transform a 4-column CSV file into an 8-column format
@test "Transforms 4-column CSV file into 8-column format" {
  # Create a temporary 4-column CSV file for testing
  echo -e "1234,abcd,5678,efgh\nijkl,mnop,qrst,uvwx\nAaaa,Bbbb,Cccc,Dddd\nEeee,Ffff,Gggg,Hhhh" > test_input.csv

  run "$SCRIPT" test_input.csv 8

  assert_success
  assert_output --partial "1234,abcd,5678,efgh,ijkl,mnop,qrst,uvwx"$'\n'"Aaaa,Bbbb,Cccc,Dddd,Eeee,Ffff,Gggg,Hhhh"

  # Clean up
  rm test_input.csv
}

# Test: Transform piped input into 4-column format
@test "Transforms piped input into 4-column format" {
  # Run the script with piped input, capturing output manually
  run bash -c 'echo "1234,abcd,4321,dcba,Aaaa,Bbbb,Ssss,Ffff" | '"$SCRIPT"' 4'

  # Assert success and correct output
  assert_success
  assert_output --partial "1234,abcd,4321,dcba"$'\n'"Aaaa,Bbbb,Ssss,Ffff"
}

# Test: Output to specified file
@test "Transforms input and outputs to specified file" {
  # Create a temporary 2-column CSV file for testing
  echo -e "1234,abcd\n4321,dcba\nAaaa,Bbbb\nSsss,Ffff" > test_input.csv

  # Run the script with -o option to specify output file
  run "$SCRIPT" -o test_output.csv test_input.csv 4

  # Assert success and verify file contents
  assert_success
  [ -f "test_output.csv" ]
  expected_output="1234,abcd,4321,dcba"$'\n'"Aaaa,Bbbb,Ssss,Ffff"
  actual_output=$(< test_output.csv)
  [ "$actual_output" = "$expected_output" ]

  # Clean up
  rm test_input.csv test_output.csv
}

# Test: Invalid input file
@test "Handles invalid input file gracefully" {
  # Run the script with a non-existent file
  run "$SCRIPT" nonexistent.csv 4

  # Assert failure and correct error message
  assert_failure
  [[ "$output" == *"ERROR: File 'nonexistent.csv' not found."* ]]
}

# Test: Invalid column count
@test "Handles invalid column count gracefully" {
  # Create a temporary 2-column CSV file for testing
  echo -e "1234,abcd\n4321,dcba\nAaaa,Bbbb\nSsss,Ffff" > test_input.csv

  # Run the script with an odd number of output columns
  run "$SCRIPT" test_input.csv 3

  # Assert failure and correct error message
  assert_failure
  [[ "$output" == *"ERROR: The output column count must be an even number."* ]]

  # Clean up
  rm test_input.csv
}
