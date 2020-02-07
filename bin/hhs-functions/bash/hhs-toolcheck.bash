#!/usr/bin/env bash

#  Script: hhs-toolcheck.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Check whether a tool is installed on the system.
# @param $1 [Req] : The app to check.
function __hhs_toolcheck() {

  local pad pad_len tool_name check is_alias quiet

  if [[ "$#" -lt 1 || "$1" = "-h" || "$1" = "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <app_name>"
    echo ''
    echo '    Options: '
    echo '      -q  : Quiet mode on'
  else
    pad=$(printf '%0.1s' "."{1..60})
    pad_len=40
    if [[ "$1" = "-q" || "$1" = "--quiet" ]]; then shift; quiet=1; fi
    tool_name="$1"
    check=$(command -v "${tool_name}")
    is_alias=$(alias "${tool_name}" >/dev/null 2>&1 && echo "OK")
    [[ -z "$quiet" ]] && echo -en "${ORANGE}[${HHS_MY_OS}]${NC} "
    [[ -z "$quiet" ]] && echo -en "Checking: ${YELLOW}${tool_name}${NC} "
    [[ -z "$quiet" ]] && printf '%*.*s' 0 $((pad_len - ${#tool_name})) "$pad"
    if __hhs_has "${tool_name}"; then
      if [[ -z "$is_alias" && $check =~ ^(\/.*) ]]; then
        [[ -z "$quiet" ]] && echo -e "${GREEN} ${CHECK_ICN} INSTALLED${NC} at ${check}"
      elif [ -n "$is_alias" ]; then
        [[ -z "$quiet" ]] && echo -e "${CYAN} ${ALIAS_ICN} ALIASED${NC} as ${check}"
      else
        [[ -z "$quiet" ]] && echo -e "${BLUE} ${FUNC_ICN}  FUNCTION${NC} as ${check}"
      fi
      return 0
    else
      [[ -z "$quiet" ]] && echo -e "${RED} ${CROSS_ICN} NOT FOUND ${NC}"
    fi
  fi

  return 1
}

# @function: Check the version of the app using the most common ways.
# @param $1 [Req] : The app to check.
function __hhs_version() {

  local version

  if [[ "$#" -ne 1 || "$1" = "-h" || "$1" = "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <app_name>"
    return 1
  else
    # First attempt: app --version
    APP=$1
    if ! __hhs_toolcheck -q "${APP}"; then
      __hhs_errcho "${FUNCNAME[0]}: Can't check version. \"${APP}\" is not installed on the system! ${NC}"
      return 2
    fi
    
    if ! version=$(${APP} --version 2>&1); then
      if ! version=$(${APP} -v 2>&1); then
        if ! version=$(${APP} -version 2>&1); then
          if ! version=$(${APP} -V 2>&1); then
            if ! version=$(${APP} -Version 2>&1); then
              if ! version=$(${APP} --Version 2>&1); then
                __hhs_errcho "${FUNCNAME[0]}: Unable to find \"${APP}\" version using: (--version, --Version, -version, -Version, -v, -V) ${NC}"
                return 1
              fi
            fi
          fi
        fi
      fi
    fi
    echo -e "${version}"
  fi

  return 0
}

# @function: Check whether a list of development tools are installed.
function __hhs_tools() {

  if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} "
  else

    IFS=$' '
    for app in ${HHS_DEV_TOOLS[*]}; do
      __hhs_toolcheck "$app"
    done
    IFS="$RESET_IFS"

    echo ''
    echo -e "${YELLOW}${STAR_ICN} To check the current installed version, type: ${GREEN}#> ver <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To install/uninstall a tool, type: ${GREEN}#> hspm install/uninstall <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To override the list of tools, type: ${GREEN}#> export HHS_DEV_TOOLS=( \"tool1\" \"tool2\" ... )"
    echo -e "${NC}"
  fi

  return 0
}
