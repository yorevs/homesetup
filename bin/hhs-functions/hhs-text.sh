#!/usr/bin/env bash

#  Script: hhs-text.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Highlight words from the piped stream.
# @param $1 [Req] : The word to highlight.
# @param $1 [Pip] : The piped input stream.
function __hhs_highlight() {

    local search="$*"
    local hl_color=${HIGHLIGHT_COLOR//\e[/}
    hl_color=${HIGHLIGHT_COLOR/m/}

    while read -r stream; do
        echo "$stream" | GREP_COLOR="$hl_color" grep -FE "($search|\$)"
    done
}

# @function: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function __hhs_json-print() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ${FUNCNAME[0]} <json_string>"
        return 1
    else
        if [ "${MY_OS}" = 'Darwin' ]; then
            echo "$1" | json_pp -f json -t json -json_opt pretty indent escape_slash
        else
            grep . "$1" | json_pp
        fi
    fi

    return 0
}