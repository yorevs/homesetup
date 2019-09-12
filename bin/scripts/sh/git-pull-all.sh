#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090

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

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    unset -f quit usage version 
    ret=$1
    shift
    [ "$ret" -gt 1 ] && printf "%s" "${RED}"
    [ "$#" -gt 0 ] && printf "%s" "$*"
    # Unset all declared functions
    printf "%s\n" "${NC}"
    exit "$ret"
}

# Usage message.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
    quit "$1" "$USAGE"
}

# Version message.
version() {
    quit 0 "$VERSION"
}

# Check if the user passed the help or version parameters.
[ "$1" = '-h' ] || [ "$1" = '--help' ] && usage 0
[ "$1" = '-v' ] || [ "$1" = '--version' ] && version

# Find all git repositories
SPATH="$1"
ALL=$(find "${SPATH}" -maxdepth 2 -type d -iname ".git")
shift

REPO="$1"
REPO=${REPO:-'origin'}
BRANCH="$2"
BRANCH=${BRANCH:-'current'}

[ -z "$ALL" ] quit 1 "${YELLOW}No GIT repositories found at \"${SPATH}\" ${NC}"

echo 'GIT Projects found: '
echo ''
printf "%s\n" "${GREEN}${ALL}${NC}" 
echo ''
printf "%s\n" "Repository: ${CYAN}$REPO${NC}, Branch: ${CYAN}$BRANCH${NC}"
echo ''

read -r -n 1 -p "Reset all changes and pull all of the above repositories (y/[n])? " ANS
[ "$ANS" != 'y' ] && [ "$ANS" != 'Y' ] && quit 2 "$ANS \nOperation aborted by the user!"

for gdir in $ALL
do
    echo ''
    pdir=$(dirname "$gdir")
    printf "%s\n" "${GREEN}Pulling project: \"$pdir\" ...${NC}"
    cd "$pdir" || continue
    [ "$BRANCH" = "current" ] && gitbranch=$(git branch | grep '\*' | cut -d ' ' -f2)
    [ "$BRANCH" = "current" ] || gitbranch="$BRANCH"
    printf "%s\n" "${YELLOW}Resetting all of your changes...${NC}"
    git fetch
    git reset --hard "$gitbranch"
    test $? -ne 0 && quit 2 "Unable to checkout the code. Aborting!"
    printf "%s\n" "${GREEN}Pulling the new code ($REPO/$gitbranch) ...${NC}"
    echo ''
    git pull "$REPO" "$gitbranch"
    test $? -ne 0 && quit 2 "Unable to pull the code. Aborting!"
    cd - > /dev/null || continue
done

echo ''
echo 'Done!'
echo ''

quit 0