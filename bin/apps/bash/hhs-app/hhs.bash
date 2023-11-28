#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: hhs.bash
# Purpose: HomeSetup application
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

APP_NAME="__hhs"

# Functions to be unset after quit.
UNSETS+=(
  'main' 'cleanup_plugins' 'parse_args' 'list' 'has_function' 'has_plugin' 'has_command'
  'validate_plugin' 'register_plugins' 'register_functions' 'parse_args'
  'find_hhs_functions' 'get_desc' 'search_hhs_functions' 'invoke_command'
)

# Program version.
VERSION=1.0.0

# Help message to be displayed by the application.
USAGE="
Usage: ${APP_NAME} [option] {function | plugin {task} <command>} [args...]

 _   _                      ____       _
| | | | ___  _ __ ___   ___/ ___|  ___| |_ _   _ _ __
| |_| |/ _ \\| '_ \` _ \\ / _ \\___ \\ / _ \ __| | | | '_ \\
|  _  | (_) | | | | | |  __/___) |  __/ |_| |_| | |_) |
|_| |_|\\___/|_| |_| |_|\\___|____/ \\___|\\__|\\__,_| .__/
                                                |_|

  HomeSetup Application Manager v${VERSION}.

    Arguments:
      args              : Plugin command arguments will depend on the plugin. May be mandatory
                          or not.

    Options:
      -v  |  --version  : Display current program version.
      -h  |     --help  : Display this help message.
      -p  |   --prefix  : Display the HomeSetup installation directory.

    Tasks:
      help              : Display a help about the plugin.
      version           : Display current plugin version.
      execute           : Execute a plugin command.

    Exit Status:
      (0) Success.
      (1) Failure due to missing/wrong client input or similar issues.
      (2) Failure due to program/plugin execution failures.

  Notes:
    - To discover which plugins and functions are available type: hhs list
"

