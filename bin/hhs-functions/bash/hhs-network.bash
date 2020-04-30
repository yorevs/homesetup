#!/usr/bin/env bash

#  Script: hhs-network.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# shellcheck disable=2120
# @function: Display a list of active network interfaces.
function __hhs_active_ifaces() {

  local if_all if_name if_flags if_mtu if_list

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [--info]"
    return 1
  fi

  if_all=$(ifconfig -a | grep '^[a-z0-9]*: ')

  if [[ -n "${if_all}" && "--info" == "${1}" ]]; then
    echo ' '
    echo "${YELLOW}Listing all network interfaces:${NC}"
    echo ' '
    IFS=$'\n'
    for next in ${if_all}; do
      if_name=$(awk '{ print $1 }' <<< "${next%%:*}")
      if_mtu=$(awk '{ print $4 }' <<< "${next}")
      if_flags=$(awk '{ print $2 }' <<< "${next}")
      printf "${HHS_HIGHLIGHT_COLOR}%-12s${NC}\tMTU=%-8d\t%-s\n" "${if_name}" "${if_mtu}" "${if_flags}"
    done
    IFS="${RESET_IFS}"
    echo ' '
    return 0
  elif [[ -n "${if_all}" && -z "${1}" ]]; then
    IFS=$'\n'
    for next in ${if_all}; do
      if_name=$(awk '{ print $1 }' <<< "${next%%:*}")
      if_list="${if_name} ${if_list}"
    done
    IFS="${RESET_IFS}"
    echo "${if_list}"
  fi

  return 1
}

# TODO
function __hhs_ip() {

  local ret_val=1 ip_kind if_list if_ip if_prefix ip_srv_url='ifconfig.me'

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
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
    ip_kind=${1:-all}
    if [[ "external" == "${ip_kind}" ]]; then
      if_ip="$(curl -s --fail -m 3 "${ip_srv_url}" 2> /dev/null)"
      [[ -n "${if_ip}" ]] && echo "IP-${ip_kind}: ${if_ip}" && return 0
    fi
    if [[ "gateway" == "${ip_kind}" ]]; then
      [[ "Darwin" == "${HHS_MY_OS}" ]] && if_ip="$(route get default 2> /dev/null | grep 'gateway' | cut -b 14- | uniq)"
      [[ "Linux" == "${HHS_MY_OS}" ]] && if_ip="$(route -n | grep 'UG[ \t]' | awk '{print $2}' | uniq)"
      [[ -n "${if_ip}" ]] && echo "IP-${ip_kind}: ${if_ip}" && return 0
    fi
    if [[ "all" == "${ip_kind}" || "vpn" == "${ip_kind}" || "local" == "${ip_kind}" ]]; then
      if_list="$(__hhs_active_ifaces)"
      IFS=' '
      [[ "vpn" == "${ip_kind}" ]] && if_prefix='(utun|tun)[a-z0-9]*'
      [[ "local" == "${ip_kind}" ]] && if_prefix='(en|wl)[a-z0-9]*'
      for next in ${if_list}; do
        if [[ "all" == "${ip_kind}" || "${next}" =~ ${if_prefix} ]]; then
          if_ip="$(ifconfig "${next}" | grep -E "inet " | awk '{print $2}')"
          [[ -n "${if_ip}" ]] && echo "IP-${next}: ${if_ip}" && ret_val=0
        fi
      done
      IFS="${RESET_IFS}"
    fi
  fi

  return ${ret_val}
}

# @function: Retrieve information about the specified IP.
# @param $1 [Req] : The IP to get information about.
function __hhs_ip_info() {

  local ipinfo ip_srv_url="http://ip-api.com/json/${1}"

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
    return 1
  else
    ipinfo=$(curl -s --fail -m 3 "${ip_srv_url}" 2> /dev/null)
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

# @function: Resolve domain names associated with the specified IP.
# @param $1 [Req] : The IP address to resolve.
function __hhs_ip_resolve() {

  if [[ "$1" == "-h" || "$1" == "--help" || "$#" -ne 1 ]]; then
    echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
    return 1
  fi
  dig +short -x "$1"

  return $?
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
