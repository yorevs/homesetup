#!/usr/bin/env bash

#  Script: hhs-dirs.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Change the current working directory to a specific Folder.
# @param $1 [Opt] : [-L|-P] wheather to follow (-L) or not (-P) symbolic links.
# @param $2 [Opt] : The directory to change. If not provided, default DIR is the value of the HOME variable.
function __hhs_change_dir() {

  local flags path

  while [[ '-L' == "${1}" || '-P' == "${1}" ]]; do
    flags="${flags} ${1}" && shift
  done

  path="${1:-$(pwd)}"

  if [[ -z "${1}" ]]; then
    path="${HOME}"
  elif [[ '..' == "${1}" ]]; then
    path='..'
  elif [[ '.' == "${1}" ]]; then
    path=$(command pwd)
  elif [[ '-' == "${1}" ]]; then
    path="${OLDPWD}"
  elif [[ -d "${1}" ]]; then
    path="${1}"
  elif [[ -e "${1}" ]]; then
    path="$(dirname "${1}")"
  fi

  path="${path//\~/${HOME}}"

  [[ ! -d "${path}" ]] && __hhs_errcho "${FUNCNAME[0]}: Directory \"${path}\" was not found ! ${NC}" && return 1

  # shellcheck disable=SC2086
  command cd ${flags} "${path}" || return 1
  command pushd -n "$(pwd)" &>/dev/null

  return 0
}

# @function: Change back the current working directory by N directories.
# @param $1 [Opt] : The amount of directories to jump back.
function __hhs_changeback_ndirs() {

  local x last_pwd

  last_pwd=$(pwd)

  if [[ -z "$1" ]]; then
    command cd ..
  elif [[ -n "$1" ]]; then
    for x in $(seq 1 "$1"); do
      command cd .. || return 1
    done
    echo "${GREEN}Changed directory backwards by ${x} time(s) and landed at: ${WHITE}\"$(pwd)\"${NC}"
    [[ -d "${last_pwd}" ]] && export OLDPWD="${last_pwd}"
  fi

  return 0
}

