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
function __hhs_toml_get_key() {

  local file="${1}" key="${2}" group="${3:-.*}" re_group re_key_pair group_match

  if [[ -z "${file}" ]]; then
    echo "${RED}error: The file parameter must be provided.${NC}"
    return 1
  elif [[ -z "${key}" ]]; then
    echo "${RED}error: The key parameter must be provided.${NC}"
    return 1
  elif [[ ! -s "${file}" ]]; then
    echo "${RED}error: The file \"${file}\" does not exists or is empty.${NC}"
    return 1
  fi

  re_group="^\[(${group})\] *$"
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
      group_match="${BASH_REMATCH[1]}"
    fi
  done <"${file}"

  echo ''

  return 1
}

# @function: Set the key's value from a toml file.
# @param $1 [Req] : The toml file read from..
# @param $2 [Req] : The key to set on the form: key=value
# @param $3 [Opt] : The group to set the key from (root if not provided).
function __hhs_toml_set_key() {

  local file="${1}" key="${2%%=*}" value="${2#*=}" group="${3:-.*}"
  local aux re_group re_key_pair group_match ret_val=1

  if [[ -z "${file}" ]]; then
    echo "${RED}error: The file parameter must be provided${NC}"
    return 1
  elif [[ -z "${key}" ]]; then
    echo "${RED}error: The key parameter must be provided${NC}"
    return 1
  elif [[ ! -s "${file}" ]]; then
    echo "${RED}error: The file \"${file}\" does not exists or is empty${NC}"
    return 1
  fi

  re_group="^\[(${group})\] *$"
  re_key_pair="^(${key}) *= *(.*)"

  if ! [[ ${line} =~ ${re_key_pair} ]]; then
    echo "${RED}error: The key/value parameter must be on the form of 'key=value'${NC}"
    return 1
  fi

  aux=$(mktemp)

  while read -r line; do
    if [[ ${line} =~ ${re_key_pair} ]]; then
      if [[ -z "${group}" ]]; then
        \sed "s/${line}/${key} = ${value}/g" "${file}" >"${aux}"
        ret_val=0
      elif [[ -n "${group}" && -n "${group_match}" ]]; then
        \sed "s/${line}/${key} = ${value}/g" "${file}" >"${aux}"
        ret_val=0
      fi
    elif [[ ${line} =~ ${re_group} ]]; then
      group_match="${BASH_REMATCH[1]}"
    fi
  done <"${file}"

  [[ -s "${aux}" ]] && \mv -f "${aux}" "${file}"

  return $ret_val
}

# @function: Print all toml file groups (tables).
# @param $1 [Req] : The toml file read from.
function __hhs_toml_groups() {

  local file="${1}" re_group count=0

  if [[ -z "${file}" ]]; then
    echo "${RED}error: The file parameter must be provided.${NC}"
    return 1
  elif [[ ! -s "${file}" ]]; then
    echo "${RED}error: The file \"${file}\" does not exists or is empty.${NC}"
    return 1
  fi

  re_group="^\[([a-zA-Z0-9]+)\]"
  while read -r line; do
    if [[ ${line} =~ ${re_group} ]]; then
      echo -e "${BASH_REMATCH[1]}"
      ((count += 1))
    fi
  done <"${file}"

  [[ $count -gt 0 ]] && return 0
  [[ $count -le 0 ]] && return 1
}
