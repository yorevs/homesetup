#!/bin/bash

################################################################################
# C-Shell: apply-osx-theme.sh
# Purpose: Install OSX theme on Linux.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 12, 2013
################################################################################

PROG_NAME=$(basename $0 | cut -d "." -f 1)

if ! test "$(uname -s)" = "Linux"
then 
    echo "[$PROG_NAME] ### Error, This is intended for Linux only !"
    exit 0
fi

if ! test "$(whoami)" = "root"
then
    echo "[$PROG_NAME] ### Error, Need root access to use this script !"
    exit 1
fi


echo "[$PROG_NAME] Disabling overlay scrollbar."
gsettings set com.canonical.desktop.interface scrollbar-mode normal

echo "[$PROG_NAME] Disabling 'send error notification' ."
sudo sed -i "s/enabled=1/enabled=0/g" '/etc/default/apport'

echo "[$PROG_NAME] TODO: Removing white Ubuntu dots"
#sudo xhost +SI:localuser:lightdm
#sudo su lightdm -s /bin/bash
#gsettings set com.canonical.unity-greeter draw-grid false;exit
#sudo mv /usr/share/unity-greeter/logo.png /usr/share/unity-greeter/logo.png.backup

echo "[$PROG_NAME] Downloading OSX walpapers."
test -f "Mac-XBuntu-Wallpapers.zip" || wget http://goo.gl/EgMSp

echo "[$PROG_NAME] Donwloading OSX theme for Firefox"
test -f "Mac-os-theme-firefox.zip" || wget http://goo.gl/jY32o

echo "[$PROG_NAME]  Installing indicator synapse."
sudo add-apt-repository ppa:noobslab/apps
sudo apt-get update
sudo apt-get install indicator-synapse

echo "[$PROG_NAME]  Adding PPA repository [Docky] and installing ..."
sudo add-apt-repository ppa:docky-core/ppa
sudo apt-get update
sudo apt-get install docky
wget http://drive.noobslab.com/data/Mac-14.04/Mac-OS-Lion%28Docky%29.tar

echo "[$PROG_NAME]  Adding PPA repository [Mac-Theme] and installing ..."
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install mac-ithemes-v3
sudo apt-get install mac-icons-v3

echo "[$PROG_NAME]  Installing Mac [Splash] theme ..."
sudo apt-get install mbuntu-bscreen-v3

echo "[$PROG_NAME]  Installing Mac [Login] theme ..."
sudo apt-get install mbuntu-lightdm-v3

echo "[$PROG_NAME]  Customizing Mac [Menu] theme ..."
cd && wget -O Mac.po http://drive.noobslab.com/data/Mac-14.04/change-name-on-panel/mac.po
cd /usr/share/locale/en/LC_MESSAGES; sudo msgfmt -o unity.mo ~/Mac.po;rm ~/Mac.po;cd

echo "[$PROG_NAME]  Installing Mac [Logo] theme ..."
wget -O launcher_bfb.png http://drive.noobslab.com/data/Mac-14.04/launcher-logo/apple/launcher_bfb.png
sudo mv launcher_bfb.png /usr/share/unity/icons/

echo "[$PROG_NAME]  Installing Mac [Fonts] theme ..."
wget -O mac-fonts.zip http://drive.noobslab.com/data/Mac-14.04/macfonts.zip
sudo unzip mac-fonts.zip -d /usr/share/fonts; rm mac-fonts.zip
sudo fc-cache -f -v

chown -hR hugo:hugo .

echo "[$PROG_NAME] Apply the apple theme, logout and logon !"
echo "[$PROG_NAME] Done."