# Directory containing all HHS plug-ins.
PLUGINS_DIR="$(dirname "${0//${HHS_DIR}/$HHS_HOME}")/apps/${HHS_MY_SHELL}/hhs-app/plugins"

# Directory containing all local HHS functions.
FUNCTIONS_DIR="$(dirname "${0//${HHS_DIR}/$HHS_HOME}")/apps/${HHS_MY_SHELL}/hhs-app/functions"

# List of local hhs functions that can be executed.
HHS_APP_FUNCTIONS=()

# List of HomeSetup functions available.
HHS_FUNCTIONS=()

# List of required functions a plugin must have.
PLUGINS_FUNCS=('help' 'cleanup' 'version' 'execute')

# List of valid plugins.
PLUGINS_LIST=()

# List plugin commands.
PLUGINS=()

# @purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
function has_function() {

  if [[ -n "${1}" ]] && list_contains "${HHS_APP_FUNCTIONS[*]}" "${1}"; then
    return 0
  fi

  return 1
}

# @purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
function has_plugin() {

  if [[ -n "${1}" ]] && list_contains "${PLUGINS[*]}" "${1}"; then
    return 0
  fi

  return 1
}

# @purpose: Checks whether a plugin contains the command or not
# @param $1 [Req] : The command name.
function has_command() {

  if [[ -n "${1}" ]] && list_contains "${PLUGINS_FUNCS[*]}" "${1}"; then
    return 0
  fi

  return 1
}

# @purpose: Validates if the plugin contains the required hhs application plugin structure
# @param $1 [Req] : Array of plugin functions.
function validate_plugin() {

  local i=0 j=0 plg_funcs=("$@")

  while [[ "$i" -lt "${#PLUGINS_FUNCS[@]}" ]]; do
    if [[ "${plg_funcs[j]}" == "${PLUGINS_FUNCS[i]}" ]]; then
      ((i += 1))
      j=0
      [[ $i == "${#PLUGINS_FUNCS[@]}" ]] && return 0
    else
      ((j += 1))
      [[ $j == "${#plg_funcs[@]}" ]] && return 1
    fi
  done

  return 1
}

# @purpose: Search and register all hhs application plugins
function register_plugins() {

  local f_name plg_funcs=() plg_name

  IFS=$'\n'
  while read -r plugin; do
    while read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      plg_funcs+=("${f_name}")
    done < <(grep '^function .*()' <"${plugin}")
    if ! validate_plugin "${plg_funcs[@]}"; then
      INVALID+=("$(basename "${plugin}")")
    else
      plg_name=$(basename "${plugin%.*}")
      PLUGINS+=("${plg_name}")
      PLUGINS_LIST+=("${plugin}")
    fi
  done < <(find "${PLUGINS_DIR}" -maxdepth 2 -type f -iname "*.bash")
  IFS="${OLDIFS}"

  return 0
}

# @purpose: Read all internal functions and make them available to use
function register_functions() {

  local f_name

  IFS=$'\n'
  while read -r fnc_file; do
    source "${fnc_file}"
    while read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      HHS_APP_FUNCTIONS+=("${f_name}")
    done < <(grep '^function .*()' <"${fnc_file}")
    # Register the functions to be unset when program quits
    UNSETS+=("${HHS_APP_FUNCTIONS[@]}")
  done < <(find "${FUNCTIONS_DIR}" -maxdepth 1 -type f -name '*.bash')
  IFS="${OLDIFS}"

  return 0
}

# @purpose: Invoke the plugin command
function invoke_command() {

  local plg_cmd ret

  has_plugin "${1}" || quit 1 "Plugin/Function not found: \"${1}\" ! Type 'hhs list' to find out options."
  # Open a new subshell, so that we can configure the running environment properly
  (
    # We have to use exit and not quit, because we are in a subshell
    for idx in "${!PLUGINS[@]}"; do
      if [[ "${PLUGINS[idx]}" == "${1}" ]]; then
        [[ -s "${PLUGINS_LIST[idx]}" ]] || exit 1
        source "${PLUGINS_LIST[idx]}"
        shift
        plg_cmd="${1:-execute}"
        has_command "${plg_cmd}" || quit 1 "#1-Command not available: ${plg_cmd}"
        shift
        # Execute the specified plugin
        ${plg_cmd} "${@}"
        ret=${?}
        cleanup
        exit ${ret}
      else
        [[ $((idx + 1)) -eq ${#PLUGINS[@]} ]] && exit 255
      fi
    done
    exit 0
  )
  ret=${?}
  [[ ${ret} -eq 255 ]] && quit 1 "Plugin/Function not found: \"${1}\" ! Type 'hhs list' to find out options."

  return ${ret}
}

# ------------------------------------------
# Local functions

# Functions MUST start with 'function' keyword and
# MUST quit <exit_code> with the proper exit code

function get_desc() {

  local path filename line_num re

  path=$(awk -F ':function' '{print $1}'  <<<"$1")
  filename=$(awk -F '.bash:' '{print $1}'  <<<"$path")
  line_num=$(awk -F '.bash:' '{print $2}'  <<<"$path")
  line_num=${line_num// /}
  re='# @function: '

  for i in $(seq "${line_num}" -1 1); do
    line=$(sed -n "${i}p" "${filename}".bash)
    desc="${line//# @function: /}"
    desc=$(echo "$desc" | awk '{$1=$1};1')
    [[ $line =~ $re ]] && echo "${desc}" && break
  done
}

# @purpose: Search for all hhs-functions and make them available to use.
# @param $1..$N [Req] : The directories to search from.
function search_hhs_functions() {

  local all_hhs_fn=() filename fn_name desc

  IFS=$'\n'
  read -r -d '' -a all_hhs_fn < <(grep -nR "^\( *function *__hhs_\)" "${@}" | sed -E 's/: +/:/' | awk "NR != 0 {print \$1 \$2}" | sort | uniq)
  for fn_line in "${all_hhs_fn[@]}"; do
    filename=$(basename "${fn_line}" | awk -F ':function' '{print $1}')
    filename=$(printf '%-35.35s' "${filename}")
    fn_name=$(awk -F ':function' '{print $2}' <<<"${fn_line}")
    fn_name=$(printf '%-35.35s' "${fn_name//\(\)/}")
    desc=$(get_desc "${fn_line}")
    HHS_FUNCTIONS+=("${BLUE}${filename// /.} ${GREEN}=> ${NC}${fn_name// /.} : ${YELLOW}${desc}")
  done
  IFS="${OLDIFS}"

  return 0
}

# ------------------------------------------
# Basics

# @purpose: Parse command line arguments
function parse_args() {

  # If not enough arguments is passed, display usage message.
  if [[ ${#} -eq 0 ]]; then
    usage 0
  fi

  # Loop through the command line options.
  # Short opts: -<C>, Long opts: --<Word>
  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
    -h | --help)
      usage 0
      ;;
    -v | --version)
      version
      ;;
    -p | --prefix)
        echo ''
        echo -e "${BLUE}Version: ${WHITE}${HHS_VERSION}${NC}"
        echo -e "${BLUE} Prefix: ${WHITE}${HHS_HOME}${NC}"
        echo -e "${BLUE}Configs: ${WHITE}${HHS_DIR}${NC}"
        echo ''
        quit 0
      ;;
    *)
      break
      ;;
    esac
    shift
  done
}

# @purpose: Cleanup plugin functions.
function cleanup_plugins() {
  unset -f "${PLUGINS_FUNCS[@]}"
}

# @purpose: Program entry point.
function main() {

  local fn_name

  parse_args "${@}"
  register_functions
  register_plugins

  fn_name="${1//help/list}"

  if has_function "${fn_name}"; then
    shift
    ${fn_name} "${@}"
    quit 0 # If we use an internal function, we don't need to scan for plugins, so just quit after call.
  fi

  [[ ${#INVALID[@]} -gt 0 ]] && quit 1 "Invalid plugins found: [${RED}${INVALID[*]}${NC}]"

  invoke_command "${@}" || quit 2
  cleanup_plugins
}

source "${HHS_DIR}/bin/app-commons.bash"

main "${@}"
quit 1
