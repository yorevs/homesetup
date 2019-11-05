#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: bash_functions.sh
# Purpose: This file is used to define some shell tools
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# Fontawesome icons
CROSS_ICN="\xef\x81\x97"
CHECK_ICN="\xef\x81\x98"
STAR_ICN="\xef\x80\x85"

# Dependencies
[ -f "$HOME/.bash_env" ] && \. "$HOME/.bash_env"
[ -f "$HOME/.bash_colors" ] && \. "$HOME/.bash_colors"
[ -f "$HOME/.bash_aliases" ] && \. "$HOME/.bash_aliases"

# Load all function files
# shellcheck disable=SC2044
for file in $(find "${HOME_SETUP}/bin/hhs-functions" -type f -name "hhs-*"); do
    \. "$file";
done;

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

# @function: Search for previous issued commands from history using filters.
# @param $1 [Req] : The searching command.
function __hhs_history() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: hist [command]"
        return 1
    elif [ "$#" -eq 0 ]; then
        history | sort -k2 -k 1,1nr | uniq -f 1 | sort -n | grep "^ *[0-9]*  "
    else
        history | sort -k2 -k 1,1nr | uniq -f 1 | sort -n | grep "$*"
    fi

    return 0
}

# @function: Move files recursively to the Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function __hhs_del-tree() {

    local all
    local dest

    if [ -z "$1" ] || [ "$1" = "/" ] || [ ! -d "$1" ]; then
        echo "Usage: del-tree <search_path> <glob_exp>"
        return 1
    else
        # Find all files and folders matching the <glob_exp>
        all=$(find -L "$1" -name "*$2" 2> /dev/null)
        # Move all to trash
        if [ -n "$all" ]; then
            read -r -n 1 -sp "${RED}### Do you want to move all files and folders matching: \"$2\" in \"$1\" recursively to Trash (y/[n]) ? " ANS
            echo ' '
            if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                echo ' '
                for next in $all; do
                    dest=${next##*/}
                    while [ -e "${TRASH}/$dest" ]; do
                        dest="${next##*/}-$(ts)"
                    done
                    mv -v "$next" "${TRASH}/$dest"
                done
            else
                echo -e "${YELLOW}If you decide to delete, the following files will be affected:${NC}"
                echo ' '
                echo "$all" | grep "$2"
            fi
            echo "${NC}"
        else
            echo ' '
            echo "${YELLOW}No files or folders matching \"$2\" were found in \"$1\" !${NC}"
            echo ' '
        fi
    fi

    return 0
}

# @function: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function __hhs_json-print() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: jp <json_string>"
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

# @function: Prints all environment variables on a separate line using filters.
# @param $1 [Opt] : Filter environments.
function __hhs_envs() {

    local pad
    local pad_len
    local filter
    local name
    local value
    local columns

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: envs [regex_filter]"
        return 1
    else
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        columns="$(($(tput cols)-pad_len-9))"
        filter="$*"
        [ -z "$filter" ] && filter="^[a-zA-Z0-9_]*.*"
        echo ' '
        echo "${YELLOW}Listing all exported environment variables matching [ $filter ]:"
        echo ' '
        (
            IFS=$'\n'
            shopt -s nocasematch
            for v in $(env | sort); do
                name=$(echo "$v" | cut -d '=' -f1)
                value=$(echo "$v" | cut -d '=' -f2-)
                if [[ ${name} =~ ${filter} ]]; then
                    echo -en "${HIGHLIGHT_COLOR}${name}${NC} "
                    printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
                    echo -n " ${GREEN}=> ${NC}${value:0:$columns} "
                    [ "${#value}" -ge "$columns" ] && echo "...${NC}" || echo "${NC}"
                fi
            done
            shopt -u nocasematch
            IFS="$RESET_IFS"
        )
        echo ' '
    fi

    return 0
}

