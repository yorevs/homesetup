#!/bin/bash

################################################################################
# C-Shell: template-config.sh
# Purpose: Copy all templates from the dropbox folder into the user folder.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

HOME_DBTPL=$HOME/Dropbox/Documents/Templates

HOME_TPL=$HOME/Templates

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] Configuring templates"

test -d $HOME_TPL || mkdir -p $HOME_TPL

if ! test -d $HOME_DBTPL || ! test -d $HOME_TPL
then
    echo "[$PROG_NAME] ### Error, Can't find folders: $HOME_DBTPL | $HOME_TPL "
    exit 1
fi

TEMPLATES="$(find $HOME_DBTPL -maxdepth 1 -type f -regex '.*/[^\.].*\..*' | grep -v '.*/\..*' | tr '\n' ' ' )"

ANS="n"
count_tpls=0

for next_tpl in $TEMPLATES
do
    tpl="$HOME_TPL/$(basename $next_tpl)"
    if test -f "$tpl" || test -h "$tpl"
    then
        if ! test $ANS = "a"
        then
            read -p "[$PROG_NAME] Template \"$tpl\" already exists! Replace (y/n/a) ? " -n 1 ANS
            echo ' '
            ANS=$(echo $ANS | tr '[A-Z]' '[a-z]')
        fi
        if test "$ANS" = 'a' || test "$ANS" = 'y'
        then
            ln -sf $next_tpl $tpl
            count_tpls=$((count_tpls + 1))
        else
            continue
        fi
    else
        ln -s $next_tpl $tpl
        count_tpls=$((count_tpls + 1))
    fi
done

echo "[$PROG_NAME] Configuration summary: Templates = $count_tpls"
echo "[$PROG_NAME] Done."
echo ' '
