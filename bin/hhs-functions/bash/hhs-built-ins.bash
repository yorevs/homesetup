#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Generate a random number int the range <min> <max> (all limits included).
# @param $1 [Req] : The minimum range of the number.
# @param $2 [Req] : The maximum range of the number.
function __hhs_random() {

  if [[ $# -ne 2 ]]; then
    echo "usage: ${FUNCNAME[0]} <min> <max>"
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
    __hhs_errcho "${FUNCNAME[0]}" "Unable to open \"${filename}\". No suitable application found !"
  fi

  return 1
}

# @function: Create and/or open a file using the default editor.
# @param $1 [Req] : The file path.
function __hhs_edit() {

  local filename="$1" editor="${EDITOR:-vi}"

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} <file_path>"
    return 1
  else
    [[ -s "${filename}" ]] || touch "${filename}" > /dev/null 2>&1
    [[ -s "${filename}" ]] || __hhs_errcho "${FUNCNAME[0]}" "Unable to create file \"${filename}\""

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
      __hhs_errcho "${FUNCNAME[0]}" "Unable to find a suitable editor for the file \"${filename}\" !"
    fi
  fi

  return 1
}

# shellcheck disable=SC2030,SC2031
# @function: Display information about the given command.
# @param $1 [Req] : The command to check.
function __hhs_about() {

  local cmd type_ret=() re_alias re_function re_command recurse="${2}"
  re_alias="(.*) is aliased to \`(.*)'"
  re_function="(.*) is a function"
  re_command="(.*) is (.*)"

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} <command>"
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
        printf "${GREEN}%14s${BLUE} %s${WHITE} => %s ${NC}\n" "Aliased:" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
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
        printf "${GREEN}%14s${BLUE} %s${WHITE} => \n" "Function:" "${BASH_REMATCH[1]}"
        printf "%s\n" "${type_ret[@]:2}" | nl
      elif [[ ${type_ret[0]} =~ ${re_command} ]]; then
        printf "${GREEN}%14s${BLUE} %s${WHITE} => %s ${NC}\n" "Command:" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        brew_cmd="$(brew --prefix "${cmd}" 2>/dev/null)"
        [[ -n "${brew_cmd}" ]] && printf "${GREEN}%14s${BLUE} %s${WHITE} => %s\n" "Brew:" "prefix" "${brew_cmd}"
      fi
    fi
    [[ ${recurse} -eq 0 ]] && echo -e "${NC}"
  fi

  return 0
}

# @function: Display all alias definitions using filter.
# @param $1 [Opt] : If -e is present, edit the .aliasdef file, otherwise a case-insensitive filter to be used when listing.
function __hhs_defs() {

  local pad pad_len filter name value columns ret_val=0 next

  HHS_ALIASDEF_FILE="${HHS_DIR}/.aliasdef"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [regex_filters]"
    return 1
  else
    if [[ "$1" == '-e' ]]; then
      __hhs_edit "${HHS_ALIASDEF_FILE}"
      ret_val=$?
    else
      pad=$(printf '%0.1s' "."{1..30})
      pad_len=26
      columns="$(($(tput cols) - pad_len - 10))"
      filter="$*"
      filter=${filter// /\|}
      [[ -z "${filter}" ]] && filter=".*"
      echo -e "\n${YELLOW}Listing all alias definitions matching [${filter}]:\n"
      IFS=$'\n'
      for next in $(grep -i '^ *__hhs_alias' "${HHS_ALIASDEF_FILE}" | sed 's/^ *//g' | sort | uniq); do
        name=${next%%=*}
        name="$(trim <<< "${name}" | awk '{print $2}')"
        value=${next#*=}
        value=${value//[\'\"]/}
        if [[ ${name} =~ ${filter} ]]; then
          echo -en "${HHS_HIGHLIGHT_COLOR}${name//__hhs_alias/}${NC} "
          printf '%*.*s' 0 $((pad_len - ${#name})) "${pad}"
          echo -en "${GREEN} defined as => ${NC}"
          echo -n "${value:0:${columns}}"
          [[ ${#value} -ge ${columns} ]] && echo -n "..."
          echo "${NC}"
        fi
      done
      IFS="${OLDIFS}"
      echo ' '
    fi
  fi

  return ${ret_val}
}

# @function: Display the current dir (pwd) and remote repo url, if it applies.
# @param $1 [Req] : The command to get help.
function __hhs_where_am_i() {
  local pad_len=24 last_commit sha commit_msg repo_url branch_name metrics

  echo ' '
  echo "${YELLOW}You are here:${NC}"
  echo ' '

  [[ ${HHS_PYTHON_VENV_ACTIVE:-0} -eq 1 ]] &&
    printf "${GREEN}%${pad_len}s ${CYAN}%s ${WHITE}%s\n${NC}" "Virtual Environment:" "$(python -V)" "=> ${HHS_VENV_PATH}"
  printf "${GREEN}%${pad_len}s ${WHITE}%s\n${NC}" "Current directory:" "$(pwd -LP)"

  if __hhs_has git && git rev-parse --is-inside-work-tree &> /dev/null; then
    repo_url="$(git remote -v | head -n 1 | awk '{print $2}')"
    printf "${GREEN}%${pad_len}s ${WHITE}%s\n${NC}" "Remote repository:" "${repo_url}"
    last_commit=$(git log --oneline -n 1)
    sha="$(echo "${last_commit}" | awk '{print $1}')"
    commit_msg=$(echo "${last_commit}" | cut -d' ' -f2-)
    branch_name=$(git rev-parse --abbrev-ref HEAD)
    printf "${GREEN}%${pad_len}s ${CYAN}%${#branch_name}s ${WHITE}%s\n${NC}" "Last commit sha:" "${sha}" "${commit_msg}"
    printf "${GREEN}%${pad_len}s ${CYAN}%${#branch_name}s${NC}" "Branch:" "${branch_name} "
    metrics=$(git diff --shortstat)
    [[ -n "${metrics}" ]] && echo -e "${WHITE}${metrics}${NC}"
    echo ''
  fi

  return 0
}
