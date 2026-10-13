#!/usr/bin/env bats

#  Script: hhs-paths.bats
# Purpose: hhs-paths tests.
# Created: Apr 02, 2024
#  Author: OpenAI Assistant
# License: Please refer to <https://opensource.org/licenses/MIT>
#

load test_helper
load "${HHS_FUNCTIONS_DIR}/hhs-text.bash"
load "${HHS_FUNCTIONS_DIR}/hhs-paths.bash"
load_bats_libs

edit_log=""

__hhs_edit() {
  echo "$1" >>"${edit_log}"
  return 0
}

tmp_root=""
baseline_path=""
valid_path=""
another_path=""
missing_path=""
original_path=""

setup() {
  # Use a deterministic width without depending on the runner's terminal.
  stty() { return 1; }
  export COLUMNS=120
  original_path="${PATH}"
  tmp_root="/tmp/hhs-tests-$$"
  mkdir -p "${tmp_root}"
  export HHS_DIR="${tmp_root}"
  export HHS_PATHS_FILE="${tmp_root}/paths"
  touch "${HHS_PATHS_FILE}"

  edit_log="${tmp_root}/edit.log"
  : >"${edit_log}"

  baseline_path="${tmp_root}/baseline"
  valid_path="${tmp_root}/valid"
  another_path="${tmp_root}/another"
  missing_path="${tmp_root}/missing"

  mkdir -p "${baseline_path}" "${valid_path}" "${another_path}"

  export PATH="${PATH}:${baseline_path}"
}

teardown() {
  export PATH="${original_path}"
  [[ -d "${tmp_root}" ]] && rm -rf "${tmp_root}"
}

# TC - 1
@test "when-listing-paths-then-prints-path-entries" {
  export PATH="${PATH}:${valid_path}:${missing_path}"

  run __hhs_paths

  assert_success
  assert_output --partial "Listing all PATH entries"
  assert_output --partial "${valid_path}"
  assert_output --partial "${missing_path}"
}

# TC - 2
@test "when-cleaning-nonexistent-path-then-removes-it-from-paths-file-and-path" {
  export PATH="${PATH}:${valid_path}:${missing_path}"
  echo "${missing_path}" >>"${HHS_PATHS_FILE}"

  run __hhs_paths -c

  assert_success
  assert_output --partial "Listing all PATH entries"

  if grep -qxF "${missing_path}" "${HHS_PATHS_FILE}"; then
    fail "expected cleanup to remove \"${missing_path}\" from paths file"
  fi
}

# TC - 3
@test "when-adding-valid-path-then-updates-paths-file-and-path" {
  before_path="${PATH}:${PATH}"

  run __hhs_paths -a "${valid_path}"

  assert_success
  assert_output --partial "Path added: \"${valid_path}\""

  if ! grep -qxF "${valid_path}" "${HHS_PATHS_FILE}"; then
    fail "expected paths file to contain \"${valid_path}\""
  fi
}

# TC - 4
@test "when-adding-valid-path-in-quiet-mode-then-suppresses-output" {
  run __hhs_paths -q -a "${another_path}"

  assert_success
  assert_output ""

  if ! grep -qxF "${another_path}" "${HHS_PATHS_FILE}"; then
    fail "expected paths file to contain \"${another_path}\""
  fi
}

# TC - 5
@test "when-removing-existing-path-then-updates-paths-file-and-path" {
  __hhs_paths -q -a "${valid_path}"

  run __hhs_paths -r "${valid_path}"

  assert_success
  assert_output --partial "Path removed: \"${valid_path}\""

  if grep -qxF "${valid_path}" "${HHS_PATHS_FILE}"; then
    fail "expected paths file to remove \"${valid_path}\""
  fi
}

# TC - 6
@test "when-removing-missing-path-then-raises-an-error" {
  run __hhs_paths -r "${missing_path}"

  assert_failure
  assert_output --partial "✘ Fatal: __hhs_paths  Path \"${missing_path}\" is not in the PATH file"
}

# TC - 7
@test "when-adding-missing-path-then-raises-an-error" {
  run __hhs_paths -a "${missing_path}"

  assert_failure
  assert_output --partial "Path \"${missing_path}\" does not exist"
}

# TC - 8
@test "when-editing-paths-then-invokes-editor-with-paths-file" {
  run __hhs_paths -e

  assert_success
  assert_equal "$(cat "${edit_log}")" "${HHS_PATHS_FILE}"
}
