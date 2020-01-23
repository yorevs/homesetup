#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2034

#  Script: git-pull-all.bash
# Purpose: Pull all projects within the specified path to the given repository/branch
# Created: Mar 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=0.9.0

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME <search_path> [repository=[origin]] [branch=[HEAD]]
"

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Find all git repositories
SPATH="$1"
ALL=$(find "${SPATH}" -maxdepth 2 -type d -iname ".git")
shift

REPO="$1"
REPO=${REPO:-'origin'}
BRANCH="$2"
BRANCH=${BRANCH:-'current'}

[ -z "$ALL" ] && quit 1 "${YELLOW}No GIT repositories found at \"${SPATH}\" ${NC}"

echo 'GIT Projects found: '
echo ''
echo -e "${GREEN}${ALL}${NC}"
echo ''
echo -e "Repository: ${CYAN}$REPO${NC}, Branch: ${CYAN}$BRANCH${NC}"
echo ''

read -r -n 1 -p "Reset all changes and pull all of the above repositories (y/[n])? " ANS
[ "$ANS" != 'y' ] && [ "$ANS" != 'Y' ] && quit 2 "$ANS \nOperation aborted by the user!"

for gdir in $ALL; do
  pdir=$(dirname "$gdir")
  cd "$pdir" || continue
  if git rev-parse --abbrev-ref master@{u} &> /dev/null; then
    echo ''
    echo -e "${GREEN}Pulling project: \"$pdir\" ...${NC}"
    [ "$BRANCH" = "current" ] && gitbranch=$(git branch | grep '\*' | cut -d ' ' -f2)
    [ "$BRANCH" = "current" ] || gitbranch="$BRANCH"
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
    echo -e "${GREEN}Pulling the new code (${CYAN}$REPO/$gitbranch${NC}) ... "
    echo ''
    git pull "$REPO" "$gitbranch" || echo -e "${RED}Unable to pull the code. Skipping ...${NC}"
    if [ -n "${stash_flag}" ]; then
      echo -en "${YELLOW}\n=> Retrieving changes from stash ${NC}"
      if ! git stash pop &> /dev/null; then
        echo -e "${RED}### Unable to retrieve stash changes ${NC}"
      else
        echo -e " ... [   ${GREEN}OK${NC}   ]"
      fi
    fi
  else
    echo ''
    echo -e "${ORANGE}>>> The repository \"$pdir\" is not being TRACKED on remote !${NC}"
  fi
  cd - > /dev/null || continue
done

echo ''
echo 'Done!'
echo ''

quit 0
