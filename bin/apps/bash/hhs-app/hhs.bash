#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034

#  Script: hhs.bash
# Purpose: HomeSetup application
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

APP_NAME="__hhs"

# Functions to be unset after quit.
UNSETS+=(
  'main' 'cleanup_plugins' 'parse_args' 'list' 'has_function' 'has_plugin' 'has_command'
  'validate_plugin' 'register_plugins' 'register_functions' 'parse_args' 'has_hhs_function'
  'find_hhs_functions' 'get_desc' 'search_hhs_functions' 'invoke_command' 'display_list'
)

# Program version.
VERSION=1.0.0

# Help message to be displayed by the application.
USAGE="usage: ${APP_NAME} [option] {function | plugin {task} <command>} [args...]

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
    - To discover which plugins and functions are available type: ${APP_NAME} list.
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

# @purpose: Checks whether the command matches a __hhs function or not and invoke it.
# @param $1..$N [Req] : The command line arguments.
function invoke_hhs_function() {
  local args=("$@") max_words=5 joined="" pattern functions

  # Loop to form combinations starting from max_words down to 1
  for ((i = (max_words < ${#args[@]}) ? max_words : ${#args[@]}; i > 0; i--)); do
      # Wrap to a probable '__hhs' command
      joined="__hhs_$(printf "%s_" "${args[@]:0:i}" | sed 's/_$//')"
      if __hhs_has "${joined}"; then
        "${joined}" "${args[@]:i}"  # Invoke the matched command with remaining arguments
        exit $?
      fi
  done

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

  local fn_line plg_funcs=() plg_name

  IFS=$'\n'
  while read -r plugin; do
    while read -r fnc; do
      fn_line="${fnc##function }"
      fn_line="${fn_line%\(\) \{}"
      plg_funcs+=("${fn_line}")
    done < <(grep '^function .*()' <"${plugin}")
    if ! validate_plugin "${plg_funcs[@]}"; then
      INVALID+=("$(basename "${plugin}")")
    else
      plg_name=$(basename "${plugin%.*}")
      PLUGINS+=("${plg_name}")
      PLUGINS_LIST+=("${plugin}")
    fi
  done < <(find "${PLUGINS_DIR}" -maxdepth 2 -type f -iname "*.${HHS_MY_SHELL}")
  IFS="${OLDIFS}"

  return 0
}

# @purpose: Read all internal functions and make them available to use
function register_functions() {

  local fn_line

  IFS=$'\n'
  while read -r fnc_file; do
    source "${fnc_file}"
    while read -r fnc; do
      fn_line="${fnc##function }"
      fn_line="${fn_line%\(\) \{}"
      HHS_APP_FUNCTIONS+=("${fn_line}")
    done < <(grep '^function .*()' <"${fnc_file}")
    # Register the functions to be unset when program quits
    UNSETS+=("${HHS_APP_FUNCTIONS[@]}")
  done < <(find "${FUNCTIONS_DIR}" -maxdepth 1 -type f -name '*.bash')
  IFS="${OLDIFS}"

  return 0
}

# @purpose: Invoke the plugin command
function invoke_plugin() {

  local plg_cmd ret

  has_plugin "${1}" || command_hint "Plugin/Function not found: \"${1}\"" "${1}"
  for idx in "${!PLUGINS[@]}"; do
    if [[ "${PLUGINS[idx]}" == "${1}" ]]; then
      [[ -s "${PLUGINS_LIST[idx]}" ]] || quit 1
      source "${PLUGINS_LIST[idx]}"
      shift
      plg_cmd="${1:-execute}"
      has_command "${plg_cmd}" || command_hint  "Command not available: ${plg_cmd}"
      shift
      ${plg_cmd} "${@}"  # Execute the specified plugin
      ret=${?}
      cleanup
      exit ${ret}
    else
      [[ $((idx + 1)) -eq ${#PLUGINS[@]} ]] && quit 255
    fi
  done
  ret=${?}
  [[ ${ret} -eq 255 ]] && command_hint "Plugin/Function not found: \"${1}\"" "${1}"

  return ${ret}
}

# ------------------------------------------
# Local functions

# Functions MUST start with 'function' keyword and
# MUST quit <exit_code> with the proper exit code

# @purpose: Get the description of a function/plug-in or alias from `function' line.
# @param $1 [Req] : The function definition line.
function get_desc() {

  local path filename line_num re

  path=$(awk -F ':function' '{print $1}'  <<<"${1}")
  filename=$(awk -F '.bash:' '{print $1}'  <<<"${path}")
  line_num=$(awk -F '.bash:' '{print $2}'  <<<"${path}")
  line_num=${line_num// /}
  re='^ *(# @(function|purpose|alias):) '

  for i in $(seq "${line_num}" -1 1); do
    line=$(sed -n "${i}p" "${filename}.bash")
    if [[ ${line} =~ ${re} ]]; then
      desc="${line//${BASH_REMATCH[1]}/}"
      desc=$(echo "${desc}" | awk '{$1=$1};1')
      [[ $line =~ $re ]] && echo "${desc}" && break
    fi
  done
}

# @purpose: Search for all hhs-functions and make them available to use.
# @param $1..$N [Req] : The directories to search from.
function search_hhs_functions() {

  local all_hhs_fn=() filename fn_name desc

  IFS=$'\n' read -r -d '' -a all_hhs_fn < \
    <(grep -nR "^\( *function *__hhs_\)" "${@}" | sed -E 's/: +/:/' | awk 'NR != 0 {print $1" "$2}' | sort | uniq)
  for fn_line in "${all_hhs_fn[@]}"; do
    filename=$(basename "${fn_line}" | awk -F ':function ' '{print $1}')
    filename=$(printf '%-35.35s' "${filename}")
    fn_name=$(awk -F ':function ' '{print $2}' <<<"${fn_line}")
    fn_name=$(printf '%-35.35s' "${fn_name//\(\)/}")
    desc=$(get_desc "${fn_line}")
    HHS_FUNCTIONS+=("${BLUE}${filename// /.} ${GREEN}=> ${NC}${fn_name// /.} : ${YELLOW}${desc}")
  done
  IFS="${OLDIFS}"

  return 0
}

# @purpose: Get a list, display it in columns according to the terminal width.
# @param: $1 [Req] : The list title
# @param $2..$N [Req] : The array list
function display_list() {
    local title="$1" items columns max_width num_columns

    shift
    items=("$@")
    columns=$(tput cols)  # Get terminal width

    # Remove '__hhs_' prefix and replace '_' with ' ' in each item
    for i in "${!items[@]}"; do
        items[$i]="${items[$i]//__hhs_/}"   # Remove prefix
        items[$i]="${items[$i]//_/ }"       # Replace underscores with spaces
    done

    # Calculate max item length + padding
    max_width=$(printf "%s\n" "${items[@]}" | awk '{ if (length > max) max = length } END { print max + 2 }')

    # Determine number of columns that can fit in the terminal
    num_columns=$(((columns / (max_width + 5) - 1)))
    num_columns=$((num_columns > 0 ? num_columns : 1))  # Ensure at least one column

    echo -e "${ORANGE}${title}${NC}"

    # Print each item with its index in columns
    printf "%s\n" "${items[@]}" | awk -v cols="${num_columns}" -v width="${max_width}" '
    {
        printf "\033[33m%4d\033[m. \033[34m%-*s\033[m", NR, width, $0  # Print index followed by item
        if (NR % cols == 0) print ""  # Newline after every full row
    }
    END {
        if (NR % cols != 0) print ""  # Ensure proper formatting for partial rows
    }
    '
}

# @purpose: Display an error message and suggest similar commands based on partial user input.
# @param $1 [Req]: The error message to display.
# @param $2 [Req]: The partial command the user entered.
function command_hint() {
    local error_message="$1" user_input="$2" commands matches

    commands=(${PLUGINS[@]} ${HHS_APP_FUNCTIONS[@]} $(compgen -c __hhs))
    matches=()

    # Find commands that contain the user input as a substring
    for cmd in "${commands[@]}"; do
        if [[ "$cmd" == *"${user_input}"* ]]; then
            matches+=("${cmd}")
        fi
    done

    # Display error message and matching commands or an appropriate message if none found
    __hhs_errcho "${error_message}\n"

    if (( ${#matches[@]} > 0 )); then
        echo -e "${YELLOW}Did you mean one of these commands?${NC}"
        for match in "${matches[@]}"; do
            echo "  - ${BLUE}${match}${NC}"
        done
    else
      echo -e "${ORANGE}> Type 'hhs list' to find out options.${NC}"
    fi

    quit 1  # Exit with an error
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
        echo -e "${HHS_HIGHLIGHT_COLOR}  HomeSetup Version: ${WHITE}${HHS_VERSION}${NC}"
        echo -e "${HHS_HIGHLIGHT_COLOR}Installation Prefix: ${WHITE}${HHS_HOME}${NC}"
        echo -e "${HHS_HIGHLIGHT_COLOR}    HomeSetup Files: ${WHITE}${HHS_DIR}${NC}"
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

  # Execute a cleanup after the application has exited.
  trap cleanup_plugins EXIT

  # Check and invoke any matching '__hhs' function
  invoke_hhs_function "${@}"

  parse_args "${@}"
  register_functions
  register_plugins

  fn_name="${1//help/list}"

  if has_function "${fn_name}"; then
    shift
    ${fn_name} "${@}"  # Invoke internal function
    quit $?
  fi

  [[ ${#INVALID[@]} -gt 0 ]] && quit 1 "Invalid plugins found: [${RED}${INVALID[*]}${NC}]"

  invoke_plugin "${@}" || quit 2

  quit 255 "${RED}Failed to invoke hhs command: ${*} ${NC}"
}

source "${HHS_DIR}/bin/app-commons.bash"

main "${@}"
quit 1
