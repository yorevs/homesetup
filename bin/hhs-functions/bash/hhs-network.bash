#!/usr/bin/env bash

#  Script: hhs-network.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Display a list of active network interfaces.
function __hhs_active_ifaces() {

  local if_all if_name if_flags if_mtu

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]}"
    return 1
  fi

  if_all=$(ifconfig -a | grep '^[a-z0-9]*: ')

  if [[ -n "${if_all}" ]]; then
    echo ' '
    echo "${YELLOW}Listing all network interfaces:${NC}"
    echo ' '
    IFS=$'\n'
    for next in ${if_all}; do
      if_name=$(echo "${next%%:*}" | awk '{ print $1 }')
      if_mtu=$(echo "${next}" | awk '{ print $4 }')
      if_flags=$(echo "${next}" | awk '{ print $2 }')
      printf "${HHS_HIGHLIGHT_COLOR}%-12s${NC}\tMTU %-8d\t%-s\n" "${if_name}" "${if_mtu}" "${if_flags}"
    done
    IFS="${RESET_IFS}"
    echo ' '
    return 0
  fi

  return 1
}

# TODO
function __hhs_ip() {

  local ip_type if_state

  if [[ "$#" -le 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [kind]"
    echo ''
    echo '    Arguments:'
    echo '      type : The kind of IP to get. One of [local|external|gateway|vpn]'
    echo ''
    echo '    Types:'
    echo '         local : Get your local network IPv4'
    echo '      external : Get your external network IPv4'
    echo '       gateway : Get the IPv4 of your gateway'
    echo '           vpn : Get your IPv4 assigned by your VPN'
    echo ''
    echo ''
    echo '  Notes: '
    echo '    - If no kind is specified, all ips assigned to the machine will be retrieved'
    return 1
  else
    case "${1}" in
      'ip')
        ip_type=${2:-all}
        if [[ "local" == "${ip_type}" ]]; then
          local_ips="$(ifconfig | grep -E '^(en|eth|inet)[0-9]')"
          for iface in ${local_ips}; do
            echo "IP-Local(${iface}) : $(ipconfig getifaddr "${iface}")"
          done
          [[ -z "$local_ips" ]] && echo "IP-Local(---) : ${YELLOW}Unable to get${HHS_HIGHLIGHT_COLOR}" && return 1
        fi
        ;;
      'if')
        if_state=${2:-all}
        ;;
      *)
        __hhs_errcho "Invalid argument: \"${1}\". Use one of [ip|if]"
        ;;
    esac
  fi
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
    echo "    States: One of [${states//|,, /}]"
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
      __hhs_errcho "${FUNCNAME[0]}: ## Invalid state \"${state}\". Use one of [${states//|,, /}]"
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
