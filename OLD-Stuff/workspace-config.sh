#!/bin/bash

################################################################################
# C-Shell: workspace-config.sh
# Purpose: Copy all templates from the dropbox folder into the user folder.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

HOME_DBWS=$HOME/Dropbox/Eclipse_Works

HOME_WS=$HOME/Workspace

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] This script is not used anymore !"
exit 0

echo "[$PROG_NAME] Configuring Local Workspace"

test -d $HOME_WS || {
    read -p "[$PROG_NAME] Local workspace dir does not exist! Create (y/n) ? " -n 1 ans
    if test "$ans" = 'Y' || test "$ans" = 'y'; then mkdir -p $HOME_WS; fi
}

WORKSPACES="$(find $HOME_DBWS -maxdepth 1 -mindepth 1 -type d -regex '.*/[^\.].*' | tr '\n' ' ')"

count_ws=0
count_ptjs=0
for next_ws in $WORKSPACES
do
    ws="$HOME_WS/$(basename $next_ws)"
    db_projects="$(find $next_ws -maxdepth 1 -mindepth 1 -type d -regex '.*/[^\.].*' | tr '\n' ' ')"
    ans="n"
    for next_prj in $db_projects
    do
        prj="$ws/$(basename $next_prj)"
        test -d "$ws" ||  mkdir "$ws"
        if test -f "$prj" || test -h "$prj"
        then
            if ! test $ans = "a" 
            then
                read -p "[$PROG_NAME] Project \"$prj\" already exists! Replace (y/n/a) ? " -n 1 ans
                echo ' '
                ans=$(echo $ans | tr '[A-Z]' '[a-z]')
            fi
            if test "$ans" = 'a' || test "$ans" = 'y'
            then
                ln -sf $next_prj $prj
                count_ptjs=$((count_ptjs + 1))
            else
                continue
            fi
        else
            ln -s $next_prj $prj
            count_ptjs=$((count_ptjs + 1))
        fi
    done
    count_ws=$((count_ws + 1))
done

echo "[$PROG_NAME] Configuration summary: Workspaces = $count_ws, Projects = $count_ptjs"
echo "[$PROG_NAME] Done."
echo ' '
