#!/usr/bin/env bash

#  Script: hhs-network.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions


# hsn ip local|external|gateway|vpn|all
# hsn ifaces active|all

# 
function __hhs_network() {
  echo "NETWORK"
}

# @function: Retrieve information about the specified IP.
# @param $1 [Req] : The IP to get information about.
function __hhs_ip_info() {

  local ipinfo ip_srv_url="http://ip-api.com/json/${1}"

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
    return 1
  else
    ipinfo=$(curl -s --fail -m 5 "${ip_srv_url}" 2> /dev/null)
    [[ -n "$ipinfo" ]] && __hhs_json_print "$ipinfo" && return 0
  fi

  return 1
}

# @function: Lookup DNS payload to determine the IP address.
# @param $1 [Req] : The domain name to lookup.
function __hhs_ip_lookup() {

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <domain_name>"
    return 1
  else
    host "$1"
  fi

  return 0
}

# @function: Check the state of local port(s).
# @param $1 [Req] : The port number regex.
# @param $2 [Opt] : The port state to match. One of: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ].
function __hhs_port_check() {

  local state port states
  
  states='CLOSED|LISTEN|SYN_SENT|SYN_RCVD|ESTABLISHED|CLOSE_WAIT|LAST_ACK|FIN_WAIT_1|FIN_WAIT_2|CLOSING TIME_WAIT'

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <port_number> [port_state]"
    echo ''
    echo '  Notes: '
    echo "    States: One of [${states//|,, }]"
    return 1
  elif [[ -n "$1" && -n "$2" ]]; then
    port=${1:0:5}
    state=$(echo "$2" | tr '[:lower:]' '[:upper:]')
    if [[ "${state}" =~ ^(${states})$ ]]; then
      echo -e "\n${YELLOW}Checking for ports \"$port\" with current state of \"${state}\" ${NC}\n"
      echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        State"
      netstat -an | grep -E "[.:]${port} " | __hhs_highlight "${state}"
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: ## Invalid state \"${state}\". Use one of [${states//|,, }]"
    fi
  elif [[ -n "$1" && -z "$2" ]]; then
    port=${1:0:5}
    echo -e "\n${YELLOW}Checking for \"ALL\" ports ($port) with any state ${NC}\n"
    echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        State"
    netstat -an | grep -E "[.:]${port} " | __hhs_highlight "$port"
    return $?
  fi
  echo ''

  return 0
}
