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
    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
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
    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
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
    if [[ $# -ne 3 || '-h' == "$1" || '--help' == "$1" ]]; then
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
    if [[ $# -ne 2 || '-h' == "$1" || '--help' == "$1" ]]; then
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
    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
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
    local sel_index sel_branch mchoose_file stash_flag b_name

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} [options]"
      echo ''
      echo '    Options:'
      echo '      -l | --local : List only local branches. Do not fetch remote branches.'
      return 1
    elif [[ ! -d "$(pwd)/.git" ]]; then
      echo "Not a git repository !"
      return 1
    else
      [[ "$1" == "-l" || "$1" == "--local" ]] && unset all_flag && all_str='\b'
      clear
      if [[ -n "${all_flag}" ]]; then
        echo -en "${YELLOW}=> Updating branches ${NC}"
        if ! git fetch; then
          __hhs_errcho "${FUNCNAME[0]}: ### Unable fetch from remote ${NC}"
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
      mchoose_file=$(mktemp)
      if __hhs_mselect "$mchoose_file" "${all_branches[@]}"; then
        if ! git diff-index --quiet HEAD --; then
          echo -en "${YELLOW}=> Stashing your changes prior to change ${NC}"
          if ! git stash &> /dev/null; then
            __hhs_errcho "${FUNCNAME[0]}: ### Unable to stash your changes ${NC}"
            return 1
          fi
          stash_flag=1
          echo -e " ... [   ${GREEN}OK${NC}   ]\n"
        fi
        sel_index=$(grep . "$mchoose_file")
        sel_branch="${all_branches["$sel_index"]}"
        b_name="${sel_branch// /}"
        b_name="${b_name##*\/}"
        if git checkout "$b_name"; then
          ret_val=$?
          if [[ -n "$stash_flag" ]]; then
            echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
            if ! git stash pop &> /dev/null; then
              __hhs_errcho "${FUNCNAME[0]}: ### Unable to retrieve stash changes ${NC}"
              return 1
            fi
            echo -e " ... [   ${GREEN}OK${NC}   ]"
          fi
        else
          __hhs_errcho "${FUNCNAME[0]}: ### Unable to checkout branch \"${sel_branch}\" ${NC}"
          return
        fi
      fi
    fi
    echo ''

    return $ret_val
  }

  # @function: Search and `git pull all' projects from the specified path using the given repository/branch.
  # @param $1 [Opt] : TODO Comment it
  # @param $2 [Opt] : TODO Comment it
  function __hhs_git_pull_all() {

    local git_repos_path all_repos=() sel_indexes=() repository branch repo_dir stash_flag mchoose_file

    if [[ '-h' == "$1" ||  '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <repos_search_path> [repository]"
      echo ''
      echo '    Arguments:'
      echo '      repos_search_path   : Where to find out git repositories to pull'
      echo '      repository          : The remote repository to pull from. Default is \"origin\"'
      return 1
    fi

    # Find all git repositories
    git_repos_path="${1:-.}"
    [[ ! -d "${git_repos_path}" ]] && __hhs_errcho "${FUNCNAME[0]}: Repository path \"${git_repos_path}\" was not found ! " && return 1
    IFS=$'\n' read -r -d '' -a all_repos <<< "$(find "${git_repos_path}" -maxdepth 2 -type d -iname ".git")"
    [[ ${#all_repos[@]} -eq 0 ]] && echo "${ORANGE}No GIT repositories found at \"${git_repos_path}\" ! ${NC}" && return 0
    shift
    repository="${1:-origin}"

    clear
    echo "${YELLOW}Choose the projects to pull from. Available Repositories (${#all_repos[@]}):"
    echo -en "${WHITE}"

    mchoose_file=$(mktemp)
    if __hhs_mchoose -c "$mchoose_file" "${all_repos[@]}"; then
      IFS=' ' read -r -d $'\n' -a sel_indexes <<< "$(grep . "$mchoose_file")"
    else
      return 1
    fi

    for idx in "${!all_repos[@]}"; do
      repo_dir=$(dirname "${all_repos[$idx]}")
      if [[ "${sel_indexes[$idx]}" == '1' && -d "${repo_dir}" ]]; then
        pushd "${repo_dir}" &> /dev/null || __hhs_errcho "${FUNCNAME[0]}:  Unable to enter directory: \"${repo_dir}\" !"
        branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
        if git rev-parse --abbrev-ref "${branch}@{u}" &> /dev/null; then
          stash_flag=0
          echo ''
          printf '%0.1s' "-"{1..80}
          echo -e "${WHITE}\nUpdating project ${CYAN}\"${repo_dir}\" => ${PURPLE}${repository}/${branch} ...${NC}"
          [[ "${branch}" == "current" ]] && gitbranch=$(git branch | grep '\*' | cut -d ' ' -f2)
          [[ "${branch}" == "current" ]] || gitbranch="${branch}"
          if git fetch; then
            if ! git diff-index --quiet HEAD --; then
              echo -en "\n${YELLOW}=> Stashing your changes prior to change ... ${NC}"
              if ! git stash &> /dev/null; then
                echo -e " [ ${RED}FAILED${NC} ] => ### Unable to stash changes. Skipping ... \n"
              else
                stash_flag=1
                echo -e " [   ${GREEN}OK${NC}   ] \n"
              fi
            fi
            echo -e "${WHITE}Pulling new code changes${NC} ... "
            echo ''
            if git pull "${repository}" "${gitbranch}"; then
              if [[ ${stash_flag} -ne 0 ]]; then
                echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
                if ! git stash pop &> /dev/null; then
                  echo -e " [ ${RED}FAILED${NC} ] => ### Unable to retrieve stash changes. Skipping ... \n"
                else
                  echo -e " [   ${GREEN}OK${NC}   ] \n"
                fi
              fi
            else
              __hhs_errcho "${FUNCNAME[0]}: ### Unable to pull the code. Skipping ...${NC}"
            fi
          else
            __hhs_errcho "${FUNCNAME[0]}: ### Unable to fetch repository updates. Skipping ...${NC}"
          fi
        else
          echo ''
          echo -e "${ORANGE}@@@ The project \"${repo_dir}\" on \"${repository}/${branch}\" is not being TRACKED on remote !${NC}"
        fi
        popd &> /dev/null || __hhs_errcho "${FUNCNAME[0]}: ### Unable to leave directory: \"${repo_dir}\" !"
      else
        echo ''
        echo -e "${YELLOW}>>> Skipping project \"${repo_dir}\" ${NC}"
      fi
    done

    echo ''
    echo "${GREEN}Done ! ${NC}"
    echo ''
  }

fi
