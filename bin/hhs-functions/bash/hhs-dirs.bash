#!/usr/bin/env bash

#  Script: hhs-dirs.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Save the one directory to be loaded by load.
# @param $1 [Opt] : The directory path to save.
# @param $2 [Opt] : The alias to access the directory saved.
function __hhs_save-dir() {

  local dir dir_alias all_dirs=()

  HHS_SAVED_DIRS=${HHS_SAVED_DIRS:-$HHS_DIR/.saved_dirs}
  touch "$HHS_SAVED_DIRS"

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    echo "Usage: ${FUNCNAME[0]} [options] | [dir_to_save] [dir_alias]"
    echo ''
    echo 'Options: '
    echo "    -e : Edit the saved dirs file."
    echo "    -r : Remove saved dir."
    return 1
  else

    [ -n "$2" ] || dir_alias=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
    [ -n "$2" ] && dir_alias=$(echo -en "$2" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')

    if [ "$1" = "-e" ]; then
      vi "$HHS_SAVED_DIRS"
    elif [ -z "$2" ] || [ "$1" = "-r" ]; then
      # Remove the previously saved directory aliased
      if grep -q "$dir_alias" "$HHS_SAVED_DIRS"; then
        echo "${YELLOW}Directory removed: ${WHITE}\"$dir_alias\" ${NC}"
      fi
      ised -e "s#(^$dir_alias=.*)*##g" -e '/^\s*$/d' "$HHS_SAVED_DIRS"
    else
      dir="$1"
      # If the path is not absolute, append the current directory to it.
      if [ -z "$dir" ] || [ "$dir" = "." ]; then dir=${dir//./$(pwd)}; fi
      if [ -d "$dir" ] && [[ ! "$dir" =~ ^/ ]]; then dir="$(pwd)/$dir"; fi
      if [ -n "$dir" ] && [ "$dir" = ".." ]; then dir=${dir//../$(pwd)}; fi
      if [ -n "$dir" ] && [ "$dir" = "-" ]; then dir=${dir//-/$OLDPWD}; fi
      if [ -n "$dir" ] && [ ! -d "$dir" ]; then
        echo "${RED}Can't save the directory \"${dir}\" that does not exist !${NC}"
        return 1
      fi
      # Remove the old saved directory aliased
      ised -e "s#(^$dir_alias=.*)*##g" -e '/^\s*$/d' "$HHS_SAVED_DIRS"
      IFS=$'\n' read -d '' -r -a all_dirs IFS="$HHS_RESET_IFS" < "$HHS_SAVED_DIRS"
      all_dirs+=("$dir_alias=$dir")
      printf "%s\n" "${all_dirs[@]}" > "$HHS_SAVED_DIRS"
      sort "$HHS_SAVED_DIRS" -o "$HHS_SAVED_DIRS"
      echo "${GREEN}Directory was saved: ${WHITE}\"$dir\" as ${HHS_HIGHLIGHT_COLOR}$dir_alias ${NC}"
    fi
  fi

  return 0
}

# shellcheck disable=SC2059,SC2181,SC2046
# @function: Pushd into a saved directory issued by save.
# @param $1 [Opt] : The alias to access the directory saved.
function __hhs_load-dir() {

  local dir_alias all_dirs=() dir pad pad_len mselect_file sel_index

  HHS_SAVED_DIRS=${HHS_SAVED_DIRS:-$HHS_DIR/.saved_dirs}
  touch "$HHS_SAVED_DIRS"

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [-l] | [dir_alias]"
    echo ''
    echo 'Options: '
    echo "    [dir_alias] : Change to the directory saved from the alias provided."
    echo "             -l : List all saved dirs."
    return 1
  fi

  IFS=$'\n' read -d '' -r -a all_dirs IFS="$HHS_RESET_IFS" < "$HHS_SAVED_DIRS"

  if [ ${#all_dirs[@]} -ne 0 ]; then

    case "$1" in
      -l)
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        echo ' '
        echo "${YELLOW}Available directories (${#all_dirs[@]}) saved:"
        echo ' '
        IFS=$'\n'
        for next in ${all_dirs[*]}; do
          dir_alias=$(echo -en "$next" | awk -F '=' '{ print $1 }')
          dir=$(echo -en "$next" | awk -F '=' '{ print $2 }')
          printf "${HHS_HIGHLIGHT_COLOR}${dir_alias}"
          printf '%*.*s' 0 $((pad_len - ${#dir_alias})) "$pad"
          echo -e "${YELLOW} was saved as ${WHITE}'${dir}'"
        done
        IFS="$HHS_RESET_IFS"
        echo "${NC}"
        return 0
        ;;
      '')
        clear
        echo "${YELLOW}Available saved directories (${#all_dirs[@]}):"
        echo -en "${WHITE}"
        IFS=$'\n'
        mselect_file=$(mktemp)
        __hhs_mselect "$mselect_file" "${all_dirs[*]}"
        if [ "$?" -eq 0 ]; then
          sel_index=$(grep . "$mselect_file")
          dir_alias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
          # sel_index is zero-based, so we need to increment this number
          dir=$(awk "NR==$((sel_index + 1))" "$HHS_SAVED_DIRS" | awk -F '=' '{ print $2 }')
        fi
        IFS="$HHS_RESET_IFS"
        ;;
      [a-zA-Z0-9_]*)
        dir_alias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
        dir=$(grep "^${dir_alias}=" "$HHS_SAVED_DIRS" | awk -F '=' '{ print $2 }')
        ;;
      *)
        echo -e "${RED}Invalid arguments: \"$1\"${NC}"
        return 1
        ;;
    esac

    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
      echo "${RED}Directory aliased by \"$dir_alias\" was not found !${NC}"
      return 1
    elif [ -n "$dir" ] && [ -d "$dir" ]; then
      pushd "$dir" &> /dev/null || return 1
      echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"
    fi

  else
    echo "${ORANGE}No saved directories available yet \"$HHS_SAVED_DIRS\" !${NC}"
  fi

  [ -f "$mselect_file" ] && command rm -f "$mselect_file"

  return 0
}

# @function: Pushd from the first match of the specified directory name.
# @param $1 [Req] : The base search path.
# @param $1 [Req] : The directory name to go.
function __hhs_go-dir() {

  local dir len mselect_file results=()

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} [search_path] <dir_name>"
    return 1
  elif [ -d "$1" ]; then
    pushd "$1" &> /dev/null && echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}" || return 1
  else
    local searchPath name sel_index
    [ -n "$2" ] && searchPath="$1" || searchPath="$(pwd)"
    [ -n "$2" ] && name="$(basename "$2")" || name="$(basename "$1")"
    IFS=$'\n' read -d '' -r -a results IFS="$HHS_RESET_IFS" <<< "$(find -L "${searchPath%/}" -maxdepth "${HHS_MAXDEPTH}" -type d -iname "*""$name" 2> /dev/null)"
    len=${#results[@]}
    # If no directory is found under the specified name
    if [ "$len" -eq 0 ]; then
      echo "${YELLOW}No matches for directory with name \"$name\" found !${NC}"
      return 1
    # If there was only one directory found, CD into it
    elif [ "$len" -eq 1 ]; then
      dir=${results[0]}
    # If multiple directories were found with the same name, query the user
    else
      clear
      echo "${YELLOW}@@ Multiple directories ($len) found. Please choose one to go into:"
      echo "Base dir: $searchPath"
      echo "-------------------------------------------------------------"
      echo -en "${NC}"
      IFS=$'\n'
      mselect_file=$(mktemp)
      __hhs_mselect "$mselect_file" "${results[*]//$searchPath\//}"
      # shellcheck disable=SC2181
      if [ "$?" -eq 0 ]; then
        sel_index=$(grep . "$mselect_file")
        dir=${results[$sel_index]}
      fi
      IFS="$HHS_RESET_IFS"
    fi
    [ -n "$dir" ] && [ -d "$dir" ] && pushd "$dir" &> /dev/null && echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}" || return 1
  fi

  [ -f "$mselect_file" ] && command rm -f "$mselect_file"

  return 0
}
