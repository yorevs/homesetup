#!/usr/bin/env bash

#  Script: hhs-git-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "git"; then

  # @function: Checkout the previous branch in history (skips branch-to-same-branch changes ).
  function __hhs_git-() {

    local cur_branch prev_branch

    # Get the current branch.
    cur_branch="$(command git rev-parse --abbrev-ref HEAD)"
    # Get the previous branch. Skip the same branch change (that is what is different from git checkout -).
    prev_branch=$(command git reflog | grep 'checkout: ' | grep -v "from $cur_branch to $cur_branch" | head -n1 | awk '{ print $6 }')
    command git checkout "$prev_branch"

    return $?
  }

  # shellcheck disable=SC2044
  # @function: Get the current branch name of all repositories from the specified directory.
  function __hhs_git_branch_all() {
    if [[ $# -ne 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <dirname>"
      return 1
    else
      for x in $(find "$1" -maxdepth 2 -type d -iname ".git"); do
        cd "${x//\/\.git/}" || continue
        pwd
        echo -en "${CYAN}"
        git status | head -n 1 || continue
        echo -en "${NC}"
        cd - > /dev/null || continue
      done
    fi

    return 0
  }

  # shellcheck disable=SC2044
  # @function: Get the status of current branch of all repositories from the specified directory.
  function __hhs_git_status_all() {
    if [[ $# -ne 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <dirname>"
      return 1
    else
      for x in $(find "$1" -maxdepth 2 -type d -iname "*.git"); do
        cd "${x//\/\.git/}" || continue
        pwd
        echo -en "${CYAN}"
        git status || continue
        echo -en "${NC}"
        cd - > /dev/null || continue
      done
    fi

    return 0
  }

  # @function: Display a file diff comparing the version beetwen the first and second commit IDs.
  # @param $1 [Req] : The first commit ID.
  # @param $2 [Req] : The second commit ID.
  # @param $3 [Req] : The filename to be compared.
  function __hhs_git_file_diff_show() {
    if [[ $# -ne 3 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <first_commit_id> <second_commit_id> <filename>"
      return 1
    else
      git diff "${1}" "${2}" -- "${3}"
    fi

    return $?
  }

  # @function: Display the contents of a file from specific commit ID.
  # @param $1 [Req] : The commit ID.
  # @param $2 [Req] : The filename to show contents from .
  function __hhs_git_file_show_contents() {
    if [[ $# -ne 2 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <commit_id> <filename>"
      return 1
    else
      git show "${1}":"${2}"
    fi

    return $?
  }

  # @function: List all the files in a commit
  # @param $1 [Req] : The commit ID
  function __hhs_git_show_changes() {
    if [[ $# -ne 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <commit_id>"
      return 1
    else
      git diff-tree --no-commit-id --name-only -r "${1}"
    fi

    return $?
  }

  # @function: Select and checkout local branch
  # @param $1 [Opt] : Fetch all branches instead of only local branches (default).
  function __hhs_git_select_branch() {

    local all_branches=() ret_val=0 all_flag='-a' all_str='or remote' sel_index sel_branch mselect_file 

    if [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} [-l||--local]"
      return 1
    elif [ ! -d "$(pwd)/.git" ]; then
      echo "Not a git repository !"
      return 1
    else
      [ "$1" = "-l" ] || [ "$1" = "--local" ] && unset all_flag && all_str='\b'
      clear
      [ -n "$all_flag" ] && echo -en "${YELLOW}=> Updating branches ...${NC}" && git fetch
      printf "%0.s\b" {1..24} && echo -e "\c"
      echo -e "${YELLOW}Select a local ${all_str} branch to checkout ${NC}"
      while read -r branch; do
        b_name="${branch}"
        all_branches+=("${b_name//\*?/}")
      done < <(git branch ${all_flag} | grep -v '\->')
      mselect_file=$(mktemp)
      if __hhs_mselect "$mselect_file" "${all_branches[*]}"; then
        echo -en "${YELLOW}=> Stashing changes prior to change ...${NC}"
        git stash apply 
        sel_index=$(grep . "$mselect_file")
        sel_branch="${all_branches["$sel_index"]}"
        git checkout "${sel_branch##*/}"
        ret_val=$?
        echo -en "${YELLOW}=> Retrieving changes from stash ...${NC}"
        git stash pop
      fi
    fi
    echo ''

    return $ret_val
  }

fi
