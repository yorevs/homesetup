#!/usr/bin/env bash

#  Script: hhs-files.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: List files sorted by the specified column.
# @param $1 [Opt] : The column to sort; 9 (filename) by default
function __hhs_ls_sorted() {

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [column_number]"
    return 1
  else
    col="${1:-9}"
    command ls -la | sort -k "$col"
    return $?
  fi
}

# @function: Move files recursively to the Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function __hhs_del_tree() {

  local all trash_dest search_path glob dry_run='Y'

  if [[ $# -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [-n|-f] <search_path> <glob_expr>"
    echo ''
    echo '  Options:'
    echo "    -n | --dry-run  : Dry run. Don't actually remove anything, just show what would be done."
    echo '    -f | --force    : Actually delete all files/directories it finds.'
    return 1
  else

    case "$1" in
      '-f' | '--force')
        dry_run='N'
        shift
        ;;
      '-n' | '--dry-run')
        dry_run='Y'
        shift
        ;;
    esac

    if [[ "$1" == '/' ]] || [[ "$(pwd)" == '/' && "$1" == '.' ]]; then
      __hhs_errcho "${FUNCNAME[0]}: Can't del-tree the root folder"
      return 1
    fi

    search_path="$1"
    glob="$2"
    all=$(find -L "${search_path}" -name "${glob}" 2> /dev/null)

    if [[ -n "${all}" ]]; then
      if [[ "$dry_run" == 'N' ]]; then
        for next in ${all}; do
          trash_dest="${next##*/}"
          while [[ -e "${TRASH}/${trash_dest}" ]]; do
            trash_dest="${next##*/}-$(ts)"
          done
          if command mv "${next}" "${TRASH}/${trash_dest}" &> /dev/null; then
            echo -e "${ORANGE}Deleted: ${WHITE}${next} -> ${TRASH}/${trash_dest}${NC}"
          else
            __hhs_errcho "${FUNCNAME[0]}: Could not move \"${next}\" to ${TRASH}/${trash_dest}"
          fi
        done
      else
        for next in ${all}; do
          echo -e "${YELLOW}Would delete ${WHITE}-> ${next}${NC}"
        done
      fi
    else
      echo ' '
      echo "${YELLOW}No files or folders matching \"${glob}\" were found in \"$1\" !${NC}"
      echo ' '
    fi
  fi

  return 0
}
