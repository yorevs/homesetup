#  Script: test_helper.bash
# Purpose: HomeSetup test helper.
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Bats help can be found at: https://bats-core.readthedocs.io/en/stable/

export DOTFILES_DIR="${HHS_HOME}/dotfiles"
export HHS_FUNCTIONS_DIR="${HHS_HOME}/bin/hhs-functions/bash"
export BATS_DIR="${HHS_HOME}/tests/bats"

export BATS_SUPPORT="${BATS_DIR}/bats-support/load"
export BATS_ASSERT="${BATS_DIR}/bats-assert/load"

load "${HHS_HOME}/dotfiles/bash/bash_commons.bash"

# @purpose: Load all bats libraries
load_bats_libs() {
  load "${BATS_SUPPORT}"
  load "${BATS_ASSERT}"
}

# @purpose: Unset all bash colors to avoid failing tests due to escape codes.
unset_colors() {
  unset HHS_HIGHLIGHT_COLOR NC BLACK RED GREEN ORANGE BLUE PURPLE CYAN GRAY WHITE YELLOW VIOLET
}

unset_colors
