#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090,SC2015

#  Script: hspm.sh
# Purpose: Manage your development tools using installation/uninstallation recipes.
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <install/uninstall/list> [recipe]

    Commands:
        install     [recipe]    : Install the app using the app recipe.
        uninstall   [recipe]    : Uninstall the app using the app recipe.
        list                    : List all available recipes based on HomeSetup development tools.
"

# Import bash stuff
[ -f "$HOME/.bash_functions" ] && \. "$HOME/.bash_functions"

# Unset all declared functions from the recipes
cleanup_recipes() {

    unset -f about depends install uninstall
}

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {

    cleanup_recipes
    unset -f quit usage version cleanup_recipes list_recipes install_recipe uninstall_recipe
    ret=$1
    shift
    [ "$ret" -gt 1 ] && printf "%s" "${RED}"
    [ "$#" -gt 0 ] && printf "%s" "$*"
    # Unset all declared functions
    printf "%s\n" "${NC}"
    exit "$ret"
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Version message.
version() {
    quit 1 "$VERSION"
}

# Check if the user passed the help or version parameters.
[ "$1" = '-h' ] || [ "$1" = '--help' ] && usage 0
[ "$1" = '-v' ] || [ "$1" = '--version' ] && version
[ "$#" -lt 1 ] && usage 1
[ "$#" -eq 1 ] && [ "$1" != "list" ] && usage 1

[ -z "$DEFAULT_DEV_TOOLS" ] || [ ${#DEFAULT_DEV_TOOLS[*]} -le 0 ] && quit 1 "DEFAULT_DEV_TOOLS variable is undefined!"

# shellcheck disable=SC2206
ALL_RECIPES=()

# shellcheck disable=2155,SC2059,SC2183
function list_recipes() {

    local index=0
    local pad=$(printf '%0.1s' "."{1..60})
    local pad_len=20
    local recipe

    for app in ${DEFAULT_DEV_TOOLS[*]}; do
        recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-${app}.sh"
        if [ -n "$recipe" ] && [ -f "$recipe" ]; then
            ALL_RECIPES+=( "$app" )
            index=$((index+1))
            \. "$recipe"
            if test -z "$1"; then
                printf '%3s - %s' "${index}" "${BLUE}${app} "
                printf '%*.*s' 0 $((pad_len - ${#app})) "$pad"
                printf "%s\n" ": ${WHITE}$(about) ${NC}"
            fi
            cleanup_recipes
            [ "$1" == "$app" ] && return 0
        fi
    done

    [ -n "$1" ] && return 1 || return 0
}

# Install the specified app using the installation recipe
install_recipe() {

    recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-$1.sh"
    if [ -f "$recipe" ]; then
        echo ''
        \. "$recipe"
        if command -v "$1" > /dev/null; then
            quit 1 "${YELLOW}\"$1\" is already installed on the system!${NC}"
        fi
        printf "%s\n" "${YELLOW}Installing \"$1\", please wait...${NC}"
        install
        test $? -eq 0 && printf "%s\n" "${GREEN}Installation successful.${NC}" || quit 2 "Failed to install app \"$1\" !"
    else
        quit 1 "Unable to find recipe for \"$1\" !"
    fi
}

# Uninstall the specified app using the uninstallation recipe
uninstall_recipe() {

    recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-$1.sh"
    if [ -f "$recipe" ]; then
        echo ''
        \. "$recipe"
        if ! command -v "$1" > /dev/null; then
            quit 1 "${YELLOW}\"$1\" is not installed on the system!${NC}"
        fi
        printf "%s\n" "${YELLOW}Uninstalling $1, please wait...${NC}"
        uninstall
        test $? -eq 0 && printf "%s\n" "${GREEN}Uninstallation successful.${NC}" || quit 2 "Failed to uninstall app \"$1\" !"
    else
        quit 2 "Unable to find recipe for \"$1\" !"
    fi
}

shopt -s nocasematch
# Check the command line options.
case "$1" in
    # Install the app
    I | install)
        list_recipes "$2"
        test $? -eq 0 && install_recipe "$2" || quit 2 "Recipe for app \"$2\" was not found!"
    ;;
    # Uninstall the app
    U | uninstall)
        list_recipes "$2"
        test $? -eq 0 && uninstall_recipe "$2" || quit 2 "Recipe for app \"$2\" was not found!"
    ;;
    # List available apps
    L | list)
        echo ''
        printf "%s\n" "${YELLOW}Listing all available recipes ...${NC}"
        echo ''
        list_recipes
        echo ''
        echo "Found (${#ALL_RECIPES[*]}) recipes out of (${#DEFAULT_DEV_TOOLS[*]}) development tools"
    ;;
    *)
        quit 2 "Invalid option: \"$1\""
    ;;
esac
shopt -u nocasematch

echo ''