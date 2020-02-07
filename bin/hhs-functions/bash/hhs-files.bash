#!/usr/bin/env bash

#  Script: hhs-files.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: List all file names sorted by name
# @param $1 [Opt] : The column to sort; 9 (filename) by default
function __hhs_ls_sorted() {

  col="${1:-9}"
  command ls -la | sort -k "$col"

  return $?
}

# @function: Move files recursively to the Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function __hhs_del_tree() {

  local all dest

  if [[ $# -le 1 || ! -d "$1" ]]; then
    echo "Usage: del-tree <search_path> <glob_expr>"
    return 1
  elif [[ "$1" = '/' ]] || [[ "$(pwd)" = '/' && "$1" = '.' ]]; then
    echo "### Can't deltree a protected folder"
    return 1
  else
    # Find all files and folders matching the <glob_exp>
    all=$(find -L . "$1" -name "*$2" 2> /dev/null)
    # Move all to trash
    if [[ -n "${all}" ]]; then
      read -rsn 1 -p "${RED}### Do you want to move all files and folders matching: \"$2\" in \"$1\" recursively to Trash (y/[n]) ? " ANS
      echo ' '
      if [[ "$ANS" = 'y' || "$ANS" = 'Y' ]]; then
        echo ' '
        for next in ${all}; do
          dest=${next##*/}
          while [[ -e "${TRASH}/$dest" ]]; do
            dest="${next##*/}-$(ts)"
          done
          mv -v "${next}" "${TRASH}/$dest"
        done
      else
        echo -e "${YELLOW}If you decide to delete, the following files will be affected:${NC}"
        echo ' '
        echo "${all}" | grep "$2"
      fi
      echo "${NC}"
    else
      echo ' '
      echo "${YELLOW}No files or folders matching \"$2\" were found in \"$1\" !${NC}"
      echo ' '
    fi
  fi

  return 0
}
