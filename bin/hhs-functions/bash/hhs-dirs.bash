#!/usr/bin/env bash

#  Script: hhs-dirs.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Change the current working directory to a specific Folder.
# @param $1 [Opt] : [-L|-P] whether to follow (-L) or not (-P) symbolic links.
# @param $2 [Opt] : The directory to change. If not provided, default DIR is the value of the HOME variable.
function __hhs_change_dir() {

  local flags path

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [-L|-P] [dirname]"
    echo ''
    echo '    Options: '
    echo '      -L    : Follow symbolic links.'
    echo "      -P    : Don't follow symbolic links."
    echo ''
    echo '  Notes: '
    echo "    - dirname: The directory to change. If not provided, default is the user's home directory"
    echo ''
    return 0
  fi

  while [[ '-L' == "${1}" || '-P' == "${1}" ]]; do
    flags="${flags} ${1}" && shift
  done

  path="${1:-$(pwd)}"

  if [[ -z "${1}" ]]; then
    path="${HOME}"
  elif [[ '..' == "${1}" ]]; then
    path='..'
  elif [[ '.' == "${1}" ]]; then
    path=$(\pwd)
  elif [[ '-' == "${1}" ]]; then
    path="${OLDPWD}"
  elif [[ -d "${1}" ]]; then
    path="${1}"
  elif [[ -e "${1}" ]]; then
    path="$(dirname "${1}")"
  fi

  path="${path//\~/${HOME}}"

  if [[ ! -d "${path}" ]]; then
    if ! __hhs_has 'z' || ! z "$path" &> /dev/null; then
      __hhs_errcho "${FUNCNAME[0]}" "Directory \"${path}\" was not found !"
    fi
  else
    # shellcheck disable=SC2086
    if
      \cd ${flags} "${path}" &> /dev/null \
        && \pushd -n "$(pwd)" &> /dev/null \
        && \dirs -p | uniq > "${HHS_DIR}/.last_dirs"
    then
      export CURPWD="${path}"
      return 0
    else
      __hhs_errcho "${FUNCNAME[0]}" "Unable to change to directory \"${path}\" !"
    fi
  fi

  \pushd -n "$(pwd)" &> /dev/null && \dirs -p | uniq > "${HHS_DIR}/.last_dirs"

  return 1
}

# @function: Change back the current working directory by N directories.
# @param $1 [Opt] : The amount of directories to change backwards. If not provided, default is one.
function __hhs_changeback_ndirs() {

  local x last_pwd

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [amount]"
    return 0
  fi

  last_pwd=$(pwd)

  if [[ -z "$1" ]]; then
    \cd ..
    echo "${GREEN}Changed current directory: ${WHITE}\"$(pwd)\"${NC}"
  elif [[ -n "$1" ]]; then
    for x in $(seq 1 "$1"); do
      \cd .. || return 1
    done
    echo "${GREEN}Changed directory backwards by ${x} time(s) and landed at: ${WHITE}\"$(pwd)\"${NC}"
    [[ -d "${last_pwd}" ]] && export OLDPWD="${last_pwd}" && export CURPWD="${last_pwd}"
  fi

  return 0
}

