#!/usr/bin/env bash

#  Script: hhs-aliases.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Manipulate custom aliases (add/remove/edit/list).
# @param $1 [Req] : The alias name.
# @param $2 [Opt] : The alias expression.
function __hhs_aliases() {

    local aliasFile
    local aliasName
    local aliasExpr
    local pad
    local pad_len
    local allAliases
    local isSorted=0

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} [-s|--sort] [alias] [alias_expr]"
        echo ''
        echo 'Options: '
        echo '           -e | --edit    : Edit the aliases file.'
        echo '           -s | --sort    : Sort results ASC.'
        echo '      List all aliases    : When both [alias] and [alias_expr] are NOT provided.'
        echo '      Add/Set an alias    : When both [alias] and [alias_expr] are provided.'
        echo '      Remove the alias    : When [alias] is provided but [alias_expr] is not provided.'
        return 1
    else
        aliasFile="$HOME/.aliases"
        touch "$aliasFile"
        test "$1" = '-e' -o "$1" = "--edit" && vi "$aliasFile" && return 0
        test "$1" = '-s' -o "$1" = "--sort" && isSorted=1 && shift

        aliasName="$1"
        shift
        aliasExpr="$*"

        if [ -z "$aliasName" ] && [ -z "$aliasExpr" ]; then
            # List all aliases
            test "$isSorted" = "0" && allAliases=$(grep . "$aliasFile") || allAliases=$(grep . "$aliasFile" | sort)
            if [ -n "$allAliases" ]; then
                pad=$(printf '%0.1s' "."{1..60})
                pad_len=40
                echo ' '
                echo "${YELLOW}Available custom aliases:"
                echo ' '
                (
                    local name
                    local expr
                    local columns="$(($(tput cols)-pad_len-18))"
                    IFS=$'\n'
                    for next in $allAliases; do
                        local re='^alias .+=.+'
                        if [[ $next =~ $re ]]; then
                            name=$(echo -n "$next" | cut -d'=' -f1 | cut -d ' ' -f2)
                            expr=$(echo -n "$next" | cut -d'=' -f2-)
                            printf "${HIGHLIGHT_COLOR}${name//alias /}"
                            printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
                            printf '%s' "${YELLOW} is aliased to ${WHITE}${expr:0:$columns}"
                        else
                            printf '%s' "${GREEN}${next:0:$columns}${NC}"
                        fi
                        [ "${#expr}" -ge "$columns" ] && echo "..."
                        printf '%s\n' "${NC}"
                    done
                    IFS="$RESET_IFS"
                )
                printf '%s\n' "${NC}"
            else
                printf '%s\n' "${ORANGE}No aliases were found in \"$aliasFile\" !${NC}"
            fi
        elif [ -n "$aliasName" ] && [ -n "$aliasExpr" ]; then
            # Add/Set one alias
            ised -e "s#(^alias $aliasName=.*)*##g" -e '/^\s*$/d' "$aliasFile"
            echo "alias $aliasName='$aliasExpr'" >>"$aliasFile"
            printf '%s\n' "${GREEN}Alias set: ${WHITE}\"$aliasName\" is ${HIGHLIGHT_COLOR}'$aliasExpr' ${NC}"
            # shellcheck disable=SC1090
            \. "$aliasFile"
        elif [ -n "$aliasName" ] && [ -z "$aliasExpr" ]; then
            # Remove one alias
            unalias "$aliasName" &> /dev/null
            ised -e "s#(^alias $aliasName=.*)*##g" -e '/^\s*$/d' "$aliasFile"
            printf '%s\n' "${YELLOW}Alias removed: ${WHITE}\"$aliasName\" ${NC}"
        fi
    fi

    return 0
}