#!/bin/bash

################################################################################
# C-Shell: install-linux-apps.sh
# Purpose: Install preferred linux applications on the system.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 12, 2013
################################################################################

PROG_NAME=$(basename $0 | cut -d "." -f 1)

if ! test "$(uname -s)" = "Linux"
then 
    echo "[$PROG_NAME] ### Error, This is intended for Linux only !"
    exit 1
fi

if ! test "$(whoami)" = "root"
then
    echo "[$PROG_NAME] ### Error, Need root access to use this script !"
    exit 1
fi


# Undesired apps.
TO_BE_REMOVED='openjdk-7-jdk brasero libreoffice*.* thunderbird*'

# Development apps.

# GCC, SVN, CVS, MAKE, ...
DEV_APPS='build-essential dialog doxygen-latex doxygen valgrind subversion rapidsvn git '
# Python stuff
PYTHON_APPS='python-qt5 python-numpy python-gnuplot python-webkit python-opengl python-sip python-qt5-gl python-qwt5-qt4 python-serial python-qt4-dev python-awn python-awn-extras python-gpgme'
# QT Stuff
QT='qt4-dev-tools libqt4-dev libqt4-core libqt4-gui'
# Common build tools
DEV_LIBS='bison flex libncurses5-dev automake autoconf libtool texinfo gettext'
# Java
ORACLE_JDK='oracle-java7-installer'

# Utilities apps.
UTIL_APPS='vim flashplugin-installer nmap ssh ckermit atftpd mtd-tools gparted evolution'

# Nautilus extensions apps.
NAUTILUS_EXT_APPS='nautilus-scripts-manager nautilus-image-manipulator nautilus-open-terminal nautilus-sendto nautilus-image-converter nautilus-script-audio-convert'

# Desktop apps.
DESKTOP_APPS='dropbox ktimer parcellite k3b chromium-browser gnome-do gnome-do-plugins gnome-tweak-tool unity-tweak-tool'

# Need to add ppa's prior to installing them
AWN='awn-settings avant-window-navigator awn-applets-all'

# Ubuntu extras.
EXTRA_APPS='ubuntu-restricted-extras ubuntu-tweak compizconfig-settings-manager'

# All Apps.
ALL_APPS="$EXTRA_APPS $NAUTILUS_EXT_APPS $AWN $UTIL_APPS $DESKTOP_APPS $DEV_APPS $QT $PYTHON_APPS $DEV_LIBS $ORACLE_JDK"

# PPAs needed by extra apps.

# Nautilus Actions Extra PPA
NAE_PPA='ppa:nae-team/ppa'

# Ubuntu Tweak
TWEAK_PPA='ppa:tualatrix/ppa'

# Java PPA
JAVA_PPA='ppa:webupd8team/java'

# AWN PPA
AWN_PPA='ppa:awn-testing/ppa'

# ALL PPA's
ALL_PPAS="$NAE_PPA $TWEAK_PPA $AWN_PPA $JAVA_PPA"

add_ppas() {

    # Add all PPA's
    echo "[$PROG_NAME] Adding PPA's..."
    ans=""

    for next in $ALL_PPAS
    do
        if test "$ans" != "a"
        then
            read -n 1 -p "Add repository $next (y/n/a)? " ans
            echo " "
        fi
        if test "$ans" = "a" || test "$ans" = "y" || test "$ans" = "Y"
        then
            sudo add-apt-repository -y $next
        fi
    done
}


update_repos() {

    # Update repositories and apps.
    echo "[$PROG_NAME] Updating repositories and installig updates..."
    export update='update'
    sudo apt-get update && sudo apt-get upgrade

}


remove_apps() {

    # Remove undesired apps.
    echo "[$PROG_NAME] Removing undesired apps..."
    ans=""

    for next in $TO_BE_REMOVED
    do
        if test "$ans" != "a"
        then
            read -n 1 -p "Remove application $next (y/n/a)? " ans
            echo " "
        fi
        if test "$ans" = "a" || test "$ans" = "y" || test "$ans" = "Y"
        then
            sudo apt-get remove --purge -y $next && sudo apt-get -y autoremove
        fi
    done
}


install_apps() {

    # Install apps.
    echo "[$PROG_NAME] Installing apps..."
    ans=""

    for next in $ALL_APPS
    do
        if test "$ans" != "a"
        then
            read -n 1 -p "Install application $next (y/n/a)? " ans
            echo " "
        fi
        if test "$ans" = "a" || test "$ans" = "y" || test "$ans" = "Y"
        then
            sudo apt-get install -y $next
        fi
    done
}

doTheJob() {

    echo "[$PROG_NAME] Installing Ubuntu applications ..."
    add_ppas
    update_repos
    remove_apps
    install_apps

}

doTheJob

echo "[$PROG_NAME] Done."
echo ' '

