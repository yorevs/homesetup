#!/usr/bin/env bash

#  Script: web.bash
# Purpose: Contains all HHS-App web based functions
# Created: Nov 29, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: Open a docsify version of the HomeSetup README.
function docsify() {

  local docsify_url raw_content_url url

  docsify_url='https://docsify-this.net/?basePath='
  raw_content_url="${HHS_GITHUB_URL//github/raw.githubusercontent}/master&sidebar=true"
  url="${docsify_url}${raw_content_url}"

  echo "${ORANGE}Opening HomeSetup docsify README from: ${url} ${NC}"
  sleep 2

  __hhs_open "${url}" && quit 0

  quit 1 "Failed to open url \"${url}\" !"
}

# @purpose: Open the HomeSetup GitHub project board.
function board() {

  local raw_content_url="${HHS_GITHUB_URL}/projects/1"

  echo "${ORANGE}Opening HomeSetup board from: ${raw_content_url} ${NC}"
  sleep 2
  __hhs_open "${raw_content_url}" && quit 0

  quit 1 "Failed to open url \"${raw_content_url}\" !"
}
