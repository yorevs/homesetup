#!/usr/bin/env bash

#  Script: git-pull-all.sh
# Purpose: Pull all projects within the specified path to the given repository/branch
# Created: Mar 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <search_path> [repository=[origin]] [branch=[HEAD]]
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    if test -n "$2" -o "$2" != ""; then
        echo -e "$2"
    fi

    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

# Import bash colors
test -f ~/.bash_colors && source ~/.bash_colors

# Find all git repositories
SPATH="$1"
ALL=$(find ${SPATH} -maxdepth 2 -type d -iname ".git")
shift

REPO="$1"
REPO=${REPO:-'origin'}
BRANCH="$2"
BRANCH=${BRANCH:-'current'}

test -z "$ALL" && quit 2 "${YELLOW}No GIT repositories found at \"${SPATH}\" ${NC}"

echo 'GIT Projects found: '
echo ''
echo "${GREEN}${ALL}${NC}" 
echo ''
echo "Repository: ${CYAN}$REPO${NC}, Branch: ${CYAN}$BRANCH${NC}"
echo ''

read -n 1 -p "Reset all changes and pull all of the above repositories (y/[n])? " ANS
test "$ANS" != 'y' -a "$ANS" != 'Y' && quit 2 "$ANS \n${RED}Operation aborted by the user!${NC}"

for gdir in $ALL
do
    echo ''
    pdir=$(dirname "$gdir")
    echo -e "${GREEN}Pulling project: \"$pdir\" ...${NC}"
    cd "$pdir"
    test "$BRANCH" = "current" && gitbranch=$(git branch | grep \* | cut -d ' ' -f2)
    test "$BRANCH" = "current" || gitbranch="$BRANCH"
    echo "${YELLOW}Resetting all of your changes...${NC}"
    git fetch
    git reset --hard $gitbranch
    test $? -ne 0 && quit 2 "${RED}Unable to checkout the code. Aborting!${NC}"
    echo "${GREEN}Pulling the new code ($REPO/$gitbranch) ...${NC}"
    echo ''
    git pull $REPO $gitbranch
    test $? -ne 0 && quit 2 "${RED}Unable to pull the code. Aborting!${NC}"
    cd - > /dev/null
    echo ''
    echo 'Done!'
    echo ''
done
