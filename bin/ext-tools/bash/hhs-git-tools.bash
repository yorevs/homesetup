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
  function __hhs_git_branch_previous() {

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
  function __hhs_git_show_file_diff() {
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
  function __hhs_git_show_file_contents() {
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

    local all_branches=() ret_val=0 all_flag='-a' all_str='or remote'
    local sel_index sel_branch mselect_file stash_flag b_name

    if [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} [options]"
      echo ''
      echo '    Options:'
      echo '      -l | --local : List only local branches. Do not fetch remote branches.'
      return 1
    elif [ ! -d "$(pwd)/.git" ]; then
      echo "Not a git repository !"
      return 1
    else
      [ "$1" = "-l" ] || [ "$1" = "--local" ] && unset all_flag && all_str='\b'
      clear
      if [ -n "$all_flag" ]; then
        echo -en "${YELLOW}=> Updating branches ${NC}"
        if ! git fetch; then
          echo -e "${RED}### Unable fetch from remote ${NC}"
          return 1
        fi
        echo -e " ... [   ${GREEN}OK${NC}   ]"
        sleep 1
        echo -e "\033[1J\033[H"
      fi
      echo -e "${YELLOW}Select a local ${all_str} branch to checkout ${NC}"
      while read -r branch; do
        b_name=${branch//\* /}
        all_branches+=("${b_name}")
      done < <(git branch ${all_flag} | grep -v '\->')
      mselect_file=$(mktemp)
      if __hhs_mselect "$mselect_file" "${all_branches[@]}"; then
        if ! git diff-index --quiet HEAD --; then
          echo -en "${YELLOW}=> Stashing your changes prior to change ${NC}"
          if ! git stash &> /dev/null; then
            echo -e "${RED}### Unable to stash your changes ${NC}"
            return 1
          fi
          stash_flag=1
          echo -e " ... [   ${GREEN}OK${NC}   ]\n"
        fi
        sel_index=$(grep . "$mselect_file")
        sel_branch="${all_branches["$sel_index"]}"
        b_name="${sel_branch// /}"
        b_name="${b_name##*\/}"
        if git checkout "$b_name"; then
          ret_val=$?
          if [ -n "$stash_flag" ]; then
            echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
            if ! git stash pop &> /dev/null; then
              echo -e "${RED}### Unable to retrieve stash changes ${NC}"
              return 1
            fi
            echo -e " ... [   ${GREEN}OK${NC}   ]"
          fi
        else
          echo -e "${RED}### Unable to checkout branch \"${sel_branch}\" ${NC}"
          return
        fi
      fi
    fi
    echo ''

    return $ret_val
  }

  # @function: Pull all projects within the specified path to the given repository/branch.
  # @param $1 [Opt] :
  # @param $2 [Opt] :
  function __hhs_git_pull_all() {

    local git_repos_path all_repos repository branch repo_dir stash_flag

    if [[ "${#1}" -eq 0 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <repos_search_path> [repository=[origin]] [branch=[HEAD]]"
      echo ''
      echo '    Arguments:'
      echo '      repos_search_path   : Where to find out git repositories to pull'
      echo '      repository          : The remote repository to pull from'
      echo '      branch              : The remote branch to pull from'
      return 1
    fi

    # Find all git repositories
    git_repos_path="${1}"
    [ ! -d "${git_repos_path}" ] && echo "${RED}Repository path \"${git_repos_path}\" was not found ! ${NC}" && return 1
    all_repos=$(find "${git_repos_path}" -maxdepth 2 -type d -iname ".git")
    [ -z "${all_repos}" ] && echo "${ORANGE}No GIT repositories found at \"${git_repos_path}\" ! ${NC}" && return 0
    shift
    repository="${1:-origin}"
    branch="${2:-current}"

    echo '--- GIT Repositories found ---'
    echo ''
    echo -e "${GREEN}${all_repos}${NC}"
    echo ''
    echo -e "Repository: ${CYAN}${repository}${NC}/${CYAN}${branch}${NC}"
    echo ''

    read -rsn1 -p "${YELLOW}Stash all changes and pull all of the above repositories (y/[n])? " ANS
    [ "$ANS" != 'y' ] && [ "$ANS" != 'Y' ] && echo -e "\n${RED}Operation aborted by the user ! ${NC}" && return 1
    echo ''

    IFS=$'\n'
    for git_dir in ${all_repos}; do
    
      stash_flag=0
      repo_dir=$(dirname "${git_dir}")
      pushd "${repo_dir}" &> /dev/null || echo "${RED} Unable to enter directory: \"${repo_dir}\" ! ${NC}"

      if git rev-parse --abbrev-ref 'master@{u}' &> /dev/null; then
        echo ''
        echo -e "${GREEN}Pulling project: \"${repo_dir}\" ...${NC}"
        [ "${branch}" = "current" ] && gitbranch=$(git branch | grep '\*' | cut -d ' ' -f2)
        [ "${branch}" = "current" ] || gitbranch="${branch}"
        git fetch || echo -e "${RED}Unable to fetch repository updates. Skipping ...${NC}"
        if ! git diff-index --quiet HEAD --; then
          echo -en "${YELLOW}=> Stashing your changes prior to change ${NC}"
          if ! git stash &> /dev/null; then
            echo -e "${RED}### Unable to stash your changes. Skipping ...${NC}"
          else
            stash_flag=1
            echo -e " ... [   ${GREEN}OK${NC}   ]\n"
          fi
        fi
        echo -e "${GREEN}Pulling the new code (${CYAN}${repository}/${gitbranch}${NC}) ... "
        echo ''
        git pull "${repository}" "${gitbranch}" || echo -e "${RED}Unable to pull the code. Skipping ...${NC}"
        if [[ ${stash_flag} -ne 0 ]]; then
          echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
          if ! git stash pop &> /dev/null; then
            echo -e "${RED}### Unable to retrieve stash changes ${NC}"
          else
            echo -e " ... [   ${GREEN}OK${NC}   ]"
          fi
        fi
      else
        echo ''
        echo -e "${ORANGE}>>> The repository \"${repo_dir}\" is not being TRACKED on remote !${NC}"
      fi

      popd &> /dev/null || echo "${RED} Unable to leave directory: \"${repo_dir}\" ! ${NC}"
    done
    IFS="$HHS_RESET_IFS"

    echo ''
    echo "${GREEN}Done ! ${NC}"
    echo ''
  }

fi
