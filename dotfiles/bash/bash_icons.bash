#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: bash_icons.bash
# Purpose: This file is used to hold all terminal icon definitions
# Created: Nov 28, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your icons edit the file ~/.env

# Do not source this file multiple times
if list_contains "${HHS_ACTIVE_DOTFILES}" "bash_icons"; then
  __hhs_log "WARN" "bash_icons was already loaded!"
fi

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_icons"

# Fontawesome icons
ALIAS_ICN="\xef\x81\xa1"
CHECK_ICN="\xef\x81\x98"
CROSS_ICN="\xef\x81\x97"
FAIL_ICN="\xef\x91\xa7"
FUNC_ICN="\xef\x84\xae"
HAND_PEACE_ICN='\xef\x89\x9b'
OFF_ICN="\xef\x88\x84"
ON_ICN="\xef\x88\x85"
PASS_ICN="\xef\x98\xab"
POINTER_ICN='\xef\x90\xb2'
SKIP_ICN="\xef\x81\x99"
STAR_ICN="\xef\x80\x85"
TEST_FAIL_ICN="\xef\x91\xae"
TEST_PASS_ICN="\xef\x98\xac"
