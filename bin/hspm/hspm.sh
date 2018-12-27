#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090,SC2015

#  Script: dotfiles.sh
# Purpose: Manage your development tools using installation/uninstallation recipes.
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <add/remove/list> [recipe]

    Commands:
        install     [recipe]    : Install the app using the app recipe.
        uninstall   [recipe]    : Uninstall the app using the app recipe.
        list                    : List all available recipes based on HomeSetup development tools.
"

# Import pre-defined .bash_colors and .bash_env
test -f ~/.bash_colors && source ~/.bash_colors
test -f ~/.bash_env && source ~/.bash_env

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {

    test "$1" != '0' -a "$1" != '1' && printf "%s" "${RED}"
    test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
    # Unset all declared functions and recipe functions
    cleanup_recipes
    unset -f quit usage version cleanup_recipes list_recipes install_recipe uninstall_recipe
    printf "%s\n" "${NC}"
    exit "$1"
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
test "$1" = '-h' -o "$1" = '--help' && usage
test "$1" = '-v' -o "$1" = '--version' && version
test -z "$1" && usage
test -z "$2" -a "$1" != "list" && usage
test -z "$DEFAULT_DEV_TOOLS" -o ${#DEFAULT_DEV_TOOLS[*]} -le 0 && quit 1 "DEFAULT_DEV_TOOLS is not defined!"

# shellcheck disable=SC2206
ALL_RECIPES=()

cleanup_recipes() {

    unset -f about depends install uninstall
}

function list_recipes() {
    local index=0
    local recipe
    for app in ${DEFAULT_DEV_TOOLS[*]}; do
        recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-${app}.sh"
        if [ -n "$recipe" ] && [ -f "$recipe" ]; then
            ALL_RECIPES+=( "$app" )
            index=$((index+1))
            source "$recipe"
            test -z "$1" && echo -e "${index} - ${BLUE}${app} \t: $(about) ${NC}"
            cleanup_recipes
            test "$1" == "$app" && return 0
        fi
    done

    test -n "$1" && return 1 || return 0
}

install_recipe() {
    recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-$1.sh"
    if [ -f "$recipe" ]; then
        echo ''
        source "$recipe"
        install
        test $? -eq 0 && echo "${GREEN}Installation successful${NC}" || quit 1 "${RED}Failed to install app \"$1\" !${NC}"
    else
        quit 1 "${RED}Unable to find recipe for \"$1\"${NC}"
    fi
}

uninstall_recipe() {
    recipe="$HOME_SETUP/bin/hspm/recipes/$(uname -s)/recipe-$1.sh"
    if [ -f "$recipe" ]; then
        echo ''
        source "$recipe"
        uninstall
        test $? -eq 0 && echo "${GREEN}Uninstallation successful${NC}" || quit 1 "${RED}Failed to uninstall app \"$1\" !${NC}"
    else
        quit 1 "${RED}Unable to find recipe for \"$1\"${NC}"
    fi
}

shopt -s nocasematch
# Check the command line options.
case "$1" in
    # Install the app
    I | install)
        list_recipes "$2"
        test $? -eq 0 && install_recipe "$2" || quit 1 "${RED}Recipe $2 was not found!${NC}"
    ;;
    # Uninstall the app
    U | uninstall)
        list_recipes "$2"
        test $? -eq 0 && uninstall_recipe "$2" || quit 1 "${RED}Recipe $2 was not found!${NC}"
    ;;
    # List available apps
    L | list)
        echo ''
        echo "${YELLOW}Listing all available recipes ...${NC}"
        echo ''
        list_recipes
        echo ''
        echo "Found (${#ALL_RECIPES[*]}) recipes out of (${#DEFAULT_DEV_TOOLS[*]}) development tools"
    ;;
    *)
        quit 1 "${RED}Invalid option: \"$1\"${NC}"
    ;;
esac
shopt -u nocasematch

echo ''