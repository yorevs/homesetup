#!/usr/bin/env bash
# shellcheck disable=SC1117
# shellcheck disable=SC2059
# shellcheck disable=SC2183

#  Script: bash_functions.sh
# Purpose: Configure some shell tools
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# !NOTICE: Do not change this file. To customize your aliases edit the file ~/.functions


# Purpose: GPG encryption.
# @param $1 [Req] : The file to encrypt.
# @param $2 [Req] : The passphrase to encrypt the file.
# @param $3 [Opt] : If provided, keeps the decrypted file, delete it otherwise.
function encrypt() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
        echo "Usage: encrypt <file_name> <passphrase>"
        return 1
    elif [ -n "$(command -v gpg)" ]; then
        gpg --yes --batch --passphrase="$2" -c "$1" &> /dev/null;
        if test $? -eq 0; then
            echo -e "${GREEN}File \"$1\" has been encrypted!${NC}"
            encode -i "$1.gpg" -o "$1"
            rm -f "$1.gpg"
            return 0
        fi
    else
        echo -e "${RED}gpg is required to execute this command!${NC}"
    fi

    echo -e "${RED}Unable to encrypt file: \"$1\" ${NC}"

    return 1
}

# Purpose: GPG decryption.
# @param $1 [Req] : The file to decrypt.
# @param $2 [Req] : The passphrase to decrypt the file.
# @param $3 [Opt] : If provided, keeps the encrypted file, delete it otherwise.
function decrypt() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 2 ]; then
        echo "Usage: decrypt <file_name> <passphrase>"
        return 1
    elif [ -n "$(command -v gpg)" ]; then
        decode -i "$1" -o "$1.gpg"
        gpg --yes --batch --passphrase="$2" "$1.gpg" &> /dev/null;
        if test $? -eq 0; then
            echo -e "${GREEN}File \"$1\" has been decrypted!${NC}"
            rm -f "$1.gpg"
            return 0
        fi
    else
        echo -e "${RED}gpg is required to execute this command!${NC}"
    fi

    echo -e "${RED}Unable to decrypt file: \"$filename\" ${NC}"

    return 1
}

# Purpose: Search for files recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the file search.
function sf() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
        echo "Usage: sf <search_path> <glob_exp_files>"
        return 1
    else
        echo "Searching for files matching: \"$2\" in \"$1\""
        find "$1" -type f -iname "*""$2"
        return $?
    fi
}

# Purpose: Search for directories recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the directory search.
function sd() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
        echo "Usage: sd <search_path> <glob_exp_folders>"
        return 1
    else
        echo "Searching for folders matching: \"$2\" in \"$1\""
        find "$1" -type d -iname "*""$2"
    fi

    return 0
}

# Purpose: Search for strings in files recursively.
# @param $1 [Req] : Search options.
# @param $2 [Req] : The base search path.
# @param $3 [Req] : The searching string.
# @param $4 [Req] : The GLOB expression of the file search.
# @param $5 [Opt] : Whether to replace the findings.
# @param $6 [Con] : Required if $4 is provided. This is the replacement string.
function ss() {

    local gflags
    local extra_str
    local replace
    local strType='regex'
    local gflags="-HnE"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 3 ]; then
        echo "Usage: ss [options] <search_path> <regex/string> <glob_exp_files>"
        echo ''
        echo 'Options: '
        echo '    -i | --ignore-case              : Makes the search case INSENSITIVE.'
        echo '    -w | --words                    : Makes the search treat the search as a STRING not a regex.'
        echo '    -r | --replace <replacement>    : Makes the search to REPLACE all findings by the replacement string.'
        return 1
    else
        while test -n "$1"
        do
            case "$1" in
                -w | --words)
                    gflags="${gflags//E/Fw}"
                    strType='string'
                ;;
                -i | --ignore-case)
                    gflags="${gflags}i"
                    strType="${strType}-ignore-case"
                ;;
                -r | --replace)
                    replace=1
                    shift
                    repl_str="$1"
                    extra_str=", replacement: \"$repl_str\""
                ;;
                *)
                    [[ ! "$1" =~ ^-[wir] ]] && break
                ;;
            esac
            shift
        done
        echo "${YELLOW}Searching for \"${strType}\" matching: \"$2\" in \"$1\" , filenames = [$3] $extra_str ${NC}"
        if [ -n "$replace" ]; then
            if [ "$strType" = 'string' ]; then
                echo "${RED}Can't replace non-Regex expressions in search!${NC}"
                return 1
            fi
            [ "Linux" = "$(uname -s)" ] && result=$(find "$1" -type f -iname "*""$3" -exec grep $gflags "$2" {} \; -exec sed -i'' -e "s/$2/$repl_str/g" {} \;)
            [ "Darwin" = "$(uname -s)" ] && result=$(find "$1" -type f -iname "*""$3" -exec grep $gflags "$2" {} \; -exec sed -i '' -e "s/$2/$repl_str/g" {} \;)
            test -n "$result" && echo "${result//$2/$repl_str}" | grep $gflags "$repl_str"
        else
            result=$(find "$1" -type f -iname "*""$3" -exec grep $gflags "$2" {} \;)
            test -n "$result" && echo "${result}" | grep $gflags "$2"
        fi
    fi

    return 0
}

