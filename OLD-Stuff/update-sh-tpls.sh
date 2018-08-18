#!/bin/bash

################################################################################
# C-Shell: update-sh-tpls.sh
# Purpose: Update all shellscript templates at user template dir.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

HOME_TPL_SCR=$HOME/Dropbox/Eclipse_Works/C_ANSI_C++_SH/Shell-Scripts/SH-Templates

HOME_TPL=$HOME/Templates

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] Updating Shellscript Templates"

test -d $HOME_TPL || mkdir $HOME_TPL

if ! test -d $HOME_TPL_SCR || ! test -d $HOME_TPL
then
    echo "[$PROG_NAME] ### Error, Can't find folders: $HOME_TPL_SCR | $HOME_TPL "
    exit 1
fi

SCRIPTS="$(find $HOME_TPL_SCR -maxdepth 1 -type f -name "*.sh" | tr '\n' ' ')"

ANS="n"
count_scr=0

for next_scr in $SCRIPTS
do
    scr="$HOME_TPL/$(basename $next_scr)"
    if test -f "$scr" || test -h "$scr"
    then
        if ! test $ANS = "a"
        then
            read -p "[$PROG_NAME] Script \"$scr\" already exists! Replace (y/n/a) ? " -n 1 ANS
            echo ' '
            ANS=$(echo $ANS | tr '[A-Z]' '[a-z]')
        fi
        if test "$ANS" = 'a' || test "$ANS" = 'y'
        then
            ln -sf $next_scr $scr
            count_scr=$((count_scr + 1))
        else
            continue
        fi
    else
        ln -s $next_scr $scr
        count_scr=$((count_scr + 1))
    fi
done

echo "[$PROG_NAME] Update Shellscripts summary: Scripts = $count_scr"
echo "[$PROG_NAME] Done."
echo ' '
