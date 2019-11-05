#!/usr/bin/env bash

#  Script: hhs-network.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Check information about the specified IP.
# @param $1 [Req] : The IP to get information about.
function __hhs_ip-info() {

    local ipinfo

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ip-info <IPv4_address>"
        return 1
    else
        ipinfo=$(curl -m 5 --basic "ip-api.com/json/$1" 2>/dev/null | tr ' ' '_')
        [ -n "$ipinfo" ] && __hhs_json-print "$ipinfo"
    fi

    return 0
}

# @function: Resolve domain names associated with the IP.
# @param $1 [Req] : The IP address to resolve.
function __hhs_ip-resolve() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ip-resolve <IPv4_address>"
        return 1
    else
        dig +short -x "$1"
    fi

    return 0
}

# @function: Lookup DNS entries to determine the IP address.
# @param $1 [Req] : The domain name to lookup.
function __hhs_ip-lookup() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 1 ]; then
        echo "Usage: ip-lookup <domain_name>"
        return 1
    else
        host "$1"
    fi

    return 0
}

# @function: Check the state of local port(s).
# @param $1 [Req] : The port number regex.
# @param $2 [Opt] : The port state to match. One of: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ] .
function __hhs_port-check() {

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