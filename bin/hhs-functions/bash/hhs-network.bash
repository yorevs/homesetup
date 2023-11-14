#!/usr/bin/env bash

#  Script: hhs-network.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# Requires ifconfig to work.
if __hhs_has ifconfig; then

  # shellcheck disable=2120
  # @function: Display a list of active network interfaces.
  function __hhs_active_ifaces() {

    local if_all=() if_name if_flags if_mtu if_list

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} [-flat]"
      return 1
    fi

    IFS=$'\n'
    read -r -d '' -a if_all < <(ifconfig -a | grep '^[a-z0-9]*: ')
    IFS="${OLDIFS}"

    if [[ ${#if_all[@]} -gt 0 && ! ${*} =~ -flat ]]; then
      echo ' '
      echo "${YELLOW}Listing all network interfaces:${NC}"
      echo ' '
      for next in "${if_all[@]}"; do
        if_name=$(awk '{ print $1 }' <<<"${next%%:*}")
        if_mtu=$(awk '{ print $4 }' <<<"${next}")
        if_flags=$(awk '{ print $2 }' <<<"${next}")
        printf "${HHS_HIGHLIGHT_COLOR}%-12s${NC}\tMTU=%-8d\t%-s\n" "${if_name}" "${if_mtu}" "${if_flags}"
      done
      echo ' '
      return 0
    elif [[ ${#if_all[@]} -gt 0 && ${*} =~ -flat ]]; then
      for next in "${if_all[@]}"; do
        if_name=$(awk '{ print $1 }' <<<"${next%%:*}")
        if_list="${if_name} ${if_list}"
      done
      echo "${if_list}"
    else
      echo "${YELLOW}No active interfaces found !${NC}"
    fi

    return 1
  }

  if __hhs_has route; then

    # @function: Display the associated machine IP of the given kind.
    # @param $1 [Opt] : The kind of IP to get.
    function __hhs_ip() {

      local ret_val=1 ip_kind if_list if_ip if_prefix ip_srv_url='ifconfig.me'

      if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: ${FUNCNAME[0]} [kind]"
        echo ''
        echo '    Arguments:'
        echo '      type : The kind of IP to get. One of [all|local|external|gateway|vpn]'
        echo ''
        echo '    Types:'
        echo '           all : Get all network IPv4'
        echo '         local : Get your local network IPv4'
        echo '      external : Get your external network IPv4'
        echo '       gateway : Get the gateway IPv4'
        echo '           vpn : Get your IPv4 assigned by your VPN server'
        echo ''
        echo '  Notes: '
        echo '    - If no kind is specified, all assigned IPv4s will be retrieved'
        return 1
      else
        ip_kind=${1:-all}
        if [[ "all" == "${ip_kind}" || "external" == "${ip_kind}" ]]; then
          if_ip="$(curl -s --fail -m 3 "${ip_srv_url}" 2>/dev/null)"
          [[ -n "${if_ip}" ]] &&  printf "%-10s: %-13s\n" "External" "${if_ip}"
        fi
        if [[ "all" == "${ip_kind}" || "gateway" == "${ip_kind}" ]]; then
          [[ "Darwin" == "${HHS_MY_OS}" ]] && if_ip="$(route get default 2>/dev/null | grep 'gateway' | cut -b 14- | uniq)"
          [[ "Linux" == "${HHS_MY_OS}" ]] && if_ip="$(route -n | grep 'UG[ \t]' | awk '{print $2}' | uniq)"
          [[ -n "${if_ip}" ]] && printf "%-10s: %-13s\n" "Gateway" "${if_ip}"
        fi
        if [[ ${ip_kind} =~ all|vpn|local ]]; then
          read -r -d '' -a if_list < <(__hhs_active_ifaces -flat)
          [[ "vpn" == "${ip_kind}" ]] && if_prefix='(utun|tun)[a-z0-9]+'
          [[ "local" == "${ip_kind}" ]] && if_prefix='(en|wl)[a-z0-9]+'
          for next in "${if_list[@]}"; do
            if [[ "all" == "${ip_kind}" || ${next} =~ ${if_prefix} ]]; then
              if_ip="$(ifconfig "${next}" | grep -E "inet " | awk '{print $2}')"
              [[ -n "${if_ip}" ]] && printf "%-10s: %-13s\n" "${next}" "${if_ip}"
            fi
          done
          ret_val=0
        fi
      fi

      return ${ret_val}
    }

  fi

fi

# @function: Retrieve information about the specified IP.
# @param $1 [Req] : The IP to get information about.
function __hhs_ip_info() {

  local ipinfo ip_srv_url="http://ip-api.com/json/${1}"

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
    return 1
  else
    ipinfo=$(curl -s --fail -m 3 "${ip_srv_url}" 2>/dev/null)
    [[ -n "$ipinfo" ]] && __hhs_json_print "$ipinfo" && return 0
  fi

  return 1
}

# Requires host to work.
if __hhs_has host; then

  # @function: Lookup DNS payload to determine the IP address.
  # @param $1 [Req] : The domain name to lookup.
  function __hhs_ip_lookup() {

    if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <domain_name>"
      return 1
    else
      \host "${1}"
    fi

    return 0
  }

fi

# Requires dig to work.
if __hhs_has dig; then

  # @function: Resolve domain names associated with the specified IP.
  # @param $1 [Req] : The IP address to resolve.
  function __hhs_ip_resolve() {

    if [[ "$1" == "-h" || "$1" == "--help" || "$#" -ne 1 ]]; then
      echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
      return 1
    fi
    \dig +short -x "$1"

    return $?
  }

fi

# Requires netstat to work.
if __hhs_has netstat; then

  # @function: Check the state of local port(s).
  # @param $1 [Req] : The port number regex.
  # @param $2 [Opt] : The port state to match.
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
        \netstat -an | grep -E "[.:]${port} " | __hhs_highlight "${state}"
        return $?
      else
        __hhs_errcho "${FUNCNAME[0]}: ## Invalid state \"${state}\". Use one of [${states//|,, /}]"
      fi
    elif [[ -n "$1" && -z "$2" ]]; then
      port=${1:0:5}
      echo -e "\n${YELLOW}Checking for \"ALL\" ports ($port) with any state ${NC}\n"
      echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        State"
      \netstat -an | grep -E "[.:]${port} " | __hhs_highlight "$port"
      return $?
    fi
    echo ''

    return 0
  }

fi
