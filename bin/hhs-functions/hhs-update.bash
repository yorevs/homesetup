#!/usr/bin/env bash

#  Script: hhs-paths.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Check the current HomeSetup installation and look for updates.
function __hhs_update() {

    local repoVer isDifferent
    local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} "
    else
        if [ -n "$HHS_VERSION" ]; then
            repoVer=$(curl -s -m 3 "$VERSION_URL")
            if [ -n "$repoVer" ]; then
                isDifferent=$(test -n "$repoVer" -a "$HHS_VERSION" != "$repoVer" && echo 1)
                if [ -n "$isDifferent" ];then
                    echo -e "${YELLOW}You have a different version of HomeSetup: "
                    echo -e "=> Repository: ${repoVer} , Yours: ${HHS_VERSION}"
                    read -r -n 1 -sp "Would you like to update it now (y/[n]) ?" ANS
                    [ -n "$ANS" ] && echo "${ANS}${NC}"
                    if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                        pushd "$HHS_HOME" &> /dev/null || return 1
                        git pull || return 1
                        popd &> /dev/null || return 1
                        if "${HHS_HOME}"/install.bash -q; then
                        echo -e "${GREEN}Successfully updated HomeSetup!"
                        sleep 2
                        reload
                        else
                            echo -e "${RED}Failed to install HomeSetup update !${NC}"
                            return 1
                        fi
                    fi
                else
                    echo -e "${GREEN}You version is up to date v${repoVer} !"
                fi
            else
                echo "${RED}Unable to fetch repository version !${NC}"
                return 1
            fi
        else
            echo "${RED}HHS_VERSION was not defined !${NC}"
            return 1
        fi
        echo "${NC}"
    fi

    return 0
}
