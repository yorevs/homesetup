#!/usr/bin/env bats

#  Script: sample-tests.bats
# Purpose: HomeSetup sanity tests.
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

@test "test-check-hhs-dirs-exist" {
  [[ \
    -d "${HHS_HOME}" \
    && -d "${HHS_DIR}" \
    && -d "${HHS_LOG_DIR}" \
    && -d "${HHS_BACKUP_DIR}" \
    && -d "${HHS_CACHE_DIR}" \
  ]]
}

@test "test-check-dotfiles-exist" {
  declare -a missing=()

  for next in "${HHS_HOME}"/dotfiles/bash/*.bash; do
    dotfile="${HOME}/.$(basename "${next}")"
    dotfile="${dotfile%\.*}"
    [[ -L "${dotfile}" ]] || missing+=("${dotfile}")
  done

  [[ -f "${HOME}/.inputrc" ]] || missing+=("${HOME}/.inputrc")
  [[ -f "${HHS_DIR}/.aliasdef" ]] || missing+=("${HHS_DIR}/.aliasdef")
  [[ -f "${HHS_DIR}/.aliases" ]] || missing+=("${HHS_DIR}/.aliases")
  [[ -f "${HHS_DIR}/.cmd_file" ]] || missing+=("${HHS_DIR}/.cmd_file")
  [[ -f "${HHS_DIR}/.colors" ]] || missing+=("${HHS_DIR}/.colors")
  [[ -f "${HHS_DIR}/.env" ]] || missing+=("${HHS_DIR}/.env")
  [[ -f "${HHS_DIR}/.functions" ]] || missing+=("${HHS_DIR}/.functions")
  [[ -f "${HHS_DIR}/.path" ]] || missing+=("${HHS_DIR}/.path")
  [[ -f "${HHS_DIR}/.profile" ]] || missing+=("${HHS_DIR}/.profile")
  [[ -f "${HHS_DIR}/.prompt" ]] || missing+=("${HHS_DIR}/.prompt")
  [[ -f "${HHS_DIR}/.saved_dirs" ]] || missing+=("${HHS_DIR}/.saved_dirs")

  [[ ${#missing[@]} -eq 0 ]] || echo "Missing dotfiles: ${missing[*]}"

  [[ ${#missing[@]} -eq 0 ]]
}
