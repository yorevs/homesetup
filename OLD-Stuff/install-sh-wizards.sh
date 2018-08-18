#!/bin/bash

################################################################################
# C-Shell: install-sh-wizards.sh
# Purpose: Configure shellscript wizards.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

WIZARDS_DIR=/Users/hugo/Dropbox/Eclipse_Works/C_ANSI_C++_SH/Shell-Scripts/SH-Wizards/bin

BIN_DIR=/usr/bin

PROG_NAME=$(basename $0 | cut -d "." -f 1)

if ! test -d $BIN_DIR || ! test -d $WIZARDS_DIR
then
    echo "[$PROG_NAME] ### Error, Can't find folders: $BIN_DIR | $WIZARDS_DIR "
    exit 1
fi

echo "[$PROG_NAME] Installing SH-Wizards scripts "

SCRIPTS="$(find $WIZARDS_DIR -type f -name "*" | tr '\n' ' ')"

echo -e "[$PROG_NAME] Found scripts: \n$(echo $SCRIPTS | tr ' ' '\n')"

ANS="n"
count_scr=0

for next_scr in $SCRIPTS
do
    scr="$BIN_DIR/$(basename $next_scr)"
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

echo "[$PROG_NAME] Installation sumary: Scripts = $count_scr"
echo "[$PROG_NAME] Done."
echo ' '
