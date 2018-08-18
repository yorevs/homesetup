#!/bin/bash

################################################################################
# C-Shell: config-developer.sh
# Purpose: Configure all developer tool on macosx.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

USER=${USER:-"hugo"}

DEV_HOME=${DEV_HOME:-/Applications/Xcode.app/Contents/Developer}

QT_HOME=${QT_HOME:-$HOME/Applications/Qt5.3.0/5.3/clang_64}

BIN_DIR=${BIN_DIR:-"/usr/bin"}

FRAMEWORKS_DIR="/System/Library/Frameworks"

PROG_NAME=$(basename $0 | cut -d "." -f 1)

if ! test "$(uname -s)" = "Darwin"
then
    echo "[$PROG_NAME] ### Error, This script is intended to MacOSX only !"
    echo ' '
    exit 1;
fi

echo ' '
echo "[$PROG_NAME] Configuring developer tools"
echo ' '
echo -n "[$PROG_NAME] " && test -d "$BIN_DIR" && echo -n "[ OK ]" || echo -n "[ ?? ]" && echo " BIN_DIR=$BIN_DIR ."
echo -n "[$PROG_NAME] " && test -d "$QT_HOME" && echo -n "[ OK ]" || echo -n "[ ?? ]" && echo " QT_HOME=$QT_HOME ."
echo -n "[$PROG_NAME] " && test -d "$DEV_HOME" && echo -n "[ OK ]" || echo -n "[ ?? ]" && echo " XCODE_HOME=$DEV_HOME ."
echo -n "[$PROG_NAME] " && test -d "$FRAMEWORKS_DIR" && echo -n "[ OK ]" || echo -n "[ ?? ]" && echo " FRAMEWORKS=$FRAMEWORKS_DIR ."
echo ' '

if ! test -d $BIN_DIR || ! test -d $DEV_HOME || ! test -d $QT_HOME || ! test -d $FRAMEWORKS_DIR
then
    echo "[$PROG_NAME] ### Error, Can't find one or more required folders !"
    echo ' '
    exit 1
fi

# XCode tools to link
XCODE_APP_FILTER="gcc|make|svn|cvs|g\+\+"
XCODE_APPS=$(find -E $DEV_HOME/usr/bin -regex ".*/($XCODE_APP_FILTER)" | tr '\n' ' ')

# Qt tools to link
QT_APP_FILTER="qmake|lrelease|lupdate|rcc|uic|moc|macdeployqt"
QT_APPS=$(find -E $QT_HOME/bin -type f -regex ".*/($QT_APP_FILTER)" | tr '\n' ' ')

# Qt Frameworks to link
QT_FRAMEWORKS=$(find $QT_HOME/lib -type d -name "*.framework" | tr '\n' ' ')

ANS="n"
count_apps=0

echo "[$PROG_NAME] STEP 1 - Configuring XCode and Qt Apps"

for next_app in $XCODE_APPS $QT_APPS
do
    app="$BIN_DIR/$(basename $next_app)"
    if test -f "$app" || test -h "$app"
    then
        if ! test $ANS = "a"
        then
            read -p "[$PROG_NAME] *** Application binary: \"$app\" already exists. Replace (y/n/a) ? " -n 1 ANS
            echo ' '
            ANS=$(echo $ANS | tr '[A-Z]' '[a-z]')
        fi
        if test "$ANS" = 'a' || test "$ANS" = 'y'
        then
            echo "[$PROG_NAME] *** Replacing binary: \"$app\" "
            ln -sf $next_app $app
            count_apps=$((count_apps + 1))
        else
            continue
        fi
    else
        ln -s $next_app $app
        count_apps=$((count_apps + 1))
    fi
done

echo ' '

ANS="n"
count_fws=0

echo "[$PROG_NAME] STEP 2 - Configuring Qt Frameworks "

for next_ws in $QT_FRAMEWORKS
do
    fw="$FRAMEWORKS_DIR/$(basename $next_ws)"
    if test -f "$fw" || test -h "$fw"
    then
        if ! test $ANS = "a"
        then
            read -p "[$PROG_NAME] *** Qt Framework \"$fw\" already exists! Replace (y/n/a) ? " -n 1 ANS
            echo ' '
            ANS=$(echo $ANS | tr '[A-Z]' '[a-z]')
        fi
        if test "$ANS" = 'a' || test "$ANS" = 'y'
        then
            echo "[$PROG_NAME] *** Replacing Qt Framework: \"$fw\" "
            ln -sf $next_ws $fw
            count_fws=$((count_fws + 1))
        else
            continue
        fi
    else
        ln -s $next_ws $fw
        count_fws=$((count_fws + 1))
    fi
done

echo ' '

echo "[$PROG_NAME] Configuration summary: Apps = $count_apps, Qt Frameworks = $count_fws"
echo "[$PROG_NAME] Done."
echo ' '

