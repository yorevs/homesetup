#!/usr/bin/env bash

#  Script: bash_functions.sh
# Purpose: Configure some shell tools
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# Purpose: Search for files recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the file search.
function sf() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1" -o -z "$2"; then
        echo "Usage: sf <search_path> <glob_exp_files>"
        return 1
    else
        echo "Searching for files matching: \"$2\" in \"$1\""
        find "$1" -type f -iname "*""$2"
    fi

    return 0
}

# Purpose: Search for directories recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the directory search.
function sd() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1" -o -z "$2"; then
        echo "Usage: sd <search_path> <glob_exp_folders>"
        return 1
    else
        echo "Searching for folders matching: \"$2\" in \"$1\""
        find "$1" -type d -iname "*""$2"
    fi

    return 0
}

# Purpose: Search for strings in files recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The searching string.
# @param $3 [Req] : The GLOB expression of the file search.
# @param $4 [Opt] : Whether to replace the findings.
# @param $5 [Con] : Required if $4 is provided. This is the replacement string.
function ss() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1" -o -z "$2" -o -z "$3"; then
        echo "Usage: ss <search_path> <string> <glob_exp_files> [--replace <replacement_text>]"
        return 1
    else
        local gflags="-HEn"
        test "$4" = "--replace" -a -n "$5" && local replace=1
        local extra_str=$(test -n "$replace" && echo ", replacement: \"$5\"")
        echo "${YELLOW}Searching for string matching: \"$2\" in \"$1\" , filenames = [$3] $extra_str ${NC}"
        test -n "$replace" && result=$(find "$1" -type f -iname "*""$3" -exec grep $gflags "$2" {} \; -exec sed -i '' -e "s/$2/$5/g" {} \;)
        test -n "$replace" || result=$(find "$1" -type f -iname "*""$3" -exec grep $gflags "$2" {} \;)
        test -n "$replace" && echo "${result//$2/$5}" | grep $gflags "$5"
        test -n "$replace" || echo "${result}" | grep $gflags "$2"
    fi

    return 0
}

# Purpose: Search for a previous issued command from history.
# @param $1 [Req] : The searching command.
function hist() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: hist <command>"
        return 1
    else
        history | grep "$1"
    fi

    return 0
}

# Purpose: Send files recursively to Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function del-tree() {

    if test -z "$1" -o "$1" = "/" -o ! -d "$1"; then
        echo "Usage: del-tree <search_path> <glob_exp>"
        return 1
    else
        # Find all files and folders matching the <glob_exp>
        local all=$(find "$1" -name "*$2")
        # Move all to trash
        if test -n "$all"; then
            read -n 1 -sp "### Move all files of type: \"$2\" in \"$1\" recursively to trash (y/[n]) ? " ANS
            if test "$ANS" = 'y' -o "$ANS" = 'Y'; then
                echo "${RED}"
                for next in $all; do
                    local dst=${next##*/}
                    while [ -e "${TRASH}/$dst" ]; do
                        dst="${next##*/}-$(now-ms)"
                    done
                    mv -v "$next" ${TRASH}/"$dst"
                done
                echo -n "${NC}"
            else
                echo "${NC}"
            fi
        fi
    fi

    return 0
}

# Purpose: Pretty print (format) JSON string.
# @param $1 [Req] : The unformatted JSON string.
function jp() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: jp <json_string>"
        return 1
    else
        echo $1 | json_pp -f json -t json -json_opt pretty indent escape_slash
    fi

    return 0
}

# Purpose: Check information about the IP.
# @param $1 [Req] : The IP to get information about.
function ip-info() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: ip-info <IPv4_address>"
        return 1
    else
        local ipinfo=$(curl --basic ip-api.com/json/$1 2>/dev/null | tr ' ' '_')
        test -n "$ipinfo" && jp $ipinfo
    fi

    return 0
}

# Purpose: Resolve domain names associated with the IP.
# @param $1 [Req] : The IP address to resolve.
function ip-resolve() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: ip-resolve <IPv4_address>"
        return 1
    else
        dig +short -x "$1"
    fi

    return 0
}

# Purpose: Lookup the DNS to determine the associated IP address.
# @param $1 [Req] : The domain name to lookup.
function ip-lookup() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: ip-lookup <domain_name>"
        return 1
    else
        host "$1"
    fi

    return 0
}

# Purpose: Check the state of a local port.
# @param $1 [Req] : The port number regex.
# @param $2 [Opt] : The port state to match. One of: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ] .
function port-check() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1" -a -z "$2"; then
        echo "Usage: port-check <portnum_regex> [state]"
        echo "States: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]"
        return 1
    elif test -n "$1" -a -z "$2"; then
        echo "Checking port \"$1\" state: \"ALL\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$1"
    else
        echo "Checking port \"$1\" state: \"$2\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$2"
    fi

    return 0
}

