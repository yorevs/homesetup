#!/usr/bin/env bash

#  Script: hhs-git-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions


# shellcheck disable=SC2068
# @function: Shortcut for `git add'. Adds M - Modified, A - Added, D - Deleted, R - Renamed, C - Copied, ? - Untracked files
function __hhs_git_add() {

  local changed_files mchoose_file ret_val=1 count=0 git_dir lines re_status

  git_dir="$(git rev-parse --show-toplevel)"
  re_status='^ *(M|A|D|R|C|\?)+ *'

  if [[ $# -eq 0 ]]; then
    IFS=$'\n'
    read -r -d '' -a changed_files < <(git status --porcelain)
    if [[ "${#changed_files[@]}" -gt 1 ]]; then
      mchoose_file=$(mktemp)
      if __hhs_mchoose -c "${mchoose_file}" "Add pathspecs to git" "${changed_files[@]}"; then
        read -r -d '' -a lines < <(\head -n 1 "${mchoose_file}" | \tr ' ' '\n')
        for line in "${lines[@]}"; do
          file="${git_dir}/${line}"
          if [[ ${line} =~ ${re_status} ]]; then
            continue
          elif [[ -f "${file}" ]]; then
            git add "${file}" && ret_val=$?
          else
            __hhs_errcho "${FUNCNAME[0]}" "File not found: F: '${file}'  L: '${line}'"
          fi
        done
      fi
      IFS="${OLFIFS}"
    elif [[ ${#changed_files[@]} -eq 1 ]]; then
      file="${changed_files[0]}"
      git add "$(awk '{print $2}' <<<"${file}")" && ret_val=$?
    else
      echo -e "\n${YELLOW}Nothing has changed!${NC}\n"
      return 1
    fi
  else
    count=${#}
    git add ${@} && ret_val=$?
  fi
  count=$(git diff --cached --numstat | wc -l | awk '{print $1}')
  [[ ${ret_val} -eq 0 ]] && echo -e "${GREEN}(${count}) file(s) has been added !${NC}"
  echo ''

  return ${ret_val}
}

# @function: Checkout the previous branch in history (skips branch-to-same-branch changes ).
function __hhs_git_branch_previous() {

  local cur_branch prev_branch

  # Get the current branch.
  cur_branch="$(git rev-parse --abbrev-ref HEAD)"
  # Get the previous branch. Skip the same branch change (that is what is different from git checkout -).
  prev_branch=$(git reflog | grep 'checkout: ' | grep -v "from $cur_branch to $cur_branch" | head -n1 | awk '{ print $6 }')
  git checkout "$prev_branch"

  return $?
}

# @function: Select and checkout a local or remote branch.
# @param $1 [Opt] : Fetch all branches instead of only local branches (default).
function __hhs_git_branch_select() {

  local all_branches=() ret_val=0 all_flag='-a' all_str='or remote'
  local sel_branch mchoose_file stash_flag branch_name

  if [[ '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} [options]"
    echo ''
    echo '    Options:'
    echo '      -l, --local : List only local branches. Do not fetch remote branches.'
    return 1
  elif [[ "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "${?}")" != '0' ]]; then
    __hhs_errcho "${FUNCNAME[0]}" "Not a git repository"
    return 1
  fi

  [[ "$1" == "-l" || "$1" == "--local" ]] && unset -f all_flag && all_str='\b'
  clear

  if [[ -n "${all_flag}" ]]; then
    echo -en "${YELLOW}=> Updating branches ${NC}"
    if ! git fetch &>/dev/null; then
      __hhs_errcho "${FUNCNAME[0]}" "Unable fetch from remote"
      return 1
    fi
    echo -e " ... [   ${GREEN}OK${NC}   ]"
    sleep 1
    echo -e "\033[1J\033[H"
  fi

  while read -r branch; do
    branch_name=${branch//\* /}
    all_branches+=("${branch_name}")
  done < <(git branch ${all_flag} | grep -v '\->')

  clear
  echo -e "${YELLOW}Select a local ${all_str} branch to checkout ${NC}"
  echo -en "${WHITE}"

  mchoose_file=$(mktemp)

  if __hhs_mselect "${mchoose_file}" "Select a local ${all_str} branch to checkout" "${all_branches[@]}"; then
    [[ -z "${sel_branch}" ]] && echo '' && return 1
    if ! git diff-index --quiet HEAD --; then
      echo -en "${YELLOW}=> Stashing your changes prior to change ${NC}"
      if ! git stash &>/dev/null; then
        __hhs_errcho "${FUNCNAME[0]}" "Unable to stash your changes"
        return 1
      fi
      stash_flag=1
      echo -e " ... [   ${GREEN}OK${NC}   ]\n"
    fi

    sel_branch=$(grep . "${mchoose_file}")
    branch_name="${sel_branch// /}"
    branch_name="${branch_name##*\/}"

    if git checkout "${branch_name}"; then
      ret_val=$?
      if [[ -n "$stash_flag" ]]; then
        echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
        if ! git stash pop &>/dev/null; then
          __hhs_errcho "${FUNCNAME[0]}" "Unable to retrieve stash changes"
          return 1
        fi
        echo -e " ... [   ${GREEN}OK${NC}   ]"
      fi
    else
      __hhs_errcho "${FUNCNAME[0]}" "Unable to checkout branch \"${sel_branch}\""
      return
    fi
  fi
  echo ''

  return $ret_val
}

# shellcheck disable=SC2044
# @function: Get the current branch name of all repositories from the base search path.
# @param $1 [Opt] : The base path to search for git repositories. Default is current directory.
function __hhs_git_branch_all() {

  local git_repos_path

  if [[ '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} [base_search_path]"
    return 1
  else
    git_repos_path=${1:-.}
    for repo in $(find "${git_repos_path}" -maxdepth 2 -type d -iname ".git"); do
      pushd "${repo//\/\.git/}" &>/dev/null || continue
      echo -e "\n${BLUE}Fetching status of $(basename "$(pwd)") ...${NC}\n"
      git status | head -n 1 || continue
      popd &>/dev/null || continue
      sleep 1
    done
  fi

  return 0
}

# shellcheck disable=SC2044
# @function: Get the status of current branch of all repositories from the base search path.
# @param $1 [Opt] : The base path to search for git repositories. Default is current directory.
function __hhs_git_status_all() {

  local git_repos_path

  if [[ '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} [base_search_path]"
    return 1
  else
    git_repos_path=${1:-.}
    for repo in $(find "${git_repos_path}" -maxdepth 2 -type d -iname "*.git"); do
      pushd "${repo//\/\.git/}" &>/dev/null || continue
      echo -e "\n${BLUE}Fetching status of $(basename "$(pwd)") ...${NC}\n"
      git status || continue
      popd &>/dev/null || continue
      sleep 1
    done
  fi

  return 0
}

# @function: Display a file diff comparing the version between the first and second commit IDs.
# @param $1 [Req] : The first commit ID.
# @param $2 [Req] : The second commit ID.
# @param $3 [Req] : The file to be compared.
function __hhs_git_show_file_diff() {
  if [[ $# -ne 3 || '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} <first_commit_id> <second_commit_id> <filename>"
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
    echo "usage: ${FUNCNAME[0]} <commit_id> <filename>"
    return 1
  else
    git show "${1}":"${2}"
  fi

  return $?
}

# @function: List all changed files from a commit ID.
# @param $1 [Req] : The commit ID.
function __hhs_git_show_changes() {
  if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} <commit_id>"
    return 1
  else
    git diff-tree --no-commit-id --name-only -r "${1}"
  fi

  return $?
}

# @function: Search and pull projects from the specified path using the given repository/branch.
# @param $1 [Opt] : The base path to search for git repositories. Default is current directory.
# @param $2 [Opt] : The remote repository to pull from. Default is "origin"
function __hhs_git_pull_all() {

  local cur_pwd git_repos_path all_repos=() sel_repos=() repository branch repo_dir stash_flag mchoose_file

  if [[ '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} [base_search_path] [repository]"
    echo ''
    echo '    Arguments:'
    echo '      repos_search_path   : The base path to search for git repositories. Default is current directory.'
    echo '      repository          : The remote repository to pull from. Default is \"origin\".'
    return 1
  fi

  cur_pwd=$(pwd)
  # Find all git repositories
  git_repos_path="${1:-.}"
  [[ ! -d "${git_repos_path}" ]] && __hhs_errcho "${FUNCNAME[0]}" "Repository path \"${git_repos_path}\" was not found ! " && return 1
  read -r -d '' -a all_repos <<<"$(find "${git_repos_path}" -maxdepth 3 -type d -iname ".git")"
  [[ ${#all_repos[@]} -eq 0 ]] && echo "${ORANGE}No GIT repositories found at \"${git_repos_path}\" ! ${NC}" && return 0
  shift
  repository="${1:-origin}"

  mchoose_file=$(mktemp)
  if __hhs_mchoose -c "${mchoose_file}" "Choose the projects to pull from. Available Repositories (${#all_repos[@]}):" "${all_repos[@]}"; then
    read -r -d '' -a sel_repos < <(grep . "${mchoose_file}")
  else
    return 1
  fi

  for repo in "${all_repos[@]}"; do
    repo_dir=$(dirname "${repo}")
    if [[ "${sel_repos[*]}" =~ ${repo} ]]; then
      if [[ -d "${repo_dir}" ]]; then
        pushd "${repo_dir}" &>/dev/null || __hhs_errcho "${FUNCNAME[0]}" " Unable to enter directory: \"${repo_dir}\" !"
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        if git rev-parse --abbrev-ref "${branch}@{u}" &>/dev/null; then
          stash_flag=0
          echo ''
          printf '%0.1s' "-"{1..80}
          echo -e "${WHITE}\nUpdating project ${CYAN}\"${repo_dir}\" => ${PURPLE}${repository}/${branch} ... \n${NC}"
          [[ "${branch}" == "current" ]] && gitbranch=$(git branch | grep '\*' | cut -d ' ' -f2)
          [[ "${branch}" == "current" ]] || gitbranch="${branch}"
          if git fetch; then
            if ! git diff-index --quiet HEAD --; then
              echo -en "\n${YELLOW}=> Stashing your changes prior to change ... ${NC}"
              if ! git stash &>/dev/null; then
                echo -e " [ ${RED}FAILED${NC} ] => Unable to stash changes. Skipping ... \n"
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
                if ! git stash pop &>/dev/null; then
                  echo -e " [ ${RED}FAILED${NC} ] => Unable to retrieve stash changes. Skipping ... \n"
                else
                  echo -e " [   ${GREEN}OK${NC}   ] \n"
                fi
              fi
            else
              __hhs_errcho "${FUNCNAME[0]}" "Unable to pull the code. Skipping ..."
            fi
          else
            __hhs_errcho "${FUNCNAME[0]}" "Unable to fetch repository updates. Skipping ..."
          fi
        else
          echo ''
          echo -e "${ORANGE}@@@ The project \"${repo_dir}\" on \"${repository}/${branch}\" is not being TRACKED on remote !${NC}"
        fi
        popd &>/dev/null || __hhs_errcho "${FUNCNAME[0]}" "Unable to leave directory: \"${repo_dir}\" !"
      else
        echo ''
        echo -e "${YELLOW}>>> Skipping: repository not found \"${repo_dir}\" ${NC}"
      fi
    else
      echo ''
      echo -e "${YELLOW}>>> Skipping: unselected project \"${repo_dir}\" ${NC}"
    fi
  done

  echo ''
  echo "${GREEN}Done ! ${NC}"
  echo ''

  \cd "${cur_pwd}" || return 1

  return 0
}

# @function: Generate a changelog between two tags or commit sha's.
# @param $1 [Opt] : The From Tag or commit #sha. If not provided, last tag will be used.
# @param $2 [Opt] : The To Tag or commit #sha. If not provided, HEAD will be used.
function __hhs_git_changelog() {

  local from_tag to_tag outfile='changelog.txt'

  [[ "${1}" == "-o" || "$1" == "--output" ]] && outfile="${2}" && shift 2

  if [[ '-h' == "$1" || '--help' == "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} [options] [from_tag_or_sha] [to_tag_or_sha]"
    echo ''
    echo '    Options:'
    echo '      -o, --output <file> : Write to file instead of changelog.txt'
    echo ''
    echo '    Arguments:'
    echo '      from_tag_or_sha     : The From Tag or commit #sha.'
    echo '      to_tag_or_sha       : The To Tag or commit #sha. If not provided, HEAD will be used.'
    return 1
  elif [[ "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "${?}")" != '0' ]]; then
    __hhs_errcho "${FUNCNAME[0]}" "Not a git repository"
    return 1
  fi

  from_tag="${1:-$(git describe --tags --abbrev=0)}"
  to_tag="${2:-HEAD}"

  echo -en "${YELLOW}\nGenerating Changelog [${from_tag}..${to_tag}]... "

  if git log --oneline --pretty='%h %ad %s' --date=short "${from_tag}".."${to_tag}" 1>"${outfile}" 2>"${outfile}"; then
    echo -e "${GREEN}√ OK${NC}\n"
    grep --color=always -E '^[a-f0-9]{7}' "${outfile}"
    return $?
  else
    echo -e "${RED}X FAILED${NC}\n"
    __hhs_errcho "${FUNCNAME[0]}" "Unable to generated changelog\n"
    grep --color=always -E 'fatal:' "${outfile}"
  fi

  return 1
}

# @function: Replace an existing tag.
# @param $1 [Req] : The old tag to delete.
# @param $2 [Req] : The new tag to substitute the old one.
# @param $3 [Opt] : The commit #sha for the new tag.
function __hhs_git_retag() {

  local old_tag new_tag commit_sha commit_msg git_log ret_val=1

  [[ "${1}" == "-m" || "$1" == "--message" ]] && commit_msg="${2}" && shift 2

  old_tag="${1}"
  new_tag="${2}"
  commit_sha="${3:-HEAD}"

  if [[ '-h' == "$1" || '--help' == "$1" || -z "${old_tag}" || -z "${new_tag}" ]]; then
    echo "usage: ${FUNCNAME[0]} <old_tag> <new_tag> [commit_sha]"
    echo ''
    echo '    Options:'
    echo '      -m, --message <msg> : The new tag message.'
    echo ''
    echo '    Arguments:'
    echo '      old_tag     : The old tag to delete.'
    echo '      new_tag     : The new tag to substitute the old one.'
    echo '      commit_sha  : The new tag commit sha.'
    return 1
  elif [[ "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "${?}")" != '0' ]]; then
    __hhs_errcho "${FUNCNAME[0]}" "Not a git repository"
    return 1
  fi

  commit_msg="${commit_msg:-$(git tag -l "${old_tag}" -n1 --format="%(contents)")}"
  echo -en "${YELLOW}\nReplacing tag ${RED}'${old_tag}'${NC} by ${GREEN}'${new_tag}'${WHITE} -> '${commit_msg}'... "

  git_log=$(mktemp)
  if git tag --delete "${old_tag}" > "${git_log}" 2>&1 \
    && git push --delete origin "${old_tag}" >> "${git_log}" 2>&1 \
    && git tag -a "${new_tag}" "${commit_sha}" -m "${commit_msg}" >> "${git_log}" 2>&1 \
    && git push origin --tags >> "${git_log}" 2>&1; then
      echo -e "${GREEN}√ OK${NC}\n"
      echo -e "Successfully re-tagged: ${BLUE}${new_tag} ${WHITE}-> '$(git tag -l "${new_tag}" -n1 --format="%(contents)")'${NC}\n"
      ret_val=0
  else
    echo -e "${RED}X FAILED${NC}\n"
    __hhs_errcho "${FUNCNAME[0]}" "Unable to replace git tag\n"
    grep --color=always -E 'fatal:' "${git_log}"
  fi

  \rm -f "${git_log}"

  return $ret_val
}