# Purpose: Search for a previous issued command from history.
# @param $1 [Req] : The searching command.
function hist() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: hist <command>"
        return 1
    else
        history | grep "$*"
    fi

    return 0
}

# Purpose: Send files recursively to Trash.
# @param $1 [Req] : The GLOB expression of the file/directory search.
function del-tree() {

    local all
    local dst

    if [ -z "$1" ] || [ "$1" = "/" ] || [ ! -d "$1" ]; then
        echo "Usage: del-tree <search_path> <glob_exp>"
        return 1
    else
        # Find all files and folders matching the <glob_exp>
        all=$(find "$1" -name "*$2")
        # Move all to trash
        if [ -n "$all" ]; then
            read -r -n 1 -sp "### Move all files of type: \"$2\" in \"$1\" recursively to trash (y/[n]) ? " ANS
            if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                echo "${RED}"
                for next in $all; do
                    dst=${next##*/}
                    while [ -e "${TRASH}/$dst" ]; do
                        dst="${next##*/}-$(now-ms)"
                    done
                    mv -v "$next" "${TRASH}/$dst"
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

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: jp <json_string>"
        return 1
    else
        echo "$1" | json_pp -f json -t json -json_opt pretty indent escape_slash
    fi

    return 0
}

# Remove the function is json_pp is not installed.
command -v json_pp >/dev/null || unset jp

# Purpose: Check information about the IP.
# @param $1 [Req] : The IP to get information about.
function ip-info() {

    local ipinfo

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ip-info <IPv4_address>"
        return 1
    else
        ipinfo=$(curl -m 3 --basic "ip-api.com/json/$1" 2>/dev/null | tr ' ' '_')
        test -n "$ipinfo" && jp "$ipinfo"
    fi

    return 0
}

# Purpose: Resolve domain names associated with the IP.
# @param $1 [Req] : The IP address to resolve.
function ip-resolve() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
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

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
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

    if [ -n "$1" ] && [ -n "$2" ]; then
        echo "Checking port \"$1\" state: \"$2\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$2"
    elif [ -n "$1" ] && [ -z "$2" ]; then
        echo "Checking port \"$1\" state: \"ALL\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$1"
    else
        echo "Usage: port-check <portnum_regex> [state]"
        echo "States: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]"
        return 1
    fi

    return 0
}

