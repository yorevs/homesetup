#!/usr/bin/env bash

#  Script: hhs.bash
# Purpose: HomeSetup application
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
# License: Please refer to <http://unlicense.org/>

# Functions to be unset after quit
UNSETS+=(
  'main' 'has_function' 'has_plugin' 'has_command' 'validate_plugin'
  'register_plugins' 'register_functions' 'parse_args' 'invoke_command'
)

# shellcheck disable=SC2034
# Program version
VERSION=0.9.1

# shellcheck disable=SC2034
# Usage message
USAGE="
Usage: ${APP_NAME} [option] <plugin_name> {task} <command> [args...]

    HomeSetup Application Manager.
    
    Options:
      -v  |  --version              : Display current program version.
      -h  |     --help              : Display this help message.
    
    Tasks:
      help            : Display a help about the plugin.
      version         : Display current plugin version.
      execute         : Execute a plugin command.

    Arguments:
      args    : Plugin command arguments will depend on the plugin. May be mandatory or not.
    
    Exit Status:
      (0) Success.
      (1) Failure due to missing/wrong client input or similar issues.
      (2) Failure due to program/plugin execution failures.
"

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# List of local functions that can be executed
LOCAL_FUNCTIONS=()

# List of required functions a plugin must have
PLUGINS_FNCS=('help' 'version' 'execute')

# List of valid plugins
PLUGINS_LIST=()

# List plugin commands
PLUGINS=()

# Purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
has_function() {

  if [ -n "${1}" ] && [[ ${LOCAL_FUNCTIONS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
has_plugin() {

  if [ -n "${1}" ] && [ "${#PLUGINS[@]}" -gt 0 ] && [[ ${PLUGINS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Checks whether a plugin contains the command or not
# @param $1 [Req] : The command name.
has_command() {

  if [ -n "${1}" ] && [ "${#PLUGINS_FNCS[@]}" -gt 0 ] && [[ ${PLUGINS_FNCS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Validates if the plugin contains the required hhs application plugin structure
# @param $1 [Req] : Array of plugin functions.
validate_plugin() {

  local i=0 j=0 plg_fncs=("$@")

  while [ "$i" -lt "${#PLUGINS_FNCS[@]}" ]; do
    if [ "${plg_fncs[j]}" = "${PLUGINS_FNCS[i]}" ]; then
      i=$((i + 1))
      j=0
      [ $i = ${#PLUGINS_FNCS[@]} ] && return 0
    else
      j=$((j + 1))
      [ $j = ${#plg_fncs[@]} ] && return 1
    fi
  done

  return 1
}

# Purpose: Search and register all hhs application plugins
register_plugins() {

  local plg_fncs=()

  while IFS='' read -r plugin; do
    while IFS='' read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      plg_fncs+=("${f_name}")
    done < <(grep '^function .*()' < "${plugin}")
    if ! validate_plugin "${plg_fncs[@]}"; then
      INVALID+=("$(basename "${plugin}")")
    else
      plg_name=$(basename "${plugin%.*}")
      PLUGINS+=("${plg_name}")
      PLUGINS_LIST+=("${plugin}")
    fi
  done < <(find "${HHS_PLUGINS_DIR}" -maxdepth 2 -type f -iname "*.bash")
  IFS=$"$HHS_RESET_IFS"
}

# Purpose: Parse command line arguments
parse_args() {

  # If no argument is passed, just enter HomeSetup directory
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

      *)
        break
        ;;
    esac
    shift
  done
}

# shellcheck disable=SC1090
# Purpose: Invoke the plugin command
invoke_command() {

  has_plugin "${1}" || quit 1 "Plugin/Function not found: \"${1}\" ! Type 'hhs list' to find out options."
  # Open a new subshell, so that we can configure the running environment
  (
    for idx in "${!PLUGINS[@]}"; do
      if [[ "${PLUGINS[idx]}" = "${1}" ]]; then
        [ -s "${PLUGINS_LIST[idx]}" ] || exit 1
        \. "${PLUGINS_LIST[idx]}"
        shift
        plg_cmd="${1}"
        has_command "${plg_cmd}" || quit 1 "Command not available: ${plg_cmd}"
        shift
        ${plg_cmd} "${@}"
        ret=${?}
        cleanup
        unset "${PLUGINS_FNCS[@]}"
        exit $ret
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

# Purpose: Read all iinternal functions and make them available to use
register_functions() {

  while IFS='' read -r fnc; do
    f_name="${fnc##function }"
    f_name="${f_name%\(\) \{}"
    LOCAL_FUNCTIONS+=("${f_name}")
  done < <(grep '^function .*()' < "$0")
  # Register the functions to be unset when program quits
  UNSETS+=("${LOCAL_FUNCTIONS[@]}")
}

# ------------------------------------------
# Local functions

# Functions MUST start with 'function' keyword and
# MUST quit <exit)coode> with the proper exit code

# Purpose: Provide a help for __hhs functions
function help() {

  usage 0
}

# Purpose: List all __hhs functions
function list() {

  register_plugins
  echo ' '
  echo "${YELLOW}Available HomeSetup Application Manager plugins (${#PLUGINS[@]}):"
  echo ' '
  for idx in "${!PLUGINS[@]}"; do
    echo -e "${WHITE}$((idx + 1)). Registered plug-in => ${BLUE}\"${PLUGINS[$idx]}\"${NC}"
  done
  quit 0
}

# ------------------------------------------
# Purpose: Program entry point
main() {
  parse_args "${@}"
  register_functions
  if has_function "${1}"; then
    ${1} "${@}"
    quit 0 # If we use an internal function, we don't need to scan for plugins, so just quit after call.
  fi
  register_plugins
  [[ ${#INVALID[@]} -gt 0 ]] && quit 1 "Invalid plugins found: [${RED}${INVALID[*]}${NC}]"

  invoke_command "${@}" || quit 2 "Failed to execute (${?}) plugin: \"${1}\" !"
}

main "${@}"
