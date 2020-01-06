#!/usr/bin/env bash

#  Script: hhs
# Purpose: HomeSetup application manager
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
# License: Please refer to <http://unlicense.org/>

# Functions to be unset after quit
UNSETS+=('main' 'parse_args' 'register_plugins' 'validate_plugin')

# shellcheck disable=SC2034
# Program version
VERSION=0.9.1

# shellcheck disable=SC2034
# Usage message
USAGE="
Usage: ${APP_NAME} <command> <command_args>

    HomeSetup application manager

    # TODO: App. DESCRIPTION.

    Options:
      -A | --Along            : TODO: Description about the option -A
      -B | --Blong  <ARG_1>   : TODO: Description about the option -B

    Arguments:
      ARG_1   : TODO: Description about the argument
    
    Exit Status:
      (0) Success 
      (1) Failure due to missing/wrong client input or similar issues
      (2) Failure due to program execution failures
  
  Notes: TODO: Program NOTES
"

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# List of required functions a plugin must have
PLUGINS_FNCS=('help' 'getver' 'cleanup' 'execute')

# List of valid plugins
PLUGINS_LIST=()

# List plugin commands
PLUGINS=()

# TODO: Comment it
has_plugin() {

  if [ -n "${1}" ] && [ "${#PLUGINS[@]}" -gt 0 ] && [[ ${PLUGINS[*]} =~ ${1} ]]; then
    return 0
  fi

  return 1
}

# TODO: Comment it
validate_plugin() {

  local i=0 j=0 f_fncs=("$@")

  while [ "$i" -lt "${#PLUGINS_FNCS[@]}" ]; do
    if [ "${f_fncs[j]}" = "${PLUGINS_FNCS[i]}" ]; then
      i=$((i + 1))
      j=0
      [ $i = ${#PLUGINS_FNCS[@]} ] && return 0
    else
      j=$((j + 1))
      [ $j = ${#f_fncs[@]} ] && return 1
    fi
  done

  return 1
}

# TODO: Comment it
register_plugins() {

  while IFS='' read -r plugin; do
    local plg_fns=()
    while IFS= read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      plg_fns+=("${f_name}")
    done < <(grep '^function .*()' <"${plugin}")
    if ! validate_plugin "${plg_fns[@]}"; then
      INVALID+=("$(basename "${plugin}")")
    else
      plg_name=$(basename "${plugin%-*}")
      PLUGINS+=("${plg_name}")
      PLUGINS_LIST+=("${plugin}")
    fi
  done < <(find "${HHS_HOME}"/bin/apps/bash/hhs-app/plugins -maxdepth 1 -name "*-plugin.bash")
}

# TODO: Comment it
parse_args() {

  # If no argument is passed, just enter HomeSetup directory
  if [[ $# -eq 0 ]]; then
    usage 0
  fi

  # Loop through the command line options.
  # Short opts: -<C>, Long opts: --<Word>
  UNUSED_ARGS=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      usage 0
      ;;
    -v | --version)
      version
      ;;

    *)
      UNUSED_ARGS+=("$1")
      ;;
    esac
    shift
  done
}

# shellcheck disable=SC1090
# TODO: Comment it
invoke_command() {

  has_plugin "${1}" || quit 1 "Plugin not found: ${1}"
  (
    for idx in "${!PLUGINS[@]}"; do
      if [[ "${PLUGINS[idx]}" = "${1}" ]]; then
          [ -s "${PLUGINS_LIST[i]}" ] && \. "${PLUGINS_LIST[i]}"
          shift
          plg_fnc="${1:-execute}"
          shift
          ${plg_fnc} "${@}"
          ret=$?
          cleanup
          exit $ret
      fi
    done
    exit 1
  )
  [[ ${?} -eq 0 ]] || quit 1 "Failed to execute command: ${1}"
}

# TODO: Comment it
main() {

  parse_args "${@}"
  register_plugins
  [[ ${#INVALID[@]} -gt 0 ]] && echo "[DEBUG] Invalid plugins registred: [${RED}${INVALID[*]}${NC}]"
  [[ ${#PLUGINS[@]} -gt 0 ]] && echo "[DEBUG] Plug-ins registered: [${GREEN}${PLUGINS[*]}${NC}]"
  invoke_command "${@}"
}

main "${@}"
