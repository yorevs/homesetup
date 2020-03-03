#!/usr/bin/env bats

#  Script: sample-tests.bats
# Purpose: HomeSetup sanity tests.
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

@test "check-hhs-dirs-exist-test" {
  [[ -d "$HHS_HOME" && -d "$HHS_DIR" ]]
}

@test "check-dotfiles-exist-test" {
  declare -a result=()

  for next in "$HHS_HOME"/dotfiles/bash/*.bash; do
    dotfile="${HOME}/.$(basename "${next}")"
    dotfile="${dotfile%\.*}"
    [[ -f "${dotfile}" ]] || result+=("${dotfile}")
  done

  [[ -f "${HOME}/.aliasdef" ]] || result+=("${HOME}/.aliasdef")
  [[ -f "${HOME}/.inputrc" ]] || result+=("${HOME}/.inputrc")

  [[ ${#result} -eq 0 ]]
}