# @function: Check the version of the app using the most common ways.
# @param $1 [Req] : The app to check.
function __hhs_version() {

    local version

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ver <appName>"
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

# @function: Check whether a tool is installed on the system.
# @param $1 [Req] : The app to check.
function __hhs_toolcheck() {

    local pad
    local pad_len
    local tool_name
    local check

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: tc <appName>"
    else
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        tool_name="$1"
        check=$(command -v "${tool_name}")
        echo -en "${ORANGE}${MY_OS}${NC} "
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
        echo "Usage: tl <log_filename>"
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
    echo -e "${YELLOW}${STAR_ICN} To check the current installed version, type: #> ${GREEN}ver <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To install/uninstall a tool, type: #> ${GREEN}hspm.sh install/uninstall <tool_name>"
    echo -e "${YELLOW}${STAR_ICN} To override the list of tools, type: #> ${GREEN}export DEV_TOOLS=( \"tool1\" \"tool2\" ... )"
    echo -e "${NC}"
    
    return 0
}

# @function: Display a process list matching the process name/expression.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function __hhs_process_list() {

    local allPids
    local pid
    local gflags='-E'

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
        echo "Usage: plist [-i,-w] <process_name> [kill]"
        echo ''
        echo 'Options: '
        echo '    -i : Make case insensitive search'
        echo '    -w : Match full words only'
        return 1
    else
        while [ -n "$1" ]
        do
            case "$1" in
                -w | --words)
                    gflags="${gflags//E/Fw}"
                ;;
                -i | --ignore-case)
                    gflags="${gflags}i"
                ;;
                *)
                    [[ ! "$1" =~ ^-[wi] ]] && break
                ;;
            esac
            shift
        done
        # shellcheck disable=SC2009,SC2086
        allPids=$(ps -efc | grep ${gflags} "$1" | awk '{ print $1,$2,$3,$8 }')
        if [ -n "$allPids" ]; then
            echo -e "${WHITE}\nUID\tPID\tPPID\tCOMMAND"
            echo '--------------------------------------------------------------------------------'
            echo -e "${RED}"
            (
                IFS=$'\n'
                for next in $allPids; do
                    pid=$(echo "$next" | awk '{ print $2 }')
                    echo -en "${HIGHLIGHT_COLOR}$next" | tr ' ' '\t'
                    if [ -n "$pid" ] && [ "$2" = "kill" ]; then 
                        kill -9 "$pid"
                        echo -e "${RED}\t\t\t\t=> Killed with signal -9"
                    else
                        ps -p "$pid" &>/dev/null && echo -e "${GREEN}**" || echo -e "${RED}**"
                    fi
                done
                IFS="$RESET_IFS"
            )
        else
            echo -e "\n${YELLOW}No active PIDs for process named: \"$1\""
        fi
    fi

    echo -e "${NC}"

    return 0
}

# @function: GIT Checkout the previous branch in history (skips branch-to-same-branch changes ).
function __hhs_git-() {

    local currBranch
    local prevBranch

    # Get the current branch.
    currBranch="$(command git rev-parse --abbrev-ref HEAD)"
    # Get the previous branch. Skip the same branch change (that is what is different from git checkout -).
    prevBranch=$(command git reflog | grep 'checkout: ' | grep -v "from $currBranch to $currBranch" | head -n1 | awk '{ print $6 }')
    command git checkout "$prevBranch"
}

# @function: Exhibit a Human readable summary about all partitions.
function __hhs_partitions() {

    local pad
    local pad_len
    local allParts
    local strText
    local mounted
    local size
    local used
    local avail
    local cap

    pad=$(printf '%0.1s' "."{1..60})
    pad_len=40
    allParts="$(df -Ha | tail -n +2)"
    (
        IFS=$'\n'
        echo "${WHITE}"
        printf '%-25s\t%-4s\t%-4s\t%-4s\t%-4s\t\n' 'Mounted-ON' 'Size' 'Used' 'Avail' 'Capacity'
        echo -e "----------------------------------------------------------------${HIGHLIGHT_COLOR}"
        for next in $allParts
        do
            strText=${next:16}
            mounted="$(echo "$strText" | awk '{ print $8 }')"
            size="$(echo "$strText" | awk '{ print $1 }')"
            used="$(echo "$strText" | awk '{ print $2 }')"
            avail="$(echo "$strText" | awk '{ print $3 }')"
            cap="$(echo "$strText" | awk '{ print $4 }')"
            printf '%-25s\t' "${mounted:0:25}"
            printf '%4s\t'  "${size:0:4}"
            printf '%4s\t'  "${used:0:4}"
            printf '%4s\t'  "${avail:0:4}"
            printf '%4s\n'  "${cap:0:4}"
        done
        echo "${NC}"
    )

    return 0
}

# @function: Check the current HomeSetup installation and look for updates.
function __hhs_update() {

    local repoVer
    local isDifferent
    local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

    if [ -n "$DOTFILES_VERSION" ]; then
        repoVer=$(curl -s -m 3 "$VERSION_URL")
        if [ -n "$repoVer" ]; then
            isDifferent=$(test -n "$repoVer" -a "$DOTFILES_VERSION" != "$repoVer" && echo 1)
            if [ -n "$isDifferent" ];then
                echo -e "${YELLOW}You have a different version of HomeSetup:"
                echo -e "  => Repository: ${repoVer} , Yours: ${DOTFILES_VERSION}."
                read -r -n 1 -sp "Update it now (y/[n]) ?" ANS
                [ -n "$ANS" ] && echo "${ANS}${NC}"
                if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                    pushd "$HOME_SETUP" &> /dev/null || return 1
                    git pull || return 1
                    popd &> /dev/null || return 1
                    if "${HOME_SETUP}"/install.sh -q; then
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
        echo "${RED}DOTFILES_VERSION was not defined !${NC}"
        return 1
    fi
    echo "${NC}"

    return 0
}
