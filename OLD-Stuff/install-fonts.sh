#!/bin/bash

################################################################################
# C-Shell: install-fonts.sh
# Purpose: Install user fonts to the system.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 12, 2013
################################################################################

HOME=${HOME:-~/}

HOME_DBFONT=$HOME/Dropbox/Fonts

HOME_FONT=$HOME/.fonts/ttf-fonts

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] Instaling fonts from $HOME_DBFONT to $HOME_FONT"

mkdir -p $HOME_FONT

chmod 644 $HOME_DBFONT/*.ttf
count_fnt=0

FONTS="$(find $HOME_DBFONT -type f -name '*.ttf')"

for next_font in $FONTS
do
    lowercase=$(basename $next_font | tr '[A-Z]' '[a-z]')
    mv -f "$next_font" "$HOME_DBFONT/$lowercase"
    count_fnt=$((count_fnt + 1))
done

echo "[$PROG_NAME] Copying and installing all ttf fonts ..."
cp -f $HOME_DBFONT/*.ttf $HOME_FONT

echo "[$PROG_NAME] Refreshing fonts cache ..."
echo ' '
sudo fc-cache -f -v

echo "[$PROG_NAME] Install Fonts summary: Fonts = $count_fnt"
echo "[$PROG_NAME] Done."
echo ' '
