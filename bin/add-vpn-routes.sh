#!/usr/bin/env bash

#  Script: add-vpn-routes.sh
# Purpose: Add routes out of VPNs (MAC Port)
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com
#
# Original script author: Eduardo Sousa
# Original script: https://onedrive.live.com/?authkey=%21AIROKS5gIiR5Orw&cid=A6F99C1028608687&id=A6F99C1028608687%212984&parId=A6F99C1028608687%212404&o=OneUp
#
# IP masks reference: https://www.iplocation.net/subnet-mask

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <add/del> [-t <net_type>] [-g <gateway_ip>]

Options:
                add   : Add all non vpn routes
                del   : Remove all non vpn routes
                get   : Show all static routes
    -t | --net-type   : VPN type, one of: gap default
    -g | --gateway    : Specify the gateway IP to use

"

# Import pre-defined .bash_colors
test -f ~/.bash_colors && source ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    test -n "$2" -o "$2" != "" && echo -e "$2"
    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

shopt -s nocasematch
case "$1" in
    add ) OP='add';;
    del ) OP='delete';;
    get ) OP='get';;
    * ) usage;;
esac
shopt -u nocasematch
shift

GATEWAY='192.168.0.1'

# Public IP routes.
PUBLIC_IP_ROUTES=( \
    8.0.0.0/7 \
    11.0.0.0/8 \
    12.0.0.0/6 \
    16.0.0.0/4 \
    32.0.0.0/3 \
    64.0.0.0/3 \
    96.0.0.0/4 \
    112.0.0.0/5 \
    120.0.0.0/6 \
    124.0.0.0/7 \
    126.0.0.0/8 \
    129.0.0.0/8 \
    130.0.0.0/7 \
    132.0.0.0/6 \
    136.0.0.0/5 \
    144.0.0.0/4 \
    160.0.0.0/5 \
    168.0.0.0/6 \
    172.0.0.0/12 \
    172.32.0.0/11 \
    172.64.0.0/10 \
    172.128.0.0/9 \
    173.0.0.0/8 \
    174.0.0.0/7 \
    176.0.0.0/4 \
    192.0.0.0/9 \
    192.128.0.0/11 \
    192.160.0.0/13 \
    192.169.0.0/16 \
    192.170.0.0/15 \
    192.172.0.0/14 \
    192.176.0.0/12 \
    192.192.0.0/10 \
    193.0.0.0/8 \
    194.0.0.0/7 \
    196.0.0.0/6 \
    200.0.0.0/5 \
    208.0.0.0/4 \
)

GAP_EXTRA=( \
    0.0.0.0/8 \
    1.0.0.0/8 \
    2.0.0.0/8 \
    4.0.0.0/6 \
    3.0.0.0/12 \
    3.16.0.0/17 \
    3.16.128.0/18 \
    3.16.192.0/21 \
    3.16.200.0/22 \
    3.16.204.0/25 \
    3.16.204.128/28 \
    3.16.204.144/30 \
    3.16.204.148/31 \
    3.16.204.151/32 \
    3.16.204.152/29 \
    3.16.204.160/27 \
    3.16.204.192/26 \
    3.16.205.0/24 \
    3.16.206.0/23 \
    3.16.208.0/20 \
    3.16.224.0/19 \
    3.17.0.0/16 \
    3.18.0.0/15 \
    3.20.0.0/14 \
    3.24.0.0/13 \
    3.32.0.0/11 \
    3.64.0.0/10 \
    3.128.0.0/9 \
)

OTHERS_EXTRA=( \
    1.0.0.0/5 \
)

# All IPs to route
ALL_IP_ROUTES=()

# VPN type
TYPE=

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while test -n "$1"
do
    case "$1" in
        -t | --net-type)
            shift
            test -z "$1" && usage
            TYPE="$1"
            shift
        ;;
        -g | --gateway)
            shift
            test -z "$1" && usage
            GATEWAY="$1"
            shift
        ;;
        
        *)
            quit 1 "### Invalid option: \"$1\""
        ;;
    esac
    shift
done

test "$OP" == "add" &&  echo "Adding routes: TYPE=[$TYPE] GATEWAY=<$GATEWAY>"
test "$OP" == "delete" &&  echo "Removing routes: TYPE=[$TYPE] GATEWAY=<$GATEWAY>"
test "$OP" == "get" &&  echo "Listing routes: TYPE=[$TYPE] GATEWAY=<$GATEWAY>"

# Set all default routes.
IP_ROUTES_ALL=( ${PUBLIC_IP_ROUTES[@]} )

if test "$TYPE" == 'gap'
then
    # Add GAP specific routes
    IP_ROUTES_ALL+=( ${GAP_EXTRA[@]} )
elif test "$TYPE" == 'default'
then
    # Add other default routes
    IP_ROUTES_ALL+=( ${OTHERS_EXTRA[@]} )
else
    quit 2 "### Network type: $TYPE is not valid!"
fi

# Add/Remove or show specified routes.
for nextIp in ${IP_ROUTES_ALL[@]}
do
    route -n $OP $nextIp $GATEWAY
    test $? -eq 0 || quit 2 "### Failed to add route: $nextIp -> $GATEWAY"
done

echo "(${PUBLIC_IP_ROUTES[*]}) routes changed"