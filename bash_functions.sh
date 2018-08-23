#!/usr/bin/env bash

# Search for files recursivelly
function search-files () {
    if test -z "$1" -o -z "$2"; then
        echo "Usage: search-files <search_path> <glob_exp_files>"
    else
        echo "Searching for files matching: \"$2\" in \"$1\""
        find "$1" -type f -iname "*""$2"
    fi
};

# Search for directories recursivelly
function search-directories () {
    if test -z "$1" -o -z "$2"; then
        echo "Usage: search-directories <search_path> <glob_exp_folders>"
    else
        echo "Searching for folders matching: \"$2\" in \"$1\""
        find "$1" -type d -iname "*""$2"
    fi
};

# Search for strings recursivelly
function search-string () {
    if test -z "$1" -o -z "$2" -o -z "$3"; then
        echo "Usage: search-string <search_path> <string> <glob_exp_files>"
    else
        echo "Searching for string matching: \"$2\" in \"$1\" , filenames = [$3]"
        find "$1" -type f -iname "*""$3" -exec grep -HEni "$2" {} \; | grep "$2"
    fi
};

# Search for a command from the history
function hist () {
    if test -z "$1"; then
        echo "Usage: hist <command>"
    else
        history | grep "$1"
    fi
}

# Delete the files recursivelly
function del-tree () {
    if test -n "$1" -a "$1" != "/" -a -d "$1"; then
        # Find all files and folders matching the <glob_exp>
        local all=$(find "$1" -name "*$2")
        # Move all to trash
        if test -n "$all"; then
            read -n 1 -sp "### Move all files of type: \"$2\" in \"$1\" recursivelly to trash (y/[n]) ? " ANS
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
    else
        echo "Usage: del-tree <search_path> <glob_exp>"
    fi
};

# Pritty print json string
function json-pprint () {
    if test -n "$1"; then
        echo $1 | json_pp -f json -t json -json_opt pretty indent escape_slash
    else
        echo "Usage: json-pprint <json_string>"
    fi
}

# Check information about an IP
function ip-info () {
    if test -z "$1"; then
        echo "Usage: ip-info <IPv4_address>"
    else
        local ipinfo=$(curl --basic freegeoip.net/json/$1 2>/dev/null | tr ' ' '_')
        test -n "$ipinfo" && json-pprint $ipinfo
    fi
}

# Resolve domain names associated to the IP
function ip-resolve () {
    if test -z "$1"; then
        echo "Usage: ip-resolve <IPv4_address>"
    else
        dig +short -x "$1"
    fi
}

# Lokup the DNS to determine the associated IP address
function ip-lookup () {
    if test -z "$1"; then
        echo "Usage: ip-lookup <domain_name>"
    else
        host "$1"
    fi
}

# Check the state of a local port
function port-check () {
    if test -z "$1" -a -z "$2"; then
        echo "Usage: port-check <portnum_regex> [state]"
        echo "States: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]"
        elif test -n "$1" -a -z "$2"; then
        echo "Checking port \"$1\" state: \"ALL\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$1"
    else
        echo "Checking port \"$1\" state: \"$2\""
        echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
        netstat -an | grep -E '((([0-9]{1,3}\.){4})|(\*\.))'"$1" | grep -i "$2"
    fi
}

# Check all environment variables
function envs () {
    
    local pad=$(printf '%0.1s' "."{1..60})
    local pad_len=35
    ( IFS=$'\n'
        for v in $(env)
        do
            local name=$(echo $v | cut -d '=' -f1)
            local value=$(echo $v | cut -d '=' -f2-)
            test "$1" != "-h" && local re="^[a-zA-Z0-9_]*.*"
            test "$1" = "-h" && local re=".*_HOME$"
            if [[ $name =~ $re ]]
            then
                printf "${BLUE}${name}${NC} "
                printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
                printf " => ${value} \n"
            fi
        done
    )
}

# Print each PATH entry on a separate line
function paths () {
    
    local pad=$(printf '%0.1s' "."{1..60})
    local pad_len=60
    for path in $(echo -e ${PATH//:/\\n})
    do
        printf "$path "
        printf '%*.*s' 0 $((pad_len - ${#path})) "$pad"
        test -d "$path" && printf "${BLUE}OK${NC}\n"
        test -d "$path" || printf "${RED}NOT FOUND${NC}\n"
    done
}

# Check if the required tool is installed on the system.
function tc () {
    
    if test -z "$1"; then
        echo "Usage: version <app>"
        return 1
    else
        local pad=$(printf '%0.1s' "."{1..60})
        local pad_len=20
        local tool_name="$1"
        local check=$(command -v ${tool_name})
        printf "${ORANGE}($(uname -s))${NC} "
        printf "Checking: ${YELLOW}${tool_name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#1})) "$pad"
        if test -n "${check}" ; then
            printf "${GREEN}INSTALLED${NC} at ${check}\n"
            return 0
        else
            printf "${RED}NOT INSTALLED${NC}\n"
            return 2
        fi
    fi
}

# Check if the development tools are installed on the system.
function tools () {
    
    DEV_APPS="brew tree vim pcregrep jenv git svn gcc make qmake java ant mvn gradle python doxygen ruby node npm vue"
    for app in $DEV_APPS
    do
        tc $app
    done
}

# Check the version of the specified app.
function ver () {
    
    if test -z "$1"; then
        echo "Usage: version <app>"
        return 1
    else
        # First attempt: app --version
        APP=$1
        tc ${APP}
        test $? -ne 0 && return 2
        VER=`${APP} --version 2>&1`
        if test $? -ne 0; then
            # Second attempt: app -version
            VER=`${APP} -version 2>&1`
            if test $? -ne 0; then
                # Third attempt: app -V
                VER=`${APP} -V 2>&1`
                if test $? -ne 0; then
                    # Last attempt: app -v
                    VER=`${APP} -v 2>&1`
                    if test $? -ne 0; then
                        printf "${RED}Unable to find $APP version using common methods (--version, -version, -V and -v) ${NC}\n"
                        return 2
                    fi
                fi
            fi
        fi
        printf "${VER}\n"
    fi
}

# Save the current directory for later use
function save-dir () {
    
    if test -z "$1" -o "$1" = "" -o ! -d "$1"; then
        curDir=$(pwd)
    else
        curDir="$1"
    fi
    
    export SAVED_DIR="$curDir"
    echo "SAVED_DIR=$curDir" > "$HOME/.saved_dir"
}

function load-dir () {
    
    test -f "$HOME/.saved_dir" && source "$HOME/.saved_dir"
    SAVED_DIR="${SAVED_DIR:-`pwd`}"
    test -d "$SAVED_DIR" && cd "$SAVED_DIR"
    echo "SAVED_DIR=$SAVED_DIR" > "$HOME/.saved_dir"
}
