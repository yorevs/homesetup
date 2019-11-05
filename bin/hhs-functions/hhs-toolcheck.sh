#!/usr/bin/env bash

#  Script: hhs-toolcheck.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Check whether a tool is installed on the system.
# @param $1 [Req] : The app to check.
function __hhs_toolcheck() {

    local pad
    local pad_len
    local tool_name
    local check

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ${FUNCNAME[0]} <appName>"
    else
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        tool_name="$1"
        check=$(command -v "${tool_name}")
        echo -en "${ORANGE}[${MY_OS}]${NC} "
        echo -en "Checking: ${YELLOW}${tool_name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#tool_name})) "$pad"
        if has "${tool_name}"; then
            echo -e "${GREEN} ${CHECK_ICN} INSTALLED${NC} at ${check}"
            return 0
        else
            echo -e "${RED} ${CROSS_ICN} NOT INSTALLED${NC}"
        fi
    fi

    return 1
}

# @function: Check the version of the app using the most common ways.
# @param $1 [Req] : The app to check.
function __hhs_version() {

    local version

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ${FUNCNAME[0]} <appName>"
        return 1
    else
        # First attempt: app --version
        APP=$1
        __hhs_toolcheck "${APP}"
        if test $? -ne 0; then
            printf '%s\n' "${RED}Can't check version. \"${APP}\" is not installed on the system! ${NC}"
            return 2
        fi
        version=$(${APP} --version 2>&1)
        if test $? -ne 0; then
            # Second attempt: app -v
            version=$(${APP} -v 2>&1)
            if test $? -ne 0; then
                # Third attempt: app -version
                version=$(${APP} -version 2>&1)
                if test $? -ne 0; then
                    # Last attempt: app -V
                    version=$(${APP} -V 2>&1)
                    if test $? -ne 0; then
                        printf '%s\n' "${RED}Unable to find \"${APP}\" version using common methods: (--version, -version, -v and -V) ${NC}"
                        return 1
                    fi
                fi
            fi
        fi
        printf '%s\n' "${version}"
    fi

    return 0
}

# @function: Check whether a list of development tools are installed.
function __hhs_tools() {

    DEV_TOOLS=${DEV_TOOLS:-${DEV_TOOLS[*]}}
    # shellcheck disable=SC2207
    IFS=$'\n' sorted=($(sort <<<"${DEV_TOOLS[*]}"))
    IFS="$RESET_IFS"

    echo ''
    for app in ${sorted[*]}; do
        __hhs_toolcheck "$app"
    done
    echo ''
    echo -e "${YELLOW}${STAR_ICN} To check the current installed version, type: ${GREEN}#> ver <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To install/uninstall a tool, type: ${GREEN}#> hspm.sh install/uninstall <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To override the list of tools, type: ${GREEN}#> export DEV_TOOLS=( \"tool1\" \"tool2\" ... )"
    echo -e "${NC}"
    
    return 0
}