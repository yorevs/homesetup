#!/usr/bin/env bash

#  Script: hhs-network.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# The followng functions require dig to work.
if __hhs_has "dig"; then

  # @function: Find external IP by performing a DNS lookup.
  function __hhs_my_ip() {

    local ext_ip ret_val=1

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    ext_ip=$(dig -4 TXT +time=1 +short o-o.myaddr.l.google.com @ns1.google.com 2> /dev/null)

    [[ -n "$ext_ip" ]] && echo "${ext_ip//\"/}" && ret_val=0

    return ${ret_val}
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

else

  # @function: Find external IP using curl as an alternative, however, in most cases it may be inaccurate.
  function __hhs_my_ip() {

    local ext_ip

    ext_ip=$(curl ifconfig.me 2> /dev/null)

    [[ -n "$ext_ip" ]] && echo "${ext_ip//\"/}" && return 0

    return 1
  }

fi

# The followng functions require ifconfig to work.
if __hhs_has "ifconfig"; then

  # @function: Display a list of all assigned IPs.
  function __hhs_all_ips() {

    local all_ips

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    all_ips=$(ifconfig -a | grep -o "inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)" | awk "{ sub(/inet6? (addr:)? ?/, \"\"); print }")

    [[ -n "$all_ips" ]] && echo "${all_ips}" && return 0

    return 1
  }

  # @function: Display local IP's of active interfaces.
  function __hhs_local_ip() {

    local local_ips

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    if __hhs_has "pcregrep"; then
      local_ips="$(ifa | grep -o "^en[0-9]\|^eth[0-9]")"
      for iface in ${local_ips}; do
        echo "IP-Local(${iface}) : $(ipconfig getifaddr "${iface}")"
      done
      [[ -z "$local_ips" ]] && echo "IP-Local(---) : ${YELLOW}Unable to get${HHS_HIGHLIGHT_COLOR}" && return 1
    else
      echo "IP-Local(---) : ${YELLOW}pcregrep is required to use ${FUNCNAME[0]} ${HHS_HIGHLIGHT_COLOR}"
      return 1
    fi

    [[ -n "$local_ips" ]] && return 0

    return 1
  }

  # @function: Display a list of active network interfaces.
  function __hhs_active_ifaces() {

    local ifaces

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    if __hhs_has "pcregrep"; then
      ifaces=$(ifconfig | pcregrep -M -o "^[^\t:]+:([^\n]|\n\t)*status: active")
    else
      echo "${YELLOW}pcregrep is required to use ${FUNCNAME[0]} ${HHS_HIGHLIGHT_COLOR}"
      return 1
    fi

    [[ -n "$ifaces" ]] && echo "${ifaces}" && return 0

    return 1
  }

  # @function: Get the IP associated to the active VPN connection.
  function __hhs_vpn_ip() {

    local vpn_ip iface_prefix="${1:-'tun'}"

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    vpn_ip=$(ifconfig | grep -A1 ".*${iface_prefix}[0-9]" | grep 'inet ' | cut -d ' ' -f2)

    [[ -n "$vpn_ip" ]] && echo "${vpn_ip}" && return 0

    return 1
  }

fi

# @function: Get IP or hostname of the default gateway.
function __hhs_gateway_ip() {

  local gw_ip

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]}"
    return 1
  fi

  gw_ip=$(route get default 2> /dev/null)

  if [[ -n "${gw_ip}" ]]; then
    echo "${gw_ip}" | grep 'gateway' | cut -b 14-
    return $?
  fi

  return 1
}

# @function: Retrieve information about the specified IP.
# @param $1 [Req] : The IP to get information about.
function __hhs_ip_info() {

  local ipinfo

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <IPv4_address>"
    return 1
  else
    ipinfo=$(curl -m 5 --basic "ip-api.com/json/$1" 2> /dev/null | tr ' ' '_')
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

  local state port re='(((([0-9]{1,3})\.){3}[0-9]{1,3})|\*)'

  if [[ "$#" -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <port_number> [port_state]"
    echo ''
    echo '  Notes: '
    echo '    States: One of [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]'
    return 1
  elif [[ -n "$1" && -n "$2" ]]; then
    port=${1:0:5}
    state=$(echo "$2" | tr '[:lower:]' '[:upper:]')
    if [[ "$state" =~ ^(CLOSE_WAIT|ESTABLISHED|FIN_WAIT_2|TIME_WAIT|LISTEN)$ ]]; then
      echo -e "\n${YELLOW}Checking for ports \"$port\" with current state of \"$state\" ${NC}\n"
      echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
      netstat -an | grep -E "${re}(\.${port})" | hl "$state"
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: ## Invalid state \"$state\". Use one of [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]"
    fi
  elif [[ -n "$1" && -z "$2" ]]; then
    port=${1:0:5}
    echo -e "\n${YELLOW}Checking for \"ALL\" ports ($port) with any state ${NC}\n"
    echo "Proto Recv-Q Send-Q  Local Address          Foreign Address        (state) "
    netstat -an | grep -E "${re}(\.${port})" | hl "$port"
    return $?
  fi
  echo ''

  return 0
}
