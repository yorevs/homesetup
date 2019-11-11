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

  local dir dirAlias allDirs=()

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

    [ -n "$2" ] || dirAlias=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
    [ -n "$2" ] && dirAlias=$(echo -en "$2" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')

    if [ "$1" = "-e" ]; then
      vi "$HHS_SAVED_DIRS"
    elif [ -z "$2" ] || [ "$1" = "-r" ]; then
      ised -e "s#(^$dirAlias=.*)*##g" -e '/^\s*$/d' "$HHS_SAVED_DIRS"
      echo "${YELLOW}Directory removed: ${WHITE}\"$dirAlias\" ${NC}"
    else
      dir="$1"
      # If the path is not absolute, append the current directory to it.
      [ -d "$dir" ] && [[ ! "$dir" =~ ^/ ]] && dir="$(pwd)/$dir"
      test -z "$dir" -o "$dir" = "." && dir=${dir//./$(pwd)}
      test -n "$dir" -a "$dir" = ".." && dir=${dir//../$(pwd)}
      test -n "$dir" -a "$dir" = "-" && dir=${dir//-/$OLDPWD}
      test -n "$dir" -a ! -d "$dir" && echo "${RED}Directory \"$dir\" is not a valid!${NC}" && return 1
      ised -e "s#(^$dirAlias=.*)*##" -e '/^\s*$/d' "$HHS_SAVED_DIRS"
      echo "$dirAlias=$dir" >>"$HHS_SAVED_DIRS"
      # shellcheck disable=SC2046
      IFS=$'\n' read -d '' -r -a allDirs IFS="$HHS_RESET_IFS" <"$HHS_SAVED_DIRS"
      echo -e "${allDirs[@]}" >"$HHS_SAVED_DIRS"
      sort "$HHS_SAVED_DIRS" -o "$HHS_SAVED_DIRS"
      echo "${GREEN}Directory saved: ${WHITE}\"$dir\" as ${HIGHLIGHT_COLOR}$dirAlias ${NC}"
    fi
  fi

  return 0
}

# shellcheck disable=SC2059
# @function: Pushd into a saved directory issued by save.
# @param $1 [Opt] : The alias to access the directory saved.
function __hhs_load-dir() {

  local dirAlias allDirs=() dir pad pad_len mselectFile

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

  # shellcheck disable=SC2046
  IFS=$'\n' read -d '' -r -a allDirs IFS="$HHS_RESET_IFS" <"$HHS_SAVED_DIRS"

  if [ ${#allDirs[@]} -ne 0 ]; then

    case "$1" in
    -l)
      pad=$(printf '%0.1s' "."{1..60})
      pad_len=40
      echo ' '
      echo "${YELLOW}Available directories (${#allDirs[@]}) saved:"
      echo ' '
      (
        IFS=$'\n'
        for next in ${allDirs[*]}; do
          dirAlias=$(echo -en "$next" | awk -F '=' '{ print $1 }')
          dir=$(echo -en "$next" | awk -F '=' '{ print $2 }')
          printf "${HIGHLIGHT_COLOR}${dirAlias}"
          printf '%*.*s' 0 $((pad_len - ${#dirAlias})) "$pad"
          echo -e "${YELLOW} is saved as ${WHITE}'${dir}'"
        done
        IFS="$HHS_RESET_IFS"
      )
      echo "${NC}"
      return 0
      ;;
    '')
      clear
      echo "${YELLOW}Available directories (${#allDirs[@]}) saved:"
      echo -en "${WHITE}"
      (
        IFS=$'\n'
        # shellcheck disable=SC2030
        mselectFile=$(mktemp)
        __hhs_mselect "$mselectFile" "${allDirs[*]}"
        # shellcheck disable=SC2181
        if [ "$?" -eq 0 ]; then
          selIndex=$(grep . "$mselectFile")
          dirAlias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
          # selIndex is zero-based
          dir=$(awk "NR==$((selIndex + 1))" "$HHS_SAVED_DIRS" | awk -F '=' '{ print $2 }')
        fi
        IFS="$HHS_RESET_IFS"
      )
      ;;
    [a-zA-Z0-9_]*)
      dirAlias=$(echo -en "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      dir=$(grep "^${dirAlias}=" "$HHS_SAVED_DIRS" | awk -F '=' '{ print $2 }')
      ;;
    *)
      echo -e "${RED}Invalid arguments: \"$1\"${NC}"
      return 1
      ;;
    esac

    if [ -n "$dir" ] && [ ! -d "$dir" ]; then
      echo "${RED}Directory ($dirAlias): \"$dir\" was not found${NC}"
      return 1
    elif [ -n "$dir" ] && [ -d "$dir" ]; then
      pushd "$dir" &>/dev/null || return 1
      echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"
    fi

  else
    echo "${ORANGE}No directories were saved yet \"$HHS_SAVED_DIRS\" !${NC}"
  fi

  # shellcheck disable=SC2031
  [ -f "$mselectFile" ] && command rm -f "$mselectFile"

  return 0
}

# @function: Pushd from the first match of the specified directory name.
# @param $1 [Req] : The base search path.
# @param $1 [Req] : The directory name to go.
function __hhs_go-dir() {

  local dir len mselectFile results=()

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
    echo "Usage: ${FUNCNAME[0]} [search_path] <dir_name>"
    return 1
  else
    local searchPath name selIndex
    [ -n "$2" ] && searchPath="$1" || searchPath="$(pwd)"
    [ -n "$2" ] && name="$(basename "$2")" || name="$(basename "$1")"
    IFS=$'\n' read -d '' -r -a results IFS="$HHS_RESET_IFS" <<<"$(find -L "$searchPath" -type d -iname "*""$name" 2>/dev/null)"
    len=${#results[@]}
    # If no directory is found under the specified name
    if [ "$len" -eq 0 ]; then
      echo "${YELLOW}No matches for directory with name \"$name\" was found !${NC}"
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
      mselectFile=$(mktemp)
      __hhs_mselect "$mselectFile" "${results[*]//$searchPath\//}"
      # shellcheck disable=SC2181
      if [ "$?" -eq 0 ]; then
        selIndex=$(grep . "$mselectFile")
        dir=${results[$selIndex]}
      fi
      IFS="$HHS_RESET_IFS"
    fi
    [ -n "$dir" ] && [ -d "$dir" ] && pushd "$dir" &>/dev/null && echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}" || return 1
  fi

  [ -f "$mselectFile" ] && command rm -f "$mselectFile"

  return 0
}
