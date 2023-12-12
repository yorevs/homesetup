#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Generate a random number int the range <min> <max> (all limits included).
# @param $1 [Req] : The minimum range of the number.
# @param $2 [Req] : The maximum range of the number.
function __hhs_random() {

  if [[ $# -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <min> <max>"
    return 1
  else
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  fi

  return 0
}

# @function: Open a file or URL with the default program.
# @param $1 [Req] : The url or filename to open.
function __hhs_open() {

  local filename="$1"

  if __hhs_has open && \open "${filename}"; then
    return $?
  elif __hhs_has xdg-open && \xdg-open "${filename}"; then
    return $?
  elif __hhs_has vim && \vim "${filename}"; then
    return $?
  elif __hhs_has vi && \vi "${filename}"; then
    return $?
  else
    __hhs_errcho "${FUNCNAME[0]}: Unable to open \"${filename}\". No suitable application found !"
  fi

  return 1
}

# @function: Create and/or open a file using the default editor.
# @param $1 [Req] : The file path.
function __hhs_edit() {

  local filename="$1" editor="${EDITOR:-vi}"

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <file_path>"
    return 1
  else
    [[ -s "${filename}" ]] || touch "${filename}" > /dev/null 2>&1
    [[ -s "${filename}" ]] || __hhs_errcho "${FUNCNAME[0]}: Unable to create file \"${filename}\""

    if [[ -n "${editor}" ]] && __hhs_has "${editor}" && ${editor} "${filename}"; then
      return $?
    elif __hhs_has gedit && \gedit "${filename}"; then
      return $?
    elif __hhs_has emacs && \emacs "${filename}"; then
      return $?
    elif __hhs_has vim && \vim "${filename}"; then
      return $?
    elif __hhs_has vi && \vi "${filename}"; then
      return $?
    elif __hhs_has cat && \cat > "${filename}"; then
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: Unable to find a suitable editor for the file \"${filename}\" !"
    fi
  fi

  return 1
}

# shellcheck disable=SC2030,SC2031
# @function: Display information about the given command.
# @param $1 [Req] : The command to check.
function __hhs_about() {

  local cmd type_ret=() i=0 re_alias re_function re_command recurse="${2}"
  re_alias="(.*) is aliased to \`(.*)'"
  re_function="(.*) is a function"
  re_command="(.*) is (.*)"

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  elif [[ ${recurse} -gt 5 ]] || [[ ${recurse} =~ [^0-9]+ ]]; then
    return 1
  else
    [[ ${recurse} -eq 0 ]] && echo ''
    cmd=${1}
    IFS=$'\n'
    read -r -d '' -a type_ret < <(type "${cmd}" 2> /dev/null)
    IFS="${OLDIFS}"
    if [[ ${#type_ret[@]} -gt 0 ]]; then
      if [[ ${type_ret[0]} =~ ${re_alias} ]]; then
        printf "${GREEN}%12s${BLUE} %s${WHITE} => %s ${NC}\n" "Aliased:" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        # To avoid unalias the command, we do that in another subshell
        (
          IFS=$'\n'
          if [[ "${BASH_REMATCH[2]}" == *"__hhs_"* ]]; then
            ((recurse += 1))
            __hhs_about "${BASH_REMATCH[2]}" "${recurse}"
          else
            while unalias "${cmd}" 2> /dev/null; do
              ((recurse += 1))
              __hhs_about "${cmd}" "${recurse}"
            done
          fi
          IFS="${OLDIFS}"
        )
      elif [[ ${type_ret[0]} =~ ${re_function} ]]; then
        printf "${GREEN}%12s${BLUE} %s${WHITE} => \n" "Function:" "${BASH_REMATCH[1]}"
        for line in "${type_ret[@]:2}"; do
          printf "   %4d: %s\n" $((i += 1)) "${line}"
        done
      elif [[ ${type_ret[0]} =~ ${re_command} ]]; then
        printf "${GREEN}%12s${BLUE} %s${WHITE} => %s ${NC}\n" "Command:" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
      fi
    fi
    [[ ${recurse} -eq 0 ]] && echo -e "${NC}"
  fi

  return 0
}

# @function: Display a help for the given command.
# @param $1 [Req] : The command to get help.
function __hhs_help() {

  local cmd

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  else
    cmd="${1}"
    if ! ${cmd} --help 2> /dev/null; then
      if ! ${cmd} -h 2> /dev/null; then
        if ! ${cmd} help 2> /dev/null; then
          if ! ${cmd} /? 2> /dev/null; then
            __hhs_errcho "${RED}Help not available for ${cmd}"
          fi
        fi
        return 1
      fi
    fi
  fi

  return 0
}

# @function: Display the current working dir and remote repository if it applies.
# @param $1 [Req] : The command to get help.
function __hhs_where_am_i() {

  echo "${GREEN}Current directory: ${NC}$(pwd -LP)"
  if __hhs_has git && git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "${GREEN}Remote repository: ${NC}$(git remote -v | head -n 1 | awk '{print $2}')"
  fi
}

# @function: Display/Set/unset current Shell Options.
# @param $1 [Req] : Same as shopt, ref: https://ss64.com/bash/shopt.html
function __hhs_shopt() {

  local shell_options option filter

  filter=$(tr '[:lower:]' '[:upper:]' <<< "${1}")

  if [[ ${#} -eq 0 || ${filter} =~ ON|OFF ]]; then
    IFS=$'\n' read -r -d '' -a shell_options < <(\shopt | awk '{print $1"="$2}')
    IFS="${OLDIFS}"
    echo ' '
    echo "${YELLOW}Available shell options (${#shell_options[@]}):"
    echo ' '
    for option in "${shell_options[@]}"; do
      if [[ "${option#*=}" == 'on' ]] && [[ -z "${filter}" || "${filter}" == 'ON' ]]; then
        echo -e "  ${WHITE}${ON_ICN}  ${GREEN} ON${BLUE}\t${option%%=*}"
      elif [[ "${option#*=}" == 'off' ]] && [[ -z "${filter}" || "${filter}" == 'OFF' ]]; then
        echo -e "  ${WHITE}${OFF_ICN}  ${RED} OFF${BLUE}\t${option%%=*}"
      fi
    done
    echo "${NC}"
  else
    # shellcheck disable=2068
    \shopt ${@}
  fi

}
