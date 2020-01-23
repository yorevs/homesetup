#  Script: built-ins.bash
# Purpose: Contains all od the HHS-App callable functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Purpose: Provide a help for __hhs functions
function help() {

  usage 0
}

# Purpose: List all HHS App Plug-ins and HHS-Functions
function list() {

  echo ' '
  echo "${YELLOW}HomeSetup Application Manager"
  echo ' '
  echo " ${YELLOW}---- Plugins"
  echo ' '
  for idx in "${!PLUGINS[@]}"; do
    printf "${WHITE}%.2d. " "$((idx + 1))"
    echo -e "Registered plug-in => ${HHS_HIGHLIGHT_COLOR}\"${PLUGINS[$idx]}\"${NC}"
  done

  echo ' '
  echo " ${YELLOW}---- Functions"
  echo ' '
  for idx in "${!HHS_APP_FUNCTIONS[@]}"; do
    printf "${WHITE}%.2d. " "$((idx + 1))"
    echo -e "Registered built-in function => ${HHS_HIGHLIGHT_COLOR}\"${HHS_APP_FUNCTIONS[$idx]}\"${NC}"
  done

  quit 0
}

# Purpose: List all __hhs_functions describing it's containing file name and line number.
function functions() {

  register_hhs_functions

  echo "${YELLOW}Available HomeSetup Functions"
  echo ' '
  for idx in "${!HHS_FUNCTIONS[@]}"; do
    printf "${WHITE}%.2d. " "$((idx + 1))"
    echo -e "Registered __hhs_<function> => ${HHS_HIGHLIGHT_COLOR}\"${HHS_FUNCTIONS[$idx]}\"${NC}"
  done
}

# Purpose: List all HomeSetup issues from GitHub.
function issues() {

  local repo_url="https://github.com/yorevs/homesetup/issues"

  echo "${GREEN}Opening HomeSetup issues from: ${repo_url} ${NC}"
  open "${repo_url}"

  return $?
}
