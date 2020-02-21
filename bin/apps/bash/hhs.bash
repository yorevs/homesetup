#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: hhs.bash
# Purpose: HomeSetup application
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
# License: Please refer to <http://unlicense.org/>

# Functions to be unset after quit
UNSETS+=(
  'main' 'help' 'list' 'has_function' 'has_plugin' 'has_command' 'validate_plugin'
  'register_plugins' 'register_local_functions' 'parse_args' 'invoke_command' 'register_hhs_functions'
)

# Program version
VERSION=1.0.0

# Usage message
USAGE="
Usage: ${APP_NAME} [option] {function | plugin {task} <command>} [args...]

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
  
  Notes: 
    - To discover which plugins and functions are available type: hhs list
"

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

__hhs_has "python" || quit 1 "Python is required to execute ${APP_NAME}"

# Directory containing all HHS plug-ins
PLUGINS_DIR="$(dirname "${0//${HHS_DIR}/$HHS_HOME}")/apps/${HHS_MY_SHELL}/hhs-app/plugins"

# Directory containing all local HHS functions.
FUNCTIONS_DIR="$(dirname "${0//${HHS_DIR}/$HHS_HOME}")/apps/${HHS_MY_SHELL}/hhs-app/functions"

# List of local hhs functions that can be executed.
HHS_APP_FUNCTIONS=()

# List of HomeSetup functions available.
HHS_FUNCTIONS=()

# List of required functions a plugin must have.
PLUGINS_FUNCS=('help' 'version' 'execute')

# List of valid plugins
PLUGINS_LIST=()

# List plugin commands
PLUGINS=()

# Purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
has_function() {

  if [[ -n "${1}" && ${HHS_APP_FUNCTIONS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Checks whether a plugin is registered or not.
# @param $1 [Req] : The plugin name.
has_plugin() {

  if [[ -n "${1}" && "${#PLUGINS[@]}" -gt 0 && ${PLUGINS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Checks whether a plugin contains the command or not
# @param $1 [Req] : The command name.
has_command() {

  if [[ -n "${1}" && "${#PLUGINS_FUNCS[@]}" -gt 0 && ${PLUGINS_FUNCS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# Purpose: Validates if the plugin contains the required hhs application plugin structure
# @param $1 [Req] : Array of plugin functions.
validate_plugin() {

  local i=0 j=0 plg_funcs=("$@")

  while [[ "$i" -lt "${#PLUGINS_FUNCS[@]}" ]]; do
    if [[ "${plg_funcs[j]}" == "${PLUGINS_FUNCS[i]}" ]]; then
      i=$((i + 1))
      j=0
      [[ $i == "${#PLUGINS_FUNCS[@]}" ]] && return 0
    else
      j=$((j + 1))
      [[ $j == "${#plg_funcs[@]}" ]] && return 1
    fi
  done

  return 1
}

# Purpose: Search and register all hhs application plugins
register_plugins() {

  local plg_funcs=()

  while IFS='' read -r plugin; do
    while IFS='' read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      plg_funcs+=("${f_name}")
    done < <(grep '^function .*()' < "${plugin}")
    if ! validate_plugin "${plg_funcs[@]}"; then
      INVALID+=("$(basename "${plugin}")")
    else
      plg_name=$(basename "${plugin%.*}")
      PLUGINS+=("${plg_name}")
      PLUGINS_LIST+=("${plugin}")
    fi
  done < <(find "${PLUGINS_DIR}" -maxdepth 2 -type f -iname "*.bash")
  IFS=$"${RESET_IFS}"
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

# Purpose: Invoke the plugin command
invoke_command() {

  has_plugin "${1}" || quit 1 "Plugin/Function not found: \"${1}\" ! Type 'hhs list' to find out options."
  # Open a new subshell, so that we can configure the running environment properly
  (
    for idx in "${!PLUGINS[@]}"; do
      if [[ "${PLUGINS[idx]}" == "${1}" ]]; then
        [[ -s "${PLUGINS_LIST[idx]}" ]] || exit 1
        \. "${PLUGINS_LIST[idx]}"
        shift
        plg_cmd="${1:-help}"
        has_command "${plg_cmd}" || quit 1 "#1-Command not available: ${plg_cmd}"
        shift
        ${plg_cmd} "${@}"
        ret=${?}
        cleanup
        unset "${PLUGINS_FUNCS[@]}"
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

# Purpose: Read all internal functions and make them available to use
register_local_functions() {

  while IFS=$'\n' read -r fnc_file; do
    \. "${fnc_file}"
    while IFS='' read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      HHS_APP_FUNCTIONS+=("${f_name}")
    done < <(grep '^function .*()' < "${fnc_file}")
    # Register the functions to be unset when program quits
    UNSETS+=("${HHS_APP_FUNCTIONS[@]}")
  done < <(find "${FUNCTIONS_DIR}" -maxdepth 1 -type f -name '*.bash')
}

# ------------------------------------------
# Local functions

# Functions MUST start with 'function' keyword and
# MUST quit <exit)coode> with the proper exit code

# Purpose: Find all hhs-functions and make them available to use
register_hhs_functions() {

  local all_hhs_fn

  all_hhs_fn=$(grep -nR "^function __hhs_" "${HHS_HOME}" | sed -E 's/:  /:/' | awk "NR != 1 {print \$1 \$2}")

  for fn in ${all_hhs_fn}; do
    filename=$(basename "$fn" | awk -F ':function' '{print $1}')
    filename=$(printf '%-30.30s' "${filename}")
    fn_name=$(awk -F ':function' '{print $2}' <<< "$fn")
    HHS_FUNCTIONS+=("${filename// /.} => ${fn_name}")
  done
  echo "${NR}"

  return 0
}

# ------------------------------------------
# Purpose: Program entry point
main() {
  
  local fname
  
  parse_args "${@}"
  register_local_functions
  register_plugins
  if has_function "${1}"; then
    fname="${1}"
    shift
    ${fname} "${@}"
    quit 0 # If we use an internal function, we don't need to scan for plugins, so just quit after call.
  fi
  [[ ${#INVALID[@]} -gt 0 ]] && quit 1 "Invalid plugins found: [${RED}${INVALID[*]}${NC}]"

  invoke_command "${@}" || quit 2
}

main "${@}"
quit 0
