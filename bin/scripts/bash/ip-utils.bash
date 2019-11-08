#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: checkip.bash
# Purpose: Validate an IP and check details about it.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Current script version.
VERSION=1.0.0

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME <IP>
"

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}
# @param $2 [Opt] : The exit message to be displayed.
quit() {

  unset -f quit usage version
  ret=$1
  shift
  [ "$ret" -gt 1 ] && printf "%s" "${RED}"
  [ "$#" -gt 0 ] && printf "%s" "$*"
  # Unset all declared functions
  printf "%s\n" "${NC}"
  exit "$ret"
}

# Usage message.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
  quit "$1" "$USAGE"
}

# Version message.
version() {
  quit 0 "$VERSION"
}

# Check if the user passed the help or version parameters.
[ "$1" = '-h' ] || [ "$1" = '--help' ] && usage 0
[ "$1" = '-v' ] || [ "$1" = '--version' ] && version
# Test if the Ip parameter is not empty
[ -z "$1" ] && usage 1

# The IP to be validated.
IP="$1"
IP_VALID=''
IP_CLASS=''
IP_TYPE=''

# Purpose: Find the IP class.
# @param $1 [Req] : The IP to get information about
checkIpClass() {

  octet_1=$(echo "$1" | cut -d '.' -f1)

  if [ "$((octet_1))" -le 127 ]; then
    IP_CLASS="A"
  elif [ "$((octet_1))" -gt 127 ] && [ "$((octet_1))" -le 191 ]; then
    IP_CLASS="B"
  elif [ "$((octet_1))" -ge 192 ] && [ "$((octet_1))" -le 223 ]; then
    IP_CLASS="C"
  elif [ "$((octet_1))" -ge 224 ] && [ "$((octet_1))" -le 239 ]; then
    IP_CLASS="D"
  elif [ "$((octet_1))" -ge 240 ]; then
    IP_CLASS="E"
  else
    IP_CLASS="?"
  fi
}

# Purpose: Check the IP information.
#
# Rules from RFC 5735 - Special Use IPv4 Addresses:
#
# IP<broadcast> Class(A): 0.0.0.0/8      -> [ 0.0.0.1 to 0.255.255.255 ]
# IP<loopback>  Class(A): 127.0.0.0/8    -> [ 127.0.0.1 to 127.255.255.255 ]
# IP<private>   Class(A): 10.0.0.0/8     -> [ 10.0.0.1 to 10.255.255.255 ]
# IP<private>   Class(B): 172.16.0.0/12  -> [ 172.16.0.1 to 172.31.255.255 ]
# IP<private>   Class(C): 192.168.0.0/16 -> [ 192.168.0.1 to 192.168.255.25 ]
# IP<multicast> Class(D): 224.0.0.0/4    -> [ 224.0.0.1 to 239.255.255.254 ]
# IP<reserved>  Class(D): 240.0.0.0/4    -> [ 240.0.0.1 to 255.255.255.254 ]
# IP<broadcast> Class(D): 255.255.255.255/32
#
checkIpType() {

  octet_1=$(echo "$1" | cut -d '.' -f1)
  octet_2=$(echo "$1" | cut -d '.' -f2)

  if [ $((octet_1)) -eq 0 ]; then
    IP_TYPE="'This' Network"
  elif [ $((octet_1)) -eq 10 ]; then
    IP_TYPE="Private"
  elif [ $((octet_1)) -eq 127 ]; then
    IP_TYPE="Loopback"
  elif [ $((octet_1)) -eq 172 ] && [ $((octet_2)) -eq 16 ]; then
    IP_TYPE="Private"
  elif [ $((octet_1)) -eq 192 ] && [ $((octet_2)) -eq 168 ]; then
    IP_TYPE="Private"
  elif [ $((octet_1)) -ge 224 ] && [ $((octet_1)) -le 239 ]; then
    IP_TYPE="Multicast"
  elif [ "$IP" = "255.255.255.255" ]; then
    IP_TYPE="Limited Broadcast"
  elif [ $((octet_1)) -ge 240 ]; then
    IP_TYPE="Reserved"
  else
    IP_TYPE="Public"
  fi
}

# Purpose: Validate the IP. Required format [0-255].[0-255].[0-255].[0-255] .
checkIpValid() {

  ip_regex="((2((5[0-5])|[0-4][0-9])|(1([0-9]{2}))|(0|([1-9][0-9]))|([0-9]))\.){3}(2((5[0-5])|[0-4][0-9])|(1([0-9]{2}))|(0|([1-9][0-9]))|([0-9]))"

  # On Mac option -r does not exist, -E on linux option does not exist
  extRegexFlag='-r'
  test "$(uname -s)" = "Darwin" && extRegexFlag='-E'
  IP_VALID=$(echo "$IP" | sed $extRegexFlag "s/$ip_regex/VALID/")

  if [ "$IP_VALID" != "VALID" ]; then
    IP_VALID="## Invalid IP ##"
  else
    IP_VALID=
  fi
}

checkIpValid

if [ -z "$IP_VALID" ]; then
  checkIpClass "$IP"
  checkIpType "$IP"
  echo "Valid IP: $IP, Class: $IP_CLASS, Type: $IP_TYPE"
else
  echo "$IP_VALID"
  quit 1
fi

quit 0