# Purpose: Print all environment variables.
# @param $1 [Opt] : Filter environments.
function envs() {

    local pad
    local pad_len
    local filter
    local name
    local value

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: envs [regex_filter]"
        return 1
    else
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=60
        filter="$*"
        test -z "$filter" && filter="^[a-zA-Z0-9_]*.*"
        echo ' '
        echo "Listing all exported environment variables matching [ $filter ]:"
        echo ' '
        (
            IFS=$'\n'
            for v in $(env | sort); do
                name=$(echo "$v" | cut -d '=' -f1)
                value=$(echo "$v" | cut -d '=' -f2-)
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

    local pad
    local pad_len

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: paths"
        return 1
    elif [ -z "$1" ]; then
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=60
        echo ' '
        echo 'Listing all PATH entries:'
        echo ' '
        (
            IFS=$'\n'
            for path in $(echo -e "${PATH//:/\\n}"); do
                printf '%s' "${BLUE}$path ${WHITE}"
                printf '%*.*s' 0 $((pad_len - ${#path})) "$pad"
                test -d "$path" && printf '%s\n' "${GREEN} Path exists" || printf '%s\n'  "${RED} Path does not exist"
            done
        )
        echo -e "${NC}"
    fi

    return 0
}

# Purpose: Check the version of the app using common ways.
# @param $1 [Req] : The app to check.
function ver() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ver <appName>"
        return 1
    else
        # First attempt: app --version
        APP=$1
        tc "${APP}"
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
                        printf '%s\n' "${RED}Unable to find $APP version using common methods (--version, -version, -V and -v) ${NC}"
                        return 1
                    fi
                fi
            fi
        fi
        printf "${VER}\n"
    fi

    return 0
}

# Purpose: Check if the required tool is installed on the system.
# @param $1 [Req] : The app to check.
function tc() {

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
        printf "${ORANGE}($(uname -s))${NC} "
        printf "Checking: ${YELLOW}${tool_name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#1})) "$pad"
        if [ -n "${check}" ]; then
            printf '%s\n' "${GREEN}INSTALLED${NC} at ${check}"
            return 0
        else
            printf '%s\n' "${RED}NOT INSTALLED${NC}"
        fi
    fi

    return 1
}

# Purpose: Check if the development tools are installed on the system.
function tools() {

    DEV_APPS=${DEV_APPS:-${DEFAULT_DEV_TOOLS[*]}}

    echo ''
    for app in ${DEV_APPS[*]}; do
        tc "$app"
    done
    echo "${CYAN}"
    echo 'To check the current installed version type: #> ver <tool_name>'
    echo "${NC}"
    
    return 0
}

# Manipulate all custom aliases.
# @param $1 [Req] : The alias name.
# @param $2 [Opt] : The alias expression.
function aa() {

    local aliasFile
    local aliasName
    local aliasExpr
    local pad
    local pad_len
    local allAliases
    local isSorted=0

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo 'Usage: aa [-s|--sort] [alias] [alias_expr]'
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
                echo 'Available custom aliases:'
                echo ' '
                (
                    local name
                    local expr
                    IFS=$'\n'
                    for next in $allAliases; do
                        local re='^alias .+=.+'
                        if [[ $next =~ $re ]]; then
                            name=$(echo -n "$next" | awk -F '=' '{ print $1 }')
                            expr=$(echo -n "$next" | awk -F '=' '{ print $2 }')
                            printf "${BLUE}${name//alias /}"
                            printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
                            printf '%s\n' "${WHITE} is aliased to ${expr}"
                        else
                            printf '%s\n' "${YELLOW}$next${NC}"
                        fi
                    done
                )
                printf '%s\n' "${NC}"
            else
                printf '%s\n' "${YELLOW}No aliases were found in \"$aliasFile\" !${NC}"
            fi
        elif [ -n "$aliasName" ] && [ -n "$aliasExpr" ]; then
            # Add/Set one alias
            ised -e "s#(^alias $aliasName=.*)*##g" -e '/^\s*$/d' "$aliasFile"
            echo "alias $aliasName='$aliasExpr'" >>"$aliasFile"
            printf '%s\n' "${GREEN}Alias set: ${WHITE}\"$aliasName\" is ${BLUE}'$aliasExpr' ${NC}"
            # shellcheck disable=SC1090
            source "$aliasFile"
        elif [ -n "$aliasName" ] && [ -z "$aliasExpr" ]; then
            # Remove one alias
            unalias "$aliasName" &> /dev/null
            ised -e "s#(^alias $aliasName=.*)*##g" -e '/^\s*$/d' "$aliasFile"
            printf '%s\n' "${YELLOW}Alias removed: ${WHITE}\"$aliasName\" ${NC}"
        fi
    fi

    return 0
}

# Purpose: Save the current directory to be loaded by `load`.
# @param $1 [Opt] : The directory path to save.
# @param $2 [Opt] : The alias to access the directory saved.
function save() {

    local dir
    local dirAlias
    SAVED_DIRS=${SAVED_DIRS:-$HHS_DIR/.saved_dirs}

    touch "$SAVED_DIRS"
    dirAlias=$(echo -n "$2" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$dirAlias" ] && [ "$1" != "-e" ]; then
        echo "Usage: save [options] | [dir_to_save] [dir_alias]"
        echo "Options: "
        echo "    -e : Edit the saved dirs file."
        echo "    -r : Remove saved dir."
        return 1
    else
        if [ "$1" = "-e" ]; then
            vi "$SAVED_DIRS"
        elif [ "$1" = "-r" ]; then
            ised -e "s#(^$dirAlias=.*)*##g" -e '/^\s*$/d' "$SAVED_DIRS"
            echo "${YELLOW}Directory removed: ${WHITE}\"$dirAlias\" ${NC}"
        else
            dir="$1"
            # If the path is not absolute, append the current directory to it.
            [ -d "$dir" ] && [[ ! "$dir" =~ ^/ ]] && dir="$(pwd)/$dir"
            test -z "$dir" -o "$dir" = "." && dir=${dir//./$(pwd)}
            test -n "$dir" -a "$dir" = ".." && dir=${dir//../$(pwd)}
            test -n "$dir" -a "$dir" = "-" && dir=${dir//-/$OLDPWD}
            test -n "$dir" -a ! -d "$dir" && echo "${RED}Directory \"$dir\" is not a valid!${NC}" && return 1
            ised -e "s#(^$dirAlias=.*)*##" -e '/^\s*$/d' "$SAVED_DIRS"
            echo "$dirAlias=$dir" >>"$SAVED_DIRS"
            echo "${GREEN}Directory saved: ${WHITE}\"$dir\" as ${BLUE}$dirAlias ${NC}"
        fi
    fi

    return 0
}

# Purpose: cd into the saved directory issued by `save`.
# @param $1 [Opt] : The alias to access the directory saved.
function load() {

    local dirAlias
    local allDirs
    local dir
    local pad
    local pad_len
    SAVED_DIRS=${SAVED_DIRS:-$HHS_DIR/.saved_dirs}
    touch "$SAVED_DIRS"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: load [-l] | [dir_alias]"
        echo "Options: "
        echo "    [dir_alias] : Change to the directory saved from the alias provided."
        echo "             -l : List all saved dirs."
        return 1
    elif [ "$1" = "-l" ] || [ -z "$1" ]; then
        allDirs=$(grep . "$SAVED_DIRS" | sort)
        if [ -n "$allDirs" ]; then
            pad=$(printf '%0.1s' "."{1..60})
            pad_len=40
            echo ' '
            echo 'Available saved directories:'
            echo ' '
            (
                IFS=$'\n'
                for next in $allDirs; do
                    dirAlias=$(echo -n "$next" | awk -F '=' '{ print $1 }')
                    dir=$(echo -n "$next" | awk -F '=' '{ print $2 }')
                    printf "${BLUE}${dirAlias}"
                    printf '%*.*s' 0 $((pad_len - ${#dirAlias})) "$pad"
                    printf '%s\n' "${WHITE} is saved as '${dir}'"
                done
            )
            echo "${NC}"
        else
            echo "${YELLOW}No directories were saved yet \"$SAVED_DIRS\" !${NC}"
        fi
    else
        dirAlias=$(echo -n "$1" | tr -s '-' '_' | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
        dir=$(grep -m 1 "^${dirAlias}=" "$SAVED_DIRS" | awk -F '=' '{ print $2 }')
        if [ -z "$dir" ] || [ ! -d "$dir" ]; then
            echo "${RED}Directory ($dirAlias): \"$dir\" was not found${NC}"
            return 1
        else
            cd "$dir" || quit 2 "Unable to change to directory: $dir"
            echo "${GREEN}Directory changed to: ${WHITE}\"$(pwd)\"${NC}"
        fi
    fi

    return 0
}

# Purpose: Add/Remove/List/Execute saved bash commands.
# @param $1 [Opt] : The command options.
function cmd() {

    local cmdName
    local cmdId
    local cmdExpr
    local allCmds
    local pad
    local pad_len
    CMD_FILE=${CMD_FILE:-$HHS_DIR/.cmd_file}

    touch "$CMD_FILE"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: cmd [options [cmd_alias] <cmd_expression>] | [cmd_index]"
        echo "Options: "
        echo "    [cmd_index] : Execute the command specified by the command index."
        echo "             -e : Edit the commands file."
        echo "             -a : Store a command."
        echo "             -r : Remove a command."
        echo "             -l : List all stored commands."
        return 1
    else
        case "$1" in
            -e | --edit)
                vi "$CMD_FILE"
                return 0
            ;;
            -a | --add)
                shift
                cmdName=$(echo -n "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
                shift
                cmdExpr="$*"
                test -z "cmdName" -o -z "cmdExpr" && printf "${RED}Invalid arguments: \"$cmdName\"\t\"$cmdExpr\"${NC}" && return 1
                ised -e "s#(^Command $cmdName: .*)*##" -e '/^\s*$/d' "$CMD_FILE"
                echo "Command $cmdName: $cmdExpr" >>"$CMD_FILE"
                ;;
            -r | --remove)
                shift
                cmdId=$(echo -n "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
                local re='^[1-9]+$'
                if [[ $cmdId =~ $re ]]; then
                    cmdExpr=$(awk "NR==$1" "$CMD_FILE" | awk -F ': ' '{ print $0 }')
                    ised -e "s#(^$cmdExpr)*##" -e '/^\s*$/d' "$CMD_FILE"
                else
                    test -z "cmdId" -o -z "cmdExpr" && printf "${RED}Invalid arguments: \"$cmdId\"\t\"$cmdExpr\"${NC}" && return 1
                    ised -e "s#(^Command $cmdId: .*)*##" -e '/^\s*$/d' "$CMD_FILE"
                fi
            ;;
            "" | -l | --list)
                allCmds=$(grep . "$CMD_FILE")
                if [ -n "$allCmds" ]; then
                    pad=$(printf '%0.1s' "."{1..60})
                    pad_len=40
                    echo ' '
                    echo 'Available stored commands:'
                    echo ' '
                    (
                        local index=1
                        IFS=$'\n'
                        for next in $allCmds; do
                            cmdName="( $index ) $(echo -n "$next" | awk -F ':' '{ print $1 }')"
                            cmdExpr=$(echo -n "$next" | awk -F ': ' '{ print $2 }')
                            printf "${BLUE}${cmdName}"
                            printf '%*.*s' 0 $((pad_len - ${#cmdName})) "$pad"
                            echo "${WHITE} is stored as: ${cmdExpr}"
                            index=$((index + 1))
                        done
                    )
                    printf '%s\n' "${NC}"
                fi
            ;;
            [A-Z0-9_]*)
                cmdExpr=$(awk "NR==$1" "$CMD_FILE" | awk -F ': ' '{ print $2 }')
                test "-z" "$cmdExpr" && cmdExpr=$(grep "Command $1:" "$CMD_FILE" | awk -F ': ' '{ print $2 }')
                test -n "$cmdExpr" && echo "#> $cmdExpr" && eval "$cmdExpr"
            ;;
            *)
                printf '%s\n' "${RED}Invalid arguments: \"$1\"${NC}"
                return 1
            ;;
        esac
    fi

    return 0
}

# Purpose: Punch the Clock: Format = DDD dd-mm-YYYY => HH:MM HH:MM ...
# @param $1 [Opt] : Punch options
function punch() {

    local dateStamp
    local timeStamp
    local weekStamp

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: punch [-l,-e,-r]"
        echo "Options: "
        echo "       : !!PUNCH THE CLOCK!! (When no option is provided)."
        echo "    -l : List all registered punches."
        echo "    -e : Edit current punch file."
        echo "    -r : Reset punches for the next week."
        return 1
    else
        OPT="$1"
        PUNCH_FILE=${PUNCH_FILE:-$HHS_DIR/.punchs}
        dateStamp="$(date +'%a %d-%m-%Y')"
        timeStamp="$(date +'%H:%M')"
        weekStamp="$(date +%V)"
        local re="($dateStamp).*"
        # Create the punch file if it does not exist
        test -f "$PUNCH_FILE" || echo "$dateStamp => " >"$PUNCH_FILE"
        # List punchs
        test "-l" = "$OPT" && cat "$PUNCH_FILE" && return 0
        # Edit punchs
        test "-e" = "$OPT" && vi "$PUNCH_FILE" && return 0
        # Reset punchs (backup as week-N.punch)
        test "-r" = "$OPT" && mv -f "$PUNCH_FILE" "$(dirname "$PUNCH_FILE")/week-$weekStamp.punch" && return 0
        # Do the punch
        if [ -z "$OPT" ]; then
            lines=$(grep . "$PUNCH_FILE")
            (
                success=0
                IFS=$'\n'
                for line in $lines; do
                    if [[ "$line" =~ $re ]]; then
                        sed -E -e "s#($dateStamp) => (.*)#\1 => \2$timeStamp #g" -i .bak "$PUNCH_FILE"
                        success=1
                    fi
                done
                test "$success" = "1" || echo "$dateStamp => $timeStamp " >>"$PUNCH_FILE"
            )
            grep "$dateStamp" "$PUNCH_FILE" | sed "s/$dateStamp/Today/g"
        fi
    fi

    return 0
}

# Purpose: Display a process list of the given process name, killing them if specified.
# @param $1 [Req] : The process name to check.
# @param $2 [Opt] : Whether to kill all found processes.
function plist() {

    local allPids
    local pid

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 1 ]; then
        echo "Usage: plist <process_name> [kill]"
        return 1
    else
        # shellcheck disable=SC2009
        allPids=$(ps -efc | grep "$1" | awk '{ print $1,$2,$3,$8 }')
        if [ -n "$allPids" ]; then
            echo -e "${WHITE}\nUID\tPID\tPPID\tCOMMAND"
            echo '---------------------------------------------------------------------------------'
            echo -e "${RED}"
            (
                IFS=$'\n'
                for next in $allPids; do
                    pid=$(echo "$next" | awk '{ print $2 }')
                    echo -en "${BLUE}$next" | tr ' ' '\t'
                    if [ -n "$pid" ] && [ "$2" = "kill" ]; then 
                        kill -9 "$pid"
                        echo -e "${RED}\t\tKilled with signal -9"
                    else
                        test -n "$(pgrep "$1")" && echo -e "${GREEN}*"
                    fi
                done
            )
            echo -e "${NC}"
        else
            echo -e "\n${YELLOW}No active PIDs for process named: $1 ${NC}\n"
        fi
    fi

    return 0
}

# Purpose: Highlight words matching pattern.
# TODO Experimental
#function hl() {
    #local word

    #HIGHLIGHT_COLOR='\\e[4;37;104m'
    #NORMAL='\\e[0m'
    #word="${HIGHLIGHT_COLOR}${1}${NORMAL}"

    #while read -r data; do
        #local hlWord=$(echo "$data" | sed "s#$1#$word#g")
        #printf "$hlWord"
        #printf "$data"
    #done
#}

# Purpose: Checkout the last different previous git branch.
function git-() {

    local currBranch
    local prevBranch

    currBranch="$(git rev-parse --abbrev-ref HEAD)"
    prevBranch=$(git reflog | grep 'checkout: ' | grep -v "from $currBranch to $currBranch" | head -n1 | awk '{ print $6}')
    command git checkout "$prevBranch"
}

# Check the latest dotfiles version.
function dv() {

    local repoVer
    local isDifferent
    local VERSION_URL='https://raw.githubusercontent.com/yorevs/homesetup/master/.VERSION'

    if [ -n "$DOTFILES_VERSION" ]; then
        repoVer=$(curl -s -m 3 "$VERSION_URL")
        isDifferent=$(test -n "$repoVer" -a "$DOTFILES_VERSION" != "$repoVer" && echo 1)
        if [ -n "$isDifferent" ];then
            echo -e "${YELLOW}You have a different version of HomeSetup:"
            echo -e "  => Repository: ${repoVer} , Yours: ${DOTFILES_VERSION}."
            read -r -n 1 -sp "Update it now (y/[n]) ?" ANS
            test -n "$ANS" && echo "${ANS}${NC}"
            if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                cd "$HOME_SETUP" || return 1
                git pull || return 1
                sleep 1
                cd - || return 1
                echo -e "${GREEN}Successfully updated HomeSetup!"
                reload
            fi
        else
            echo -e "${GREEN}You version is up to date with the repository: ${repoVer} !"
        fi
    else
        echo "${RED}DOTFILES_VERSION was not defined!${NC}"
        return 1
    fi
    echo "${NC}"

    return 0
}
