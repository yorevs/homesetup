#!/usr/bin/env bash

#  Script: bash_functions.sh
# Purpose: Configure some shell tools
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Purpose: Search for files recursivelly.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the file search.
function search-files() {
  if test -z "$1" -o -z "$2"; then
    echo "Usage: search-files <search_path> <glob_exp_files>"
  else
    echo "Searching for files matching: \"$2\" in \"$1\""
    find "$1" -type f -iname "*""$2"
  fi
}

# Purpose: Search for directories recursivelly.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expression of the directory search.
function search-directories() {
  if test -z "$1" -o -z "$2"; then
    echo "Usage: search-directories <search_path> <glob_exp_folders>"
  else
    echo "Searching for folders matching: \"$2\" in \"$1\""
    find "$1" -type d -iname "*""$2"
  fi
}

# Purpose: Search for strings in files recursivelly
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The searching string.
# @param $3 [Req] : The GLOB expression of the file search.
function search-string() {
  if test -z "$1" -o -z "$2" -o -z "$3"; then
    echo "Usage: search-string <search_path> <string> <glob_exp_files>"
  else
    echo "Searching for string matching: \"$2\" in \"$1\" , filenames = [$3]"
    find "$1" -type f -iname "*""$3" -exec grep -HEni "$2" {} \; | grep "$2"
  fi
}

# Purpose: Search for a previous command from the bash history
# @param $1 [Req] : The searching command.
function hist() {
  if test -z "$1"; then
    echo "Usage: hist <command>"
  else
    history | grep "$1"
  fi
}

# Purpose: Delete the files recursivelly, seding them to Trash
# @param $1 [Req] : The GLOB expression of the file/directory search.
function del-tree() {
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
}

# Purpose: Pritty print (format) json string
# @param $1 [Req] : The unformatted json string
function json-pprint() {
  if test -n "$1"; then
    echo $1 | json_pp -f json -t json -json_opt pretty indent escape_slash
  else
    echo "Usage: json-pprint <json_string>"
  fi
}

# Purpose: Check information about an IP
# @param $1 [Req] : The IP to get information about
function ip-info() {
  if test -z "$1"; then
    echo "Usage: ip-info <IPv4_address>"
  else
    local ipinfo=$(curl --basic freegeoip.net/json/$1 2>/dev/null | tr ' ' '_')
    test -n "$ipinfo" && json-pprint $ipinfo
  fi
}

# Purpose: Resolve domain names associated with the IP
# @param $1 [Req] : The IP address to resolve
function ip-resolve() {
  if test -z "$1"; then
    echo "Usage: ip-resolve <IPv4_address>"
  else
    dig +short -x "$1"
  fi
}

# Purpose: Lokup the DNS to determine the associated IP address
# @param $1 [Req] : The domain name to lookup
function ip-lookup() {
  if test -z "$1"; then
    echo "Usage: ip-lookup <domain_name>"
  else
    host "$1"
  fi
}

# Purpose: Check the state of a local port
# @param $1 [Req] : The port number regex
# @param $2 [Opt] : The port state to match. One of: CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN
function port-check() {
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

# Purpose: Check all environment variables
function envs() {

  local pad=$(printf '%0.1s' "."{1..60})
  local pad_len=35
  (
    IFS=$'\n'
    for v in $(env); do
      local name=$(echo $v | cut -d '=' -f1)
      local value=$(echo $v | cut -d '=' -f2-)
      test "$1" != "-h" && local re="^[a-zA-Z0-9_]*.*"
      test "$1" = "-h" && local re=".*_HOME$"
      if [[ $name =~ $re ]]; then
        printf "${BLUE}${name}${NC} "
        printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
        printf " => ${value} \n"
      fi
    done
  )
}

# Purpose: Print each PATH entry on a separate line
function paths() {

  local pad=$(printf '%0.1s' "."{1..60})
  local pad_len=60
  (
    IFS=$'\n'
    for path in $(echo -e ${PATH//:/\\n}); do
      printf "$path "
      printf '%*.*s' 0 $((pad_len - ${#path})) "$pad"
      test -d "$path" && printf "${BLUE}OK${NC}\n"
      test -d "$path" || printf "${RED}NOT FOUND${NC}\n"
    done
  )
}

# Purpose: Check if the required tool is installed on the system.
function tc() {

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

  DEV_APPS="brew tree vim pcregrep shfmt jenv git svn gcc make qmake java ant mvn gradle python doxygen ruby node npm vue"
  for app in $DEV_APPS; do
    tc $app
  done
}

# Purpose: Check the version of the specified app.
function ver() {

  if test -z "$1"; then
    echo "Usage: version <app>"
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
            return 2
          fi
        fi
      fi
    fi
    printf "${VER}\n"
  fi
}

# Purpose: Save the current directory for later use
function save-dir() {

  if test -z "$1" -o "$1" = "" -o ! -d "$1"; then
    curDir=$(pwd)
  else
    curDir="$1"
  fi

  export SAVED_DIR="$curDir"
  echo "SAVED_DIR=$curDir" >"$HOME/.saved_dir"
}

# Purpose: Load the directory prviously saved
function load-dir() {

  test -f "$HOME/.saved_dir" && source "$HOME/.saved_dir"
  SAVED_DIR="${SAVED_DIR:-$(pwd)}"
  test -d "$SAVED_DIR" && cd "$SAVED_DIR"
  echo "SAVED_DIR=$SAVED_DIR" >"$HOME/.saved_dir"
}

# Purpose: Punch the Clock: Format = DDD dd-mm-YYYY => HH:MM HH:MM ...
function punch() {
  if test "$1" = "-h" -o "$1" = "--help"; then
    echo "Usage: punch [-l,-e,-r]"
    echo "Options: "
    echo "       : !!Do the punch!! (When no option s provided)."
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
      test "-l" = "$OPT" && cat "$PUNCH_FILE"
      # Edit punchs
      test "-e" = "$OPT" && vi "$PUNCH_FILE"
      # Reset punchs (backup as week-N.punch)
      test "-r" = "$OPT" && mv -f "$PUNCH_FILE" "$(dirname $PUNCH_FILE)/week-$weekStamp.punch"
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
}

#TODO Change to set-alias and improve with -e, -l, etc
function add-alias() {
  if test -z "$1" -o -z "$2" -o "$1" = "-h" -o "$1" = "--help"; then
    echo "Usage: add-alias <name> <alias_expr>"
    return 1
  else
    test -f "$HOME/.aliases" || touch "$HOME/.aliases"
    echo "alias $1='$2'" >>"$HOME/.aliases"
  fi
}

function plist() {
  if test -z "$1" -o "$1" = "-h" -o "$1" = "--help"; then
    echo "Usage: plist <process_name> [kill]"
    return 1
  else
    local pids=$(ps -efc | grep "$1" | awk '{ print $1, $2,$3 }' )
    if test -n "$pids"; then
      test "$2" = "kill" || echo -e "${GREEN}\nUID\tPID\tPPID\n---------------------------${NC}"
      test "$2" = "kill" && echo ''
      (
        IFS=$'\n'
        for next in $pids; do
          local p=$(echo $next | awk '{ print $2 }' )
          test "$2" = "kill" || echo -e "${GREEN}$next${NC}" | tr ' ' '\t'
          test -n "$p" -a "$2" = "kill" && kill -9 "$p" && echo "${RED}Killed process with PID = $p ${NC}"
        done
      )
      echo ''
    else
      echo "${YELLOW}No active PIDs for process named: $1 ${NC}"
    fi
  fi
}