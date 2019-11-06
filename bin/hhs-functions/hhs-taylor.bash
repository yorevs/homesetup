#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-taylor.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Tail a log using colors specified in .tailor file.
# @param $1 [Req] : The log file name.
function __hhs_tailor() {

    echo -e "
    THREAD_NAME_RE=\"\[ ?(.*main.*|Thread-[0-9]*) ?\] \"
    THREAD_NAME_STYLE=\"${VIOLET}\"
    FQDN_RE=\"(([a-zA-Z][a-zA-Z0-9]*\.)+[a-zA-Z0-9]*)\"
    FQDN_STYLE=\"${CYAN}\"
    LOG_LEVEL_RE=\"INFO|DEBUG|FINE\"
    LOG_LEVEL_STYLE=\"${BLUE}\"
    LOG_LEVEL_WARN_RE=\"WARN|WARNING\"
    LOG_LEVEL_WARN_STYLE=\"${YELLOW}\"
    LOG_LEVEL_ERR_RE=\"SEVERE|FATAL|ERROR\"
    LOG_LEVEL_ERR_STYLE=\"${RED}\"
    DATE_FMT_RE=\"([0-9]{2,4}\-?)* ([0-9]{2}\:?)+\.[0-9]{3}\"
    DATE_FMT_STYLE=\"${DIM}\"
    URI_FMT_RE=\"(([a-zA-Z0-9+.-]+:\/|[a-zA-Z0-9+.-]+)?\/([a-zA-Z0-9.\-_/]*)(:([0-9]+))?\/?([a-zA-Z0-9.\-_/]*)?)\"
    URI_FMT_STYLE=\"${ORANGE}\"
    " > "$HHS_DIR/.tailor" && \. "$HHS_DIR/.tailor"

    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "Usage: ${FUNCNAME[0]} <log_filename>"
        return 1
    else
        tail -n 20 -F "$1" | sed -E \
            -e "s/(${THREAD_NAME_RE})/${THREAD_NAME_STYLE}\1${NC}/" \
            -e "s/(${FQDN_RE})/${FQDN_STYLE}\1${NC}/" \
            -e "s/(${LOG_LEVEL_RE})/${LOG_LEVEL_STYLE}\1${NC}/" \
            -e "s/(${LOG_LEVEL_WARN_RE})/${LOG_LEVEL_WARN_STYLE}\1${NC}/" \
            -e "s/(${LOG_LEVEL_ERR_RE})/${LOG_LEVEL_ERR_STYLE}\1${NC}/" \
            -e "s/(${DATE_FMT_RE})/${DATE_FMT_STYLE}\1${NC}/" \
            -e "s/(${URI_FMT_RE})/${URI_FMT_STYLE}\1${NC}/"
        return $?
    fi
}