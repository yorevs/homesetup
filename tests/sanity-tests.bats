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

@test "check-hhs-dirs-exist-test" {
  [[ -d "${HHS_HOME}" && -d "${HHS_DIR}" ]]
}

@test "check-dotfiles-exist-test" {
  declare -a result=()

  for next in "${HHS_HOME}"/dotfiles/bash/*.bash; do
    dotfile="${HOME}/.$(basename "${next}")"
    dotfile="${dotfile%\.*}"
    echo "Checking dotfile: ${dotfile} ..."
    [[ -f "${dotfile}" ]] || result+=("${dotfile}")
  done

  [[ -f "${HOME}/.inputrc" ]] || result+=("${HOME}/.inputrc")
  [[ -f "${HHS_DIR}/.aliasdef" ]] || result+=("${HHS_DIR}/.aliasdef")
  [[ -f "${HHS_DIR}/.aliases" ]] || result+=("${HHS_DIR}/.aliases")
  [[ -f "${HHS_DIR}/.cmd_file" ]] || result+=("${HHS_DIR}/.cmd_file")
  [[ -f "${HHS_DIR}/.colors" ]] || result+=("${HHS_DIR}/.colors")
  [[ -f "${HHS_DIR}/.env" ]] || result+=("${HHS_DIR}/.env")
  [[ -f "${HHS_DIR}/.functions" ]] || result+=("${HHS_DIR}/.functions")
  [[ -f "${HHS_DIR}/.path" ]] || result+=("${HHS_DIR}/.path")
  [[ -f "${HHS_DIR}/.profile" ]] || result+=("${HHS_DIR}/.profile")
  [[ -f "${HHS_DIR}/.prompt" ]] || result+=("${HHS_DIR}/.prompt")
  [[ -f "${HHS_DIR}/.saved_dirs" ]] || result+=("${HHS_DIR}/.saved_dirs")


  [[ ${#result} -eq 0 ]]
}