# @function: Display the list of currently remembered directories.
function __hhs_dirs() {

  local mselect_file sel_index path results=() len ret_val=0

  # If any argument is passed, use the old style dirs
  if [[ $# -gt 0 ]]; then
    command dirs "${@}"
    return $?
  fi

  IFS=$'\n' read -r -d '\n' -a results <<<"$(dirs -p -l | sort | uniq)"
  len=${#results[@]}

  if [[ ${len} -eq 0 ]]; then
    echo "${ORANGE}No currently remembered directories available yet \"${HHS_SAVED_DIRS_FILE}\" !${NC}"
  elif [[ ${len} -eq 1 ]]; then
    echo "${results[*]}"
  else
    clear
    echo "${YELLOW}@@ Listing currently remembered directories (${len}) found. Please choose one to cd into:"
    echo "-------------------------------------------------------------"
    echo -en "${NC}"
    mselect_file=$(mktemp)
    if __hhs_mselect "${mselect_file}" "${results[@]}"; then
      sel_index=$(grep . "${mselect_file}")
      path="${results[$sel_index]}"
      [[ ! -d "${path}" ]] && __hhs_errcho "${FUNCNAME[0]}: Directory \"${path}\" was not found !" && ret_val=1
    else
      ret_val=1
    fi
  fi

  [[ ${ret_val} -eq 0 ]] && command cd "${path}"

  return ${ret_val}
}

# @function: List all directories recursively (Nth level depth) as a tree.
# @param $1 [Opt] : The root directory to list from.
# @param $2 [Opt] : The max level depth to walk into.
function __hhs_list_tree() {

  if __hhs_has "tree"; then
    if [[ -n "$1" && -n "$2" ]]; then
      tree "$1" -L "$2"
    elif [[ -n "$1" && -z "$2" ]]; then
      tree "$1"
    else
      tree '.'
    fi
  else
    command ls -Rl
  fi

  return $?
}

# @function: Save the one directory to be loaded by load.
# @param $1 [Opt] : The directory path to save.
# @param $2 [Opt] : The alias to access the directory saved.
function __hhs_save_dir() {

  local dir dir_alias all_dirs=()

  HHS_SAVED_DIRS_FILE=${HHS_SAVED_DIRS_FILE:-$HHS_DIR/.saved_dirs}
  touch "${HHS_SAVED_DIRS_FILE}"

  if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] | [dir_to_save] [dir_alias]"
    echo ''
    echo 'Options: '
    echo "    -e : Edit the saved dirs file."
    echo "    -r : Remove saved dir."
    return 1
  else

    dir_alias=$(echo -en "${2:-$1}" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')

    if [[ "$1" == "-e" ]]; then
      edit "${HHS_SAVED_DIRS_FILE}"
      return $?
    elif [[ "$1" == "-r" && -n "$2" ]]; then
      # Remove the previously saved directory aliased
      if grep -q "$dir_alias" "${HHS_SAVED_DIRS_FILE}"; then
        echo "${YELLOW}Directory removed: ${WHITE}\"$dir_alias\" ${NC}"
        return 0
      fi
      ised -e "s#(^$dir_alias=.*)*##g" -e '/^\s*$/d' "${HHS_SAVED_DIRS_FILE}"
    elif [[ -n "$2" ]]; then
      dir="$1"
      # If the path is not absolute, append the current directory to it.
      if [[ -z "${dir}" || "${dir}" == "." ]]; then dir=${dir//./$(pwd)}; fi
      if [[ -d "${dir}" && ! "${dir}" =~ ^/ ]]; then dir="$(pwd)/${dir}"; fi
      if [[ -n "${dir}" && "${dir}" == ".." ]]; then dir=${dir//../$(pwd)}; fi
      if [[ -n "${dir}" && "${dir}" == "-" ]]; then dir=${dir//-/$OLDPWD}; fi
      if [[ -n "${dir}" && ! -d "${dir}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}: Directory \"${dir}\" does not exist !"
        return 1
      fi
      # Remove the old saved directory aliased
      ised -e "s#(^${dir_alias}=.*)*##g" -e '/^\s*$/d' "${HHS_SAVED_DIRS_FILE}"
      IFS=$'\n' read -d '' -r -a all_dirs <"${HHS_SAVED_DIRS_FILE}"
      all_dirs+=("${dir_alias}=${dir}")
      printf "%s\n" "${all_dirs[@]}" >"${HHS_SAVED_DIRS_FILE}"
      sort "${HHS_SAVED_DIRS_FILE}" -o "${HHS_SAVED_DIRS_FILE}"
      if grep -q "$dir_alias" "${HHS_SAVED_DIRS_FILE}"; then
        echo "${GREEN}Directory saved: ${WHITE}\"${dir}\" as ${HHS_HIGHLIGHT_COLOR}$dir_alias ${NC}"
        return 0
      fi
    else
      __hhs_errcho "${FUNCNAME[0]}: Invalid alias \"${2}\" !"
      return 1
    fi
  fi

  return 1
}

# shellcheck disable=SC2059,SC2181,SC2046
# @function: `Pushd' into a saved directory issued by save.
# @param $1 [Opt] : The alias to access the directory saved.
function __hhs_load_dir() {

  local dir_alias all_dirs=() dir pad pad_len mselect_file sel_index

  HHS_SAVED_DIRS_FILE=${HHS_SAVED_DIRS_FILE:-$HHS_DIR/.saved_dirs}
  touch "${HHS_SAVED_DIRS_FILE}"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [-l] | [dir_alias]"
    echo ''
    echo 'Options: '
    echo '    [dir_alias] : Change to the directory saved from the alias provided.'
    echo '             -l : List all saved dirs.'
    echo ''
    echo '  Notes: '
    echo '    MSelect directory : When no arguments are provided.'
    return 1
  fi

  IFS=$'\n' read -d '' -r -a all_dirs <"${HHS_SAVED_DIRS_FILE}"

  if [ ${#all_dirs[@]} -ne 0 ]; then

    case "$1" in
    -l)
      pad=$(printf '%0.1s' "."{1..60})
      pad_len=40
      echo ' '
      echo "${YELLOW}Available directories (${#all_dirs[@]}) saved:"
      echo ' '
      IFS=$'\n'
      for next in "${all_dirs[@]}"; do
        dir_alias=$(echo -en "${next}" | awk -F '=' '{ print $1 }')
        dir=$(echo -en "${next}" | awk -F '=' '{ print $2 }')
        printf "${HHS_HIGHLIGHT_COLOR}${dir_alias}"
        printf '%*.*s' 0 $((pad_len - ${#dir_alias})) "${pad}"
        echo -e "${YELLOW} was saved as ${WHITE}'${dir}'"
      done
      IFS="${RESET_IFS}"
      echo "${NC}"
      return 0
      ;;
    $'')
      if [[ ${#all_dirs[@]} -ne 0 ]]; then
        clear
        echo "${YELLOW}Available saved directories (${#all_dirs[@]}):"
        echo -en "${WHITE}"
        mselect_file=$(mktemp)
        if __hhs_mselect "${mselect_file}" "${all_dirs[@]}"; then
          sel_index=$(grep . "${mselect_file}")
          dir_alias="${all_dirs[$sel_index]%=*}"
          dir="${all_dirs[$sel_index]##*=}"
        else
          return 1
        fi
      else
        echo "${ORANGE}No directories available yet !${NC}"
      fi
      ;;
    [a-zA-Z0-9_]*)
      dir_alias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      dir=$(grep "^${dir_alias}=" "${HHS_SAVED_DIRS_FILE}" | awk -F '=' '{ print $2 }')
      ;;
    *)
      __hhs_errcho "${FUNCNAME[0]}: Invalid arguments: \"$1\""
      return 1
      ;;
    esac

    if [[ -z "${dir}" || ! -d "${dir}" ]]; then
      __hhs_errcho "${FUNCNAME[0]}: Directory aliased by \"$dir_alias\" was not found !"
      return 1
    else
      pushd "${dir}" &>/dev/null || return 1
      echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"
    fi

  else
    echo "${ORANGE}No saved directories available yet \"${HHS_SAVED_DIRS_FILE}\" !${NC}"
  fi

  [[ -f "${mselect_file}" ]] && command rm -f "${mselect_file}"
  echo ''

  return 0
}

# @function: Search and `pushd' into the first match of the specified directory name.
# @param $1 [Req] : The base search path.
# @param $1 [Req] : The directory name to go.
function __hhs_go_dir() {

  local dir len mselect_file results=()

  if [[ "$#" -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [search_path] <dir_name>"
    return 1
  elif [[ -d "$1" ]]; then
    pushd "$1" &>/dev/null && echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}" || return 1
  else
    local searchPath name sel_index
    [[ -n "$2" ]] && searchPath="$1" || searchPath="$(pwd)"
    [[ -n "$2" ]] && name="$(basename "$2")" || name="$(basename "$1")"
    IFS=$'\n' read -d '' -r -a results <<<"$(find -L "${searchPath%/}" -type d -iname "*""$name" 2>/dev/null)"
    len=${#results[@]}
    # If no directory is found under the specified name
    if [[ ${len} -eq 0 ]]; then
      echo "${YELLOW}No matches for directory with name \"$name\" found !${NC}"
      return 1
    # If there was only one directory found, CD into it
    elif [[ ${len} -eq 1 ]]; then
      dir=${results[0]}
    # If multiple directories were found with the same name, query the user
    else
      clear
      echo "${YELLOW}@@ Multiple directories (${len}) found. Please choose one to go into:"
      echo "Base dir: $searchPath"
      echo "-------------------------------------------------------------"
      echo -en "${NC}"
      mselect_file=$(mktemp)
      if __hhs_mselect "${mselect_file}" "${results[@]//$searchPath\//}"; then
        sel_index=$(grep . "${mselect_file}")
        dir=${results[$sel_index]}
      else
        return 1
      fi
    fi
    [[ -n "${dir}" && -d "${dir}" ]] && pushd "${dir}" &>/dev/null && echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}" || return 1
  fi

  [[ -f "${mselect_file}" ]] && command rm -f "${mselect_file}"
  echo ''

  return 0
}

# @function: Create all folders using a dot notation path and immediately change into it.
# @param $1 [Req] : The directory tree to create, using slash (/) or dot (.) notation path.
function __hhs_mkcd() {
  if [[ -n "$1" && ! -d "$1" ]]; then
    dir="${1//.//}"
    mkdir -p "${dir}" || return 1
    last_pwd=$(pwd)
    for d in ${dir//\// }; do
      cd "$d" || return 1
    done
    export OLDPWD=${last_pwd}
    echo "${GREEN}${dir}${NC}"
  else
    echo "Usage: ${FUNCNAME[0]} <dirtree | package>"
    echo ''
    echo "E.g:. ${FUNCNAME[0]} dir1/dir2/dir3 (dirtree)"
    echo "E.g:. ${FUNCNAME[0]} dir1.dir2.dir3 (FQDN)"
  fi

  return 0
}
