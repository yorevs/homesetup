#!/usr/bin/env bash
# shellcheck disable=2094

#  Script: hhs-toml.bash
# Created: Nov 28, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Get the key's value from a toml file.
# @param $1 [Req] : The toml file read from.
# @param $2 [Req] : The key to get.
# @param $3 [Opt] : The group to get the key from (root if not provided).
function __hhs_toml_get() {

  local file="${1}" key="${2}" group="${3}" re_group re_key_pair group_match

  if [[ "${#}" -eq 0 || "${1}" == '-h' || "${1}" == '--help' ]]; then
    echo "Usage: __hhs_toml_get <file> <key> [group]"
    return 1
  fi

  if [[ -z "${file}" ]]; then
    __hhs_errcho "The file parameter must be provided."
    return 1
  elif [[ -z "${key}" ]]; then
    __hhs_errcho "The key parameter must be provided."
    return 1
  elif [[ ! -s "${file}" ]]; then
    __hhs_errcho "The file \"${file}\" does not exists or is empty."
    return 1
  fi

  re_group="^\[([a-zA-Z0-9_.]+)\] *"
  re_key_pair="^(${key}) *= *(.*)"

  while read -r line; do
    if [[ ${line} =~ ${re_key_pair} ]]; then
      if [[ -z "${group}" ]]; then
        echo "${BASH_REMATCH[1]}=${BASH_REMATCH[2]//[\"\']/}"
        return 0
      elif [[ -n "${group}" && -n "${group_match}" ]]; then
        echo "${BASH_REMATCH[1]}=${BASH_REMATCH[2]//[\"\']/}"
        return 0
      fi
    elif [[ ${line} =~ ${re_group} ]]; then
      if [[ "${BASH_REMATCH[1]}" == "${group}" ]]; then
        group_match="${BASH_REMATCH[1]}"
      fi
    fi
  done <"${file}"

  echo ''

  return 1
}

# @function: Set the key's value from a toml file.
# @param $1 [Req] : The toml file read from..
# @param $2 [Req] : The key to set on the form: key=value
# @param $3 [Opt] : The group to set the key from (root if not provided).
function __hhs_toml_set() {

  local file="${1}" key="${2%%=*}" value="${2#*=}" group="${3}"
  local re_group re_key_pair group_match

  if [[ "${#}" -eq 0 || "${1}" == '-h' || "${1}" == '--help' ]]; then
    echo "Usage: __hhs_toml_set <file> <key=value> [group]"
    return 1
  fi

  if [[ -z "${file}" ]]; then
    __hhs_errcho "The file parameter must be provided."
    return 1
  elif [[ -z "${key}" ]]; then
    __hhs_errcho "The key parameter must be provided."
    return 1
  elif [[ ! -s "${file}" ]]; then
    __hhs_errcho "The file \"${file}\" does not exists or is empty."
    return 1
  fi

  re_group="^\[([a-zA-Z0-9_.]+)\] *"
  re_key_pair="^(${key}) *= *(.*)?"

  if ! [[ ${2} =~ ${re_key_pair} ]]; then
    __hhs_errcho "The key/value parameter must be on the form of 'key=value', but it was '${2}'."
    return 1
  fi

  while read -r line; do
    if [[ ${line} =~ ${re_key_pair} ]]; then
      if [[ -z "${group}" ]]; then
        ised "s/${line}/${key} = ${value}/g" "${file}"
        return $?
      elif [[ -n "${group}" && -n "${group_match}" ]]; then
        ised "s/${line}/${key} = ${value}/g" "${file}"
        return $?
      fi
    elif [[ ${line} =~ ${re_group} ]]; then
      if [[ "${BASH_REMATCH[1]}" == "${group}" ]]; then
        group_match="${BASH_REMATCH[1]}"
      fi
    fi
  done <"${file}"

  return 1
}

# @function: Print all toml file groups (tables).
# @param $1 [Req] : The toml file read from.
function __hhs_toml_groups() {

  local file="${1}" re_group count=0

  if [[ "${#}" -eq 0 || "${1}" == '-h' || "${1}" == '--help' ]]; then
    echo "Usage: __hhs_toml_groups <file>"
    return 1
  fi

  if [[ -z "${file}" ]]; then
    __hhs_errcho "The file parameter must be provided."
    return 1
  elif [[ ! -s "${file}" ]]; then
    __hhs_errcho "The file \"${file}\" does not exists or is empty."
    return 1
  fi

  re_group="^\[([a-zA-Z0-9_.]+)\] *"
  while read -r line; do
    if [[ ${line} =~ ${re_group} ]]; then
      echo -e "${BASH_REMATCH[1]}"
      ((count += 1))
    fi
  done <"${file}"

  [[ $count -gt 0 ]] && return 0
  [[ $count -le 0 ]] && return 1
}

# @function: Print all toml file group keys (tables).
# @param $1 [Req] : The toml file read from.
# @param $2 [Opt] : The group to get the keys from (root if not provided).
function __hhs_toml_keys() {

  local file="${1}" group="${2}" re_group count=0 group_match

  if [[ "${#}" -eq 0 || "${1}" == '-h' || "${1}" == '--help' ]]; then
    echo "Usage: __hhs_toml_keys <file> [group]"
    return 1
  fi

  if [[ -z "${file}" ]]; then
    __hhs_errcho "The file parameter must be provided."
    return 1
  elif [[ ! -s "${file}" ]]; then
    __hhs_errcho "The file \"${file}\" does not exists or is empty."
    return 1
  fi

  re_group="^\[([a-zA-Z0-9_.]+)\] *"
  re_key_pair="^([a-zA-Z0-9_.]+) *= *(.*)"

  while read -r line; do
    if [[ -z "${group}" && ${line} =~ ${re_group} ]]; then
      break
    elif [[ -n "${group_match}" && ${line} =~ ${re_group} ]]; then
      break
    elif [[ ${line} =~ ${re_key_pair} ]]; then
      if [[ -z "${group}" ]]; then
        echo -e "${line}"
        ((count += 1))
      elif [[ -n "${group}" && -n "${group_match}" ]]; then
        echo -e "${line}"
        ((count += 1))
      fi
    elif [[ ${line} =~ ${re_group} ]]; then
      if [[ "${BASH_REMATCH[1]}" == "${group}" ]]; then
        group_match="${BASH_REMATCH[1]}"
      fi
    fi
  done <"${file}"

  [[ $count -gt 0 ]] && return 0
  [[ $count -le 0 ]] && return 1
}
