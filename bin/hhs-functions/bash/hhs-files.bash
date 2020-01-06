#!/usr/bin/env bash

#  Script: hhs-files.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Move files recursively to the Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function __hhs_del-tree() {

  local all dest

  if [ -z "$1" ] || [ "$1" = "/" ] || [ ! -d "$1" ]; then
    echo "Usage: del-tree <search_path> <glob_exp>"
    return 1
  else
    # Find all files and folders matching the <glob_exp>
    all=$(find -L . -maxdepth "${HHS_MAX_DEPTH}" "$1" -name "*$2" 2>/dev/null)
    # Move all to trash
    if [ -n "$all" ]; then
      read -r -n 1 -sp "${RED}### Do you want to move all files and folders matching: \"$2\" in \"$1\" recursively to Trash (y/[n]) ? " ANS
      echo ' '
      if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
        echo ' '
        for next in $all; do
          dest=${next##*/}
          while [ -e "${TRASH}/$dest" ]; do
            dest="${next##*/}-$(ts)"
          done
          mv -v "$next" "${TRASH}/$dest"
        done
      else
        echo -e "${YELLOW}If you decide to delete, the following files will be affected:${NC}"
        echo ' '
        echo "$all" | grep "$2"
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
