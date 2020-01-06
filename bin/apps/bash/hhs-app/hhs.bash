#!/usr/bin/env bash

#  Script: hhs
# Purpose: HomeSetup application manager
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
# License: Please refer to <http://unlicense.org/>

# Functions to be unset after quit
UNSETS+=('main' 'load_plugins' 'validate_plugin')

# Usage message
USAGE="
Usage: ${APP_NAME} <arg_name> [options]
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

# Load plugin list
PLUGIN_LIST=()

# List of required functions a plugin must have
PLUGIN_FNCS=('usage' 'version' 'execute')

# List of valid plugins
PLUGINS=()

# TODO: Comment it
validate_plugin() {
  local i=0 j=0 fncs=("$@")
  while [ "$i" -lt "${#PLUGIN_FNCS[@]}" ]; do
    if [ "${fncs[j]}" = "${PLUGIN_FNCS[i]}" ]; then
      i=$((i + 1))
      j=0
      [ $i = ${#PLUGIN_FNCS[@]} ] && return 0
    else
      j=$((j + 1))
      [ $j = ${#fncs[@]} ] && return 1
    fi
  done

  return 1
}

# TODO: Comment it
load_plugins() {
  while IFS='' read -r line; do 
    PLUGIN_LIST+=("$line"); 
  done < <(find "${HHS_HOME}"/bin/apps/bash/hhs-app/plugins -maxdepth 1 -name "*-plugin.bash")
  # Open a new subshell, so, the function names won't hit
  IFS=$'\n'
  for plugin in "${PLUGIN_LIST[@]}"; do
    local plg_fns=()
    while IFS= read -r fnc; do
      f_name="${fnc##function }"
      f_name="${f_name%\(\) \{}"
      plg_fns+=("${f_name}")
    done < <(grep '^function .*()' <"${plugin}")
    if ! validate_plugin "${plg_fns[@]}"; then
      echo "${RED}### Invalid plugin: ${plugin} ${NC}"
    else
      PLUGINS+=("$(basename "${plugin%-*}")")
    fi
  done
  IFS=$"$HHS_RESET_IFS"
}

main() {
  load_plugins
  echo "Plug-ins loaded: ${GREEN}${PLUGINS[*]} ${NC}"
}

main "${@}"
