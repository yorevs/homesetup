#!/usr/bin/env bats

#  Script: sample.bats
# Purpose: Bats sample file
# Created: Mar 02, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

@test "check-install-dirs-test" {
  [[ -d "$HHS_HOME" && -d "$HHS_DIR" ]]
}
