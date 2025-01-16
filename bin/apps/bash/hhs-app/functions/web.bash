#!/usr/bin/env bash

#  Script: web.bash
# Purpose: Contains all HHS-App web based functions
# Created: Nov 29, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team


# @purpose: Open the HomeSetup GitHub page.
function github() {

  local page_url="https://github.com/yorevs/homesetup"

  echo -e "${BLUE}${GLOBE_ICN} Opening HomeSetup github page from: ${page_url}${ELLIPSIS_ICN}${NC}"
  __hhs_open "${page_url}" && sleep 2 && quit 0

  quit 1 "Failed to open url: \"${page_url}\" !"
}

# @purpose: Open the HomeSetup GitHub project board.
function board() {

  local page_url="${HHS_GITHUB_URL}/projects/1"

  echo -e "${BLUE}${GLOBE_ICN} Opening HomeSetup board from: ${page_url}${ELLIPSIS_ICN}${NC}"
  __hhs_open "${page_url}" && sleep 2 && quit 0

  quit 1 "Failed to open url: \"${page_url}\" !"
}

# @purpose: Open the HomeSetup GitHub sponsors page.
function sponsor() {

  local page_url="https://github.com/sponsors/yorevs"

  echo -e "${BLUE}${GLOBE_ICN} Opening HomeSetup sponsors page from: ${page_url}${ELLIPSIS_ICN}${NC}"
  __hhs_open "${page_url}" && sleep 2 && quit 0

  quit 1 "Failed to open url: \"${page_url}\" !"
}

# @purpose: Open a docsify version of the HomeSetup README.
function docsify() {

  local docsify_url page_url github_url

  docsify_url='https://docsify-this.net/?basePath='
  github_url="${HHS_GITHUB_URL//github/raw.githubusercontent}/master&sidebar=true"
  page_url="${docsify_url}${github_url}"

  echo -e "${BLUE}${GLOBE_ICN} Opening HomeSetup docsify README from: ${page_url}${ELLIPSIS_ICN}${NC}"
  __hhs_open "${page_url}" && sleep 2 && quit 0

  quit 1 "Failed to open url: \"${page_url}\" !"
}