# Purpose: Print all environment variables.
# @param $1 [Opt] : Filter environments.
function envs() {

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: envs [regex_filter]"
        return 1
    else
        local pad=$(printf '%0.1s' "."{1..60})
        local pad_len=35
        local filter="$*"
        test -z "$filter" && filter="^[a-zA-Z0-9_]*.*"
        echo ' '
        echo "Listing all exported environment variables matching [ $filter ]:"
        echo ' '
        (
            IFS=$'\n'
            for v in $(env | sort); do
                local name=$(echo $v | cut -d '=' -f1)
                local value=$(echo $v | cut -d '=' -f2-)
                if [[ $name =~ $filter ]]; then
                    printf "${BLUE}${name}${NC} "
                    printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
                    printf " => ${value} \n"
                fi
            done
        )
        echo ' '
    fi

    return 0
}

# Purpose: Print each PATH entry on a separate line.
function paths() {

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: paths"
        return 1
    elif test -z "$1"; then
        local pad=$(printf '%0.1s' "."{1..60})
        local pad_len=60
        echo ' '
        echo 'Listing all PATH entries:'
        echo ' '
        (
            IFS=$'\n'
            for path in $(echo -e ${PATH//:/\\n}); do
                printf "$path "
                printf '%*.*s' 0 $((pad_len - ${#path})) "$pad"
                test -d "$path" && printf "${BLUE}OK${NC}\n"
                test -d "$path" || printf "${RED}DOES NOT EXIST${NC}\n"
            done
        )
        echo ''
    fi

    return 0
}

# Purpose: Check the version of the app using common ways.
# @param $1 [Req] : The app to check.
function ver() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: ver <app>"
        return 1
    else
        # First attempt: app --version
        APP=$1
        tc ${APP}
        test $? -ne 0 && return 2
        VER=$(${APP} --version 2>&1)
        if test $? -ne 0; then
            # Second attempt: app -version
            VER=$(${APP} -version 2>&1)
            if test $? -ne 0; then
                # Third attempt: app -V
                VER=$(${APP} -V 2>&1)
                if test $? -ne 0; then
                    # Last attempt: app -v
                    VER=$(${APP} -v 2>&1)
                    if test $? -ne 0; then
                        printf "${RED}Unable to find $APP version using common methods (--version, -version, -V and -v) ${NC}\n"
                        return 1
                    fi
                fi
            fi
        fi
        printf "${VER}\n"
    fi
}

# Purpose: Check if the required tool is installed on the system.
# @param $1 [Req] : The tool to check.
function tc() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: tc <app>"
        return 1
    else
        local pad=$(printf '%0.1s' "."{1..60})
        local pad_len=20
        local tool_name="$1"
        local check=$(command -v ${tool_name})
        printf "${ORANGE}($(uname -s))${NC} "
        printf "Checking: ${YELLOW}${tool_name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#1})) "$pad"
        if test -n "${check}"; then
            printf "${GREEN}INSTALLED${NC} at ${check}\n"
            return 0
        else
            printf "${RED}NOT INSTALLED${NC}\n"
            return 2
        fi
    fi
}

# Purpose: Check if the development tools are installed on the system.
function tools() {

    DEFAULT_TOOLS=(
        "bash" "brew" "tree" "vim" "pcregrep" "shfmt" "jenv"
        "node" "java" "python" "ruby" "gcc" "make" "qmake"
        "doxygen" "ant" "mvn" "gradle" "git" "svn" "cvs"
        "nvm" "npm"
    )
    DEV_APPS=${DEV_APPS:-${DEFAULT_TOOLS[@]}}

    echo ''
    for app in ${DEV_APPS[@]}; do
        tc $app
    done
    echo ''
    echo "${CYAN}To check the current installed version type: ver <tool_name>${NC}"
    echo ''
    return 0
}

# Manipulate all custom aliases.
# @param $1 [Req] : The alias name.
# @param $2 [Opt] : The alias expression.
function aa() {

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: aa [alias] [alias_expr]"
        echo "Options: "
        echo "    - List all aliases  : When both <alias> and <alias_expr> are NOT provided."
        echo "    - Add/Set an alias  : When both <alias> and <alias_expr> are provided."
        echo "    - Remove the alias  : When <alias> is provided but <alias_expr> is not provided."
        return 1
    else
        local aliasFile="$HOME/.aliases"
        touch "$aliasFile"
        local aliasName="$1"
        shift
        local aliasExpr="$*"

        if test -z "$aliasName" -a -z "$aliasExpr"; then
            # List all aliases
            local allAliases=$(cat "$aliasFile" | sort)
            if test -n "$allAliases"; then
                local pad=$(printf '%0.1s' "."{1..60})
                local pad_len=30
                (
                    IFS=$'\n'
                    echo ' '
                    echo 'Available custom aliases:'
                    echo ' '
                    for next in $allAliases; do
                        aliasName=$(echo -n "$next" | awk -F '=' '{ print $1 }')
                        aliasExpr=$(echo -n "$next" | awk -F '=' '{ print $2 }')
                        printf "${BLUE}${aliasName//alias /}"
                        printf '%*.*s' 0 $((pad_len - ${#aliasName})) "$pad"
                        echo "${WHITE} is ${aliasExpr}"
                    done
                    echo "${NC}"
                )
            else
                echo "${YELLOW}No aliases were found in \"$aliasFile\" !${NC}"
            fi
        elif test -n "$aliasName" -a -n "$aliasExpr"; then
            # Add/Set one alias
            sed -i '' -E -e "s#(alias $aliasName=.*)?##g" -e '/^\s*$/d' "$aliasFile"
            echo "alias $aliasName='$aliasExpr'" >>"$aliasFile"
            echo "${GREEN}Alias set: ${WHITE}\"$aliasName\" is ${BLUE}'$aliasExpr' ${NC}"
            source "$aliasFile"
        elif test -n "$aliasName" -a -z "$aliasExpr"; then
            # Remove one alias
            sed -i '' -E -e "s#(alias $aliasName=.*)?##g" -e '/^\s*$/d' "$aliasFile"
            echo "${YELLOW}Alias removed: ${WHITE}\"$aliasName\" ${NC}"
            unalias "$aliasName"
        fi
    fi

    # Remove all duplicates
    local contents=$(cat "$aliasFile" | awk '!arr[$0]++')
    echo "$contents" >"$aliasFile"

    return 0
}

# Purpose: Save the current directory to be loaded by `load`.
# @param $1 [Opt] : The directory path to save.
# @param $2 [Opt] : The alias to access the directory saved.
function save() {

    local dir=$(pwd)
    local dirAlias="SAVED_DIR"
    local savedDirs="$HOME/.saved_dir"

    test -n "$2" && dirAlias=$(echo -n "$2" | tr -s [:space:] '_' | tr [:lower:] [:upper:])
    test -z "$dirAlias" && dirAlias="SAVED_DIR"

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: save [-e,-r,-c] | [dir_to_save] [dir_alias]"
        echo "Options: "
        echo "    -e : Edit saved dirs."
        echo "    -r : Remove saved dir."
        echo "    -c : Clear all saved dirs."
        return 1
    elif test "$1" = "-e"; then
        vi "$savedDirs"
    elif test "$1" = "-r"; then
        sed -i '' -E -e "s#($dirAlias=.*)?##" -e '/^\s*$/d' "$savedDirs"
        echo "${YELLOW}Directory removed: ${WHITE}\"$dirAlias\" ${NC}"
    elif test "$1" = "-c"; then
        echo '' >"$savedDirs"
        echo "${YELLOW}All saved directories have been removed!${NC}"
    else
        test -n "$1" -a ! -d "$1" && echo "${RED}Directory \"$1\" is not a valid!${NC}" && return 1
        test -z "$1" -o "$1" = "." && dir=${1//./$(pwd)}
        test -n "$1" -a "$1" = ".." && dir=${1//../$(pwd)}
        test -n "$1" -a "$1" = "-" && dir=${1//-/$OLDPWD}
        touch "$savedDirs"
        sed -i '' -E -e "s#($dirAlias=.*)?##" -e '/^\s*$/d' "$savedDirs"
        echo "$dirAlias=$dir" >>"$savedDirs"
        echo "${GREEN}Directory saved: ${WHITE}\"$dir\" as ${BLUE}$dirAlias ${NC}"
    fi

    # Remove all duplicates
    local contents=$(cat "$savedDirs" | awk '!arr[$0]++')
    echo "$contents" >"$savedDirs"

    return 0
}

# Purpose: cd into the saved directory issued by `save`.
# @param $1 [Opt] : The alias to access the directory saved.
function load() {

    local dirAlias="SAVED_DIR"
    local savedDirs="$HOME/.saved_dir"

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: load [-l] | [dir_alias]"
        echo "Options: "
        echo "    -l : List all saved dirs."
        return 1
    elif test "$1" = "-l"; then
        local allDirs=$(cat "$savedDirs" | sort)
        if test -n "$allDirs"; then
            local pad=$(printf '%0.1s' "."{1..60})
            local pad_len=20
            (
                IFS=$'\n'
                echo ' '
                echo 'Available saved directories:'
                echo ' '
                for next in $allDirs; do
                    dirAlias=$(echo -n "$next" | awk -F '=' '{ print $1 }')
                    dir=$(echo -n "$next" | awk -F '=' '{ print $2 }')
                    printf "${BLUE}${dirAlias}"
                    printf '%*.*s' 0 $((pad_len - ${#dirAlias})) "$pad"
                    echo "${WHITE}${dir}"
                done
                echo "${NC}"
            )
        else
            echo "${YELLOW}No directories were saved yet \"$savedDirs\" !${NC}"
        fi
        return 0
    else
        test -n "$1" && dirAlias=$(echo -n "$1" | tr -s '-' '_' | tr -s [:space:] '_' | tr [:lower:] [:upper:])
        test -z "$dirAlias" && dirAlias="SAVED_DIR"
        local dir=$(grep "$dirAlias" $savedDirs | awk -F '=' '{ print $2 }')
        test -n "$dir" -a -d "$dir" && cd "$dir"
        test -z "$dir" -o ! -d "$dir" && echo "${RED}Directory ($dirAlias): \"$dir\" was not found${NC}" && return 1
    fi

    echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"

    return 0
}

# Purpose: Punch the Clock: Format = DDD dd-mm-YYYY => HH:MM HH:MM ...
function punch() {

    if test "$1" = "-h" -o "$1" = "--help"; then
        echo "Usage: punch [-l,-e,-r]"
        echo "Options: "
        echo "       : !!PUNCH THE CLOCK!! (When no option s provided)."
        echo "    -l : List all registered punches."
        echo "    -e : Edit current punch file."
        echo "    -r : Reset punches for the next week."
        return 1
    else
        (
            IFS=$'\n'
            OPT="$1"
            PUNCH_FILE=${PUNCH_FILE:-$HOME/.punchs}
            local dateStamp="$(date +'%a %d-%m-%Y')"
            local timeStamp="$(date +'%H:%M')"
            local weekStamp="$(date +%V)"
            local re="($dateStamp).*"
            # Create the punch file if it does not exist
            test -f "$PUNCH_FILE" || echo "$dateStamp => " >"$PUNCH_FILE"
            # List punchs
            test "-l" = "$OPT" && cat "$PUNCH_FILE" && return 0
            # Edit punchs
            test "-e" = "$OPT" && vi "$PUNCH_FILE" && return 0
            # Reset punchs (backup as week-N.punch)
            test "-r" = "$OPT" && mv -f "$PUNCH_FILE" "$(dirname $PUNCH_FILE)/week-$weekStamp.punch" && return 0
            # Do the punch
            if test -z "$OPT"; then
                lines=$(grep . "$PUNCH_FILE")
                success=0
                for line in $lines; do
                    if [[ "$line" =~ $re ]]; then
                        sed -E -e "s#($dateStamp) => (.*)#\1 => \2$timeStamp #g" -i .bak "$PUNCH_FILE"
                        success=1
                    fi
                done
                test "$success" = "1" || echo "$dateStamp => $timeStamp " >>"$PUNCH_FILE"
                grep "$dateStamp" "$PUNCH_FILE" | sed "s/$dateStamp/Today/g"
            fi
        )
    fi

    return 0
}

# Purpose: Display a process list of the given process name, killing them if specified.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function plist() {

    if test "$1" = "-h" -o "$1" = "--help" -o -z "$1"; then
        echo "Usage: plist <process_name> [kill]"
        return 1
    else
        local pids=$(ps -efc | grep "$1" | awk '{ print $1,$2,$3,$8 }')
        if test -n "$pids"; then
            test "$2" = "kill" || echo -e "${GREEN}\nUID\tPID\tPPID\tCOMMAND\n---------------------------------------------------------------------------------"
            test "$2" = "kill" && echo ''
            (
                IFS=$'\n'
                for next in $pids; do
                    local p=$(echo $next | awk '{ print $2 }')
                    test "$2" = "kill" || echo -e "${BLUE}$next${NC}" | tr ' ' '\t'
                    test -n "$p" -a "$2" = "kill" && kill -9 "$p" && echo "${RED}Killed process with PID = $p ${NC}"
                done
            )
            echo ''
        else
            echo -e "\n${YELLOW}No active PIDs for process named: $1 ${NC}\n"
        fi
    fi

    return 0
}

# Check the latest dotfiles version
function dv() {

    if test -n "$DOTFILES_VERSION"; then
        local v=$(curl -s -m 3 https://raw.githubusercontent.com/yorevs/homesetup/master/VERSION)
        local newer=$(test -n "$v" -a "$DOTFILES_VERSION" != "$v" && echo 1)
        test -n "$newer" && echo -e "${YELLOW}You have a different version of HomeSetup:\n  => Repository: ${v} , Yours: ${DOTFILES_VERSION}.${NC}"
        test -n "$newer" || echo -e "${GREEN}You version is up to date: ${v} !${NC}"
    else
        echo "${RED}DOTFILES_VERSION is not defined${NC}"
        return 1
    fi

    return 0
}