# @function: Display the list of currently remembered directories.
function __hhs_dirs() {

  local mselect_file sel_dir results=() len ret_val=0

  # If any argument is passed, use the old style dirs
  if [[ $# -gt 0 ]]; then
    \dirs "${@}"
    return $?
  fi

  read -r -d '\n' -a results <<< "$(dirs -p -l | sort | uniq)"
  len=${#results[@]}

  if [[ ${len} -eq 0 ]]; then
    echo "${YELLOW}No currently directories available yet in \"${HHS_SAVED_DIRS_FILE}\" !${NC}"
  elif [[ ${len} -eq 1 ]]; then
    echo "${results[*]}"
  else
    mselect_file=$(mktemp)
    if __hhs_mselect "${mselect_file}" "Please choose one directory to change into (${len}) found:" "${results[@]}"; then
      sel_dir=$(grep . "${mselect_file}")
      if [[ -n "${sel_dir}" ]]; then
        [[ ! -d "${sel_dir}" ]] && __hhs_errcho "${FUNCNAME[0]}" "Directory \"${sel_dir}\" was not found !" && ret_val=1
      else
        ret_val=1
      fi
    else
      ret_val=1
    fi
  fi

  echo ''
  [[ ${ret_val} -eq 0 ]] && \cd "${sel_dir}" || return 1

  return ${ret_val}
}

# @function: List all directories recursively (Nth level depth) as a tree.
# @param $1 [Opt] : The directory to list from.
# @param $2 [Opt] : The max level depth to walk into.
function __hhs_list_tree() {

  local dir="${1}" max_depth=${2}

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [dir] [max_depth]"
    return 0
  elif __hhs_has "tree"; then
    if [[ -n "${dir}" && -n "${max_depth}" ]]; then
      tree "${dir}" -L "${max_depth}"
    elif [[ -n "${dir}" && -z "${max_depth}" ]]; then
      tree "${dir}"
    else
      tree '.'
    fi
  elif __hhs_has "colorls"; then
    if [[ -n "${dir}" && -n "${max_depth}" ]]; then
      ls "${dir}" --tree="${max_depth}"
    elif [[ -n "${dir}" && -z "${max_depth}" ]]; then
      ls "${dir}" --tree
    else
      ls . --tree
    fi
  else
    \ls -Rl
  fi

  return $?
}

# @function: Save one directory path for future __hhs_load.
# @param $1 [Con] : The directory path to save or the alias to be removed.
# @param $2 [Con] : The alias to name the saved path.
function __hhs_save_dir() {

  local dir dir_alias all_dirs=() dirs=() ret_val=1

  HHS_SAVED_DIRS_FILE=${HHS_SAVED_DIRS_FILE:-$HHS_DIR/.saved_dirs}
  touch "${HHS_SAVED_DIRS_FILE}"

  if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} -e | [-r] <dir_alias> | <path> <dir_alias>"
    echo ''
    echo 'Options: '
    echo "    -e : Edit the saved dirs file."
    echo "    -r : Remove saved dir."
    echo "    -c : Cleanup directory paths that does not exist."
  else

    dir_alias=$(echo -en "${2:-$1}" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
    dir_alias=$(tr '[:punct:]' '_' <<< "${dir_alias}")

    if [[ "$1" == "-e" ]]; then
      __hhs_edit "${HHS_SAVED_DIRS_FILE}"
      return $?
    elif [[ "$1" == "-r" && -n "$2" ]]; then
      # Remove the previously saved directory aliased
      if grep -q "${dir_alias}" "${HHS_SAVED_DIRS_FILE}"; then
        ised -e "s#(^${dir_alias}=.*)*##g" -e '/^\s*$/d' "${HHS_SAVED_DIRS_FILE}"
        echo "${YELLOW}Directory aliased as ${HHS_HIGHLIGHT_COLOR}\"${dir_alias}\" ${YELLOW}was removed!${NC}"
        ret_val=0
      fi
    elif [[ "$1" == "-c" ]]; then
      read -d '' -r -a all_dirs < "${HHS_SAVED_DIRS_FILE}"
      for idx in $(seq 1 "${#all_dirs[@]}"); do
        dir=${all_dirs[idx - 1]}
        dir_alias=${dir%%=*}
        dir=${dir#*=}
        [[ -d "${dir}" ]] && dirs+=("${dir_alias}=${dir}")
        printf "%s\n" "${dirs[@]}" > "${HHS_SAVED_DIRS_FILE}"
      done
    elif [[ -n "$2" && -n "${dir_alias}" ]]; then
      dir="$1"
      # If the path is not absolute, append the current directory to it.
      if [[ -z "${dir}" || "${dir}" == "." ]]; then dir=${dir//./$(pwd)}; fi
      if [[ -d "${dir}" && ! "${dir}" =~ ^/ ]]; then dir="$(pwd)/${dir}"; fi
      if [[ -n "${dir}" && "${dir}" == ".." ]]; then dir=${dir//../$(pwd)}; fi
      if [[ -n "${dir}" && "${dir}" == "-" ]]; then dir=${dir//-/$OLDPWD}; fi
      if [[ -n "${dir}" && ! -d "${dir}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}" "Directory \"${dir}\" does not exist !"
        ret_val=0
      else
        # Remove the old saved directory aliased
        ised -e "s#(^${dir_alias}=.*)*##g" -e '/^\s*$/d' "${HHS_SAVED_DIRS_FILE}"
        read -d '' -r -a all_dirs < "${HHS_SAVED_DIRS_FILE}"
        all_dirs+=("${dir_alias}=${dir}")
        printf "%s\n" "${all_dirs[@]}" > "${HHS_SAVED_DIRS_FILE}"
        sort -u "${HHS_SAVED_DIRS_FILE}" -o "${HHS_SAVED_DIRS_FILE}"
        if grep -q "$dir_alias" "${HHS_SAVED_DIRS_FILE}"; then
          echo "${GREEN}Directory ${WHITE}\"${dir}\" ${GREEN}saved as ${HHS_HIGHLIGHT_COLOR}${dir_alias} ${NC}"
          ret_val=0
        fi
      fi
    else
      __hhs_errcho "${FUNCNAME[0]}" "Invalid alias \"${2}\" !"
    fi
  fi

  return ${ret_val}
}

# @function: Change the current working directory to pre-saved entry from __hhs_save.
# @param $1 [Opt] : The alias to access the directory saved.
function __hhs_load_dir() {

  local dir idx icn dir_alias all_dirs=() dir pad pad_len mselect_file sel_dir ret_val=1

  HHS_SAVED_DIRS_FILE=${HHS_SAVED_DIRS_FILE:-$HHS_DIR/.saved_dirs}
  touch "${HHS_SAVED_DIRS_FILE}"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [-l] | [dir_alias]"
    echo ''
    echo 'Options: '
    echo '    [dir_alias] : The alias to load the path from.'
    echo '             -l : If provided, list all saved dirs instead.'
    echo ''
    echo '  Notes: '
    echo '    MSelect default : If no arguments is provided, a menu with options will be displayed.'
  else

    read -d '' -r -a all_dirs < "${HHS_SAVED_DIRS_FILE}"

    if [ ${#all_dirs[@]} -ne 0 ]; then

      case "$1" in
        -l)
          pad=$(printf '%0.1s' "."{1..60})
          pad_len=41
          echo ' '
          echo "${YELLOW}Available directories (${#all_dirs[@]}) saved:"
          echo ' '
          for next in "${all_dirs[@]}"; do
            dir_alias=$(echo -en "${next}" | awk -F '=' '{ print $1 }')
            dir=$(echo -en "${next}" | awk -F '=' '{ print $2 }')
            printf "%s" "${HHS_HIGHLIGHT_COLOR}${dir_alias}${WHITE}"
            printf '%*.*s' 0 $((pad_len - ${#dir_alias})) "${pad}"
            echo -e "${GREEN} points to ${WHITE}'${dir}'"
          done
          echo "${NC}"
          ;;
        $'')
          if [[ ${#all_dirs[@]} -ne 0 ]]; then
            for idx in $(seq 1 "${#all_dirs[@]}"); do
              dir=${all_dirs[idx - 1]}
              dir=${dir#*=}
              [[ -d "${dir}" ]] && icn=" "
              [[ -d "${dir}" ]] || icn=" "
              all_dirs[idx - 1]="${icn} ${all_dirs[idx - 1]}"
            done
            mselect_file=$(mktemp)
            if __hhs_mselect "${mselect_file}" "Available saved directories (${#all_dirs[@]}):" "${all_dirs[@]}"; then
              sel_dir=$(grep . "${mselect_file}")
              dir_alias="${sel_dir%=*}"
              dir="${sel_dir##*=}"
              [[ -n "${dir}" ]] && ret_val=0
            fi
          else
            echo "${YELLOW}No directories available yet !${NC}"
          fi
          ;;
        [a-zA-Z0-9_]*)
          dir_alias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
          dir=$(grep "^${dir_alias}=" "${HHS_SAVED_DIRS_FILE}" | awk -F '=' '{ print $2 }')
          ret_val=0
          ;;
        *)
          __hhs_errcho "${FUNCNAME[0]}" "Invalid arguments: \"$1\""
          ;;
      esac

      [[ -f "${mselect_file}" ]] && \rm -f "${mselect_file}"

      if [[ ${ret_val} -eq 0 && -d "${dir}" ]]; then
        __hhs_change_dir "${dir}" &> /dev/null || return 1
        echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\""
        ret_val=0
      elif [[ -n "${dir}" && ! -d "${dir}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}" "Directory \"${dir}\" does not exist!"
        echo -e "${YELLOW}Hint: Type '$ save -r ${dir_alias}' to remove it."
      fi
    else
      echo "${YELLOW}No directories saved yet: \"${HHS_SAVED_DIRS_FILE}\" !"
    fi
    echo "${NC}"
  fi

  return ${ret_val}
}

# @function: Search and cd into the first match of the specified directory name.
# @param $1 [Opt] : The base search path.
# @param $2 [Req] : The directory glob to search and cd into.
function __hhs_godir() {

  local dir len mselect_file found_dirs=() search_path search_name ret_val=1 title

  if [[ "$#" -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [search_path] <dir_glob>"
  elif [[ -d "${1}" && -z "${2}" ]]; then
    dir="${1}"
    ret_val=0
  else
    if [[ -n "$2" ]]; then
      search_path="${1}"
    else
      search_path="$(pwd)"
    fi
    search_name="$(basename "${2:-$1}")"
    pushd "${search_path%/}" &> /dev/null || echo
    read -d '' -r -a found_dirs < <(find -L . -type d -iname "*""${search_name}" 2> /dev/null)
    popd &> /dev/null || echo
    len=${#found_dirs[@]}
    # If no directory is found under the specified name
    if [[ ${len} -eq 0 ]]; then
      echo "${YELLOW}No matches for directory with name \"${search_name}\" found in \"${search_path}\" !${NC}"
    # If there was only one directory found, CD into it
    elif [[ ${len} -eq 1 ]]; then
      dir=${found_dirs[0]}
      ret_val=0
    # If multiple directories were found with the same name, query the user
    else
      mselect_file=$(mktemp)
      title="Multiple directories (${len}) found. Please select one to go:\n${WHITE}Base dir: ${GREEN}${search_path}"
      if __hhs_mselect "${mselect_file}" "${title}${NC}" "${found_dirs[@]}"; then
        dir=$(grep . "${mselect_file}")
        ret_val=0
      fi
    fi
  fi

  [[ -f "${mselect_file}" ]] && \rm -f "${mselect_file}"

  # If a valid directory was selected, change to it.
  if [[ ${ret_val} -eq 0 && -n "${dir}" && -d "${dir}" ]]; then
    if __hhs_change_dir "${dir}" &> /dev/null; then
      echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"
      ret_val=0
    else
      __hhs_errcho "Unable to change to directory: ${WHITE}\"${dir}\""
      ret_val=1
    fi
  fi

  echo ''

  return ${ret_val}
}

# @function: Create all folders using a slash or dot notation path and immediately change into it.
# @param $1 [Req] : The directory tree to create, using slash (/) or dot (.) notation path.
function __hhs_mkcd() {

  local ret_val=1

  if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} <dirtree | package>"
    echo ''
    echo "E.g:. ${FUNCNAME[0]} dir1/dir2/dir3 (dirtree)"
    echo "E.g:. ${FUNCNAME[0]} dir1.dir2.dir3 (FQDN)"
    return 0
  elif [[ -n "$1" && ! -d "$1" ]]; then
    dir_tree="${1//.//}"
    dir_tree="${dir_tree//-//}"
    \mkdir -p "${dir_tree}" || return 1
    last_pwd=$(pwd)
    IFS=$'/'
    for dir in ${dir_tree}; do
      \cd "${dir}" || return 1
    done
    IFS="${OLDIFS}"
    export OLDPWD=${last_pwd}
    echo "${GREEN}   Directories created: ${WHITE}./${dir_tree}"
    echo "${GREEN}  Directory changed to: ${WHITE}$(pwd)${NC}"
    ret_val=0
  fi

  return ${ret_val}
}
