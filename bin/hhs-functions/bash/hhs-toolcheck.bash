#!/usr/bin/env bash

#  Script: hhs-toolcheck.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Check whether a tool is installed on the system.
# @param $1 [Req] : The app to check.
function __hhs_toolcheck() {

  local pad pad_len tool_name check is_alias quiet

  if [[ "$#" -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <app_name>"
    echo ''
    echo '    Options: '
    echo '      -q  : Quiet mode on'
  else
    pad=$(printf '%0.1s' "."{1..60})
    pad_len=20
    if [[ "$1" == "-q" || "$1" == "--quiet" ]]; then
      shift
      quiet=1
    fi
    tool_name="$1"
    check=$(command -v "${tool_name}")
    is_alias=$(alias "${tool_name}" >/dev/null 2>&1 && echo "OK")
    [[ -z "${quiet}" ]] && echo -en "${ORANGE}[${HHS_MY_OS}]${NC} "
    [[ -z "${quiet}" ]] && echo -en "Checking: ${YELLOW}${tool_name}${NC} "
    [[ -z "${quiet}" ]] && printf '%*.*s' 0 $((pad_len - ${#tool_name})) "${pad}"
    if __hhs_has "${tool_name}"; then
      if [[ -z "${is_alias}" && $check =~ ^(\/.*) ]]; then
        [[ -z "${quiet}" ]] && echo -e "${GREEN} ${CHECK_ICN} INSTALLED${NC} at ${check}"
      elif [[ -n "${is_alias}" ]]; then
        [[ -z "${quiet}" ]] && echo -e "${CYAN} ${ALIAS_ICN} ALIASED${NC} as ${check}"
      else
        [[ -z "${quiet}" ]] && echo -e "${BLUE} ${FUNC_ICN}  FUNCTION${NC} as ${check}"
      fi
      return 0
    else
      [[ -z "${quiet}" ]] && echo -e "${RED} ${CROSS_ICN} NOT FOUND ${NC}"
    fi
  fi

  return 1
}

# @function: Check the version of the app using the most common ways.
# @param $1 [Req] : The app to check.
function __hhs_version() {

  local version APP

  if [[ "$#" -ne 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <app_name>"
    return 1
  else
    # First attempt: app --version
    APP=$1
    if ! __hhs_toolcheck -q "${APP}"; then
      __hhs_errcho "${FUNCNAME[0]}: Can't check version. \"${APP}\" is not installed on the system! ${NC}"
      return 2
    fi
    # I know that this is ugly, but it has to be that way ;(
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

# @function: Check whether a list of development tools are installed or not.
# @param $1..$N [Opt] : The tool list to be checked.
function __hhs_tools() {

  local tool_list

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [tool_list]"
    return 1
  else
    if [[ $# -gt 0 ]]; then
      tool_list=$*
    else
      tool_list=${HHS_DEV_TOOLS[*]}
    fi
    IFS=$' '
    for app in ${tool_list}; do
      __hhs_toolcheck "$app"
    done
    IFS="${OLDIFS}"

    echo ''
    echo -e "${YELLOW}${STAR_ICN} To check the current installed version, type: ${GREEN}#> ver <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To install/uninstall a tool, type: ${GREEN}#> hspm install/uninstall <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To override the list of tools, type: ${GREEN}#> export HHS_DEV_TOOLS=( \"tool1\" \"tool2\" ... )"
    echo -e "${NC}"
  fi

  return 0
}

# @function: Display information about the given command.
# @param $1 [Req] : The command to check.
function __hhs_about() {

  local cmd cmd_ret cmd_details="Command:"

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  else
    cmd=${1}
    cmd_ret=$(type "${cmd}" 2>/dev/null | head -n 1)
    if [[ -n "${cmd_ret}" ]]; then
      echo ''
      if [[ "${cmd_ret}" == *"is aliased to"* ]]; then
        cmd_details="Aliased:"
        cmd_ret=${cmd_ret//is aliased to \`/${WHITE}=> }
        cmd_ret=${cmd_ret//\'/}
      else
        cmd_ret=${cmd_ret//is /${WHITE}=> }
      fi
      printf "${GREEN}%12s${BLUE} ${cmd_ret//\%/%%} ${NC}\n" "${cmd_details}"
      if unalias "${cmd}" 2>/dev/null; then
        cmd_ret=$(type "${cmd}" 2>/dev/null | head -n 1)
        if [[ -n "${cmd_ret}" ]]; then
          cmd_ret=${cmd_ret//is/${WHITE}=>}
          printf "${GREEN}%12s${BLUE} ${cmd_ret} ${NC}\n" "Unaliased:"
        fi
      fi
      echo ''
    fi
  fi

  return 0
}

# @function: Display a help for the given command.
# @param $1 [Req] : The command to get help.
function __hhs_help() {

  local cmd re_alias re_func

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  else
    cmd="${1}"
    __hhs_about "${cmd}"
    re_alias="${cmd} is aliased to \`__hhs.*"
    re_func="${cmd} is a function"
    if [[ ${cmd} = __hhs_* || $(type "${cmd}") =~ ${re_func} ]]; then
      ${cmd} --help 2>/dev/null || __hhs_errcho "${RED}Help not available for ${cmd}"
    elif [[ $(type "${cmd}") =~ ${re_alias} ]]; then
      cmd="$(type "${cmd}")"
      cmd="${cmd#* to \`}"
      cmd="${cmd//\'/}"
      ${cmd} --help
    else
      command help "${cmd}" 2>/dev/null || __hhs_errcho "${RED}Help not available for ${cmd}"
    fi
  fi

  return 0
}
