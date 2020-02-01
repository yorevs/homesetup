#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2034

#  Script: check-ip.bash
# Purpose: Validate and check IP information.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=2.0.0

# This script name.
APP_NAME="${0##*/}"

# Help message to be displayed by the script.
USAGE="
Usage: ${APP_NAME} [Options] <ip_address>

    Options:
      -q | --quiet  : Silent mode. Do not check for IP details.
      -i | --info   : Fetch additional information from the web.
"

# Functions to be unset after quit
UNSETS=(check_class check_scope check_valid)

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# The IP to be validated.
IP_OCTETS=()
IP_ADDRESS=
IP_VALID=
IP_CLASS=
IP_SCOPE=

# Modes
SILENT=0     # Not set
EXTRA_INFO=0 # Not set

# – Class A addresses: Large numbers of nodes – Intended for a LARGE organisation
#     IP = Net.Node.Node.Node
# - Class B addresses: Medium number of nodes
#     IP = Net.Net.Node.Node
# – Class C addresses: Small number of nodes- Intended for a SMALL organisation
#     IP = Net.Net.Net.Node
# - Class D and E: RESERVED
#
# IP<private>   Class A addresses: [     0.0.0.0 - 127.255.255.255 ] => 0XXXXXXX
# IP<private>   Class B addresses: [   128.0.0.0 - 191.255.255.255 ] => 10XXXXXX
# IP<private>   Class C addresses: [   192.0.0.0 - 223.255.255.255 ] => 110xxxxx
# IP<multicast> Class D addresses: [   224.0.0.1 - 239.255.255.255 ] =>
# IP<reserved>  Class E addresses: [   240.0.0.1 - 255.255.255.254 ] =>

# Purpose: Find the IP class.
check_class() {

  if [[ ${IP_OCTETS[0]} -le 127 ]]; then
    IP_CLASS="A"
  elif [[ ${IP_OCTETS[0]} -gt 127 ]] && [[ ${IP_OCTETS[0]} -le 191 ]]; then
    IP_CLASS="B"
  elif [[ ${IP_OCTETS[0]} -ge 192 ]] && [[ ${IP_OCTETS[0]} -le 223 ]]; then
    IP_CLASS="C"
  elif [[ ${IP_OCTETS[0]} -ge 224 ]] && [[ ${IP_OCTETS[0]} -le 239 ]]; then
    IP_CLASS="D"
  elif [[ ${IP_OCTETS[0]} -ge 240 ]] && [[ ${IP_OCTETS[0]} -le 255 ]]; then
    IP_CLASS="E"
  fi
}

# Range                             | Scope           | Description
# ----------------------------------|----------------------------------
#         0.0.0.0 - 0.255.255.255   | private network | "This" Network
#        10.0.0.0 - 10.255.255.255  | private network | Private-Use Networks
#      100.64.0.0 - 100.127.255.255 | private network | Private network
#       127.0.0.0 - 127.255.255.255 | host            | Loopback
#     169.254.0.0 - 169.254.255.255 | subnet          | Link Local
#      172.16.0.0 - 172.31.255.255  | private network | Private-Use Networks
#       192.0.0.0 - 192.0.0.255     | private network | IETF Protocol Assignments
#       192.0.2.0 - 192.0.2.255     | documentation   | TEST-NET-1
#     192.88.99.0 - 192.88.99.255   | Internet        | 6to4 Relay Anycast
#     192.168.0.0 - 192.168.255.255 | private network | Private-Use Networks
#      198.18.0.0 - 198.19.255.255  | private network | Network Interconnect Device Benchmark Testing
#    198.51.100.0 - 198.51.100.255  | documentation   | TEST-NET-2
#     203.0.113.0 - 203.0.113.255   | documentation   | TEST-NET-3
#       224.0.0.0 - 239.255.255.255 | Internet        | Multicast
#       240.0.0.0 - 255.255.255.254 | n/a             | Reserved
# 255.255.255.255                   | n/a             | Limited Broadcast

# Purpose: Find the IP scope.
# @param $1 [Req] : The IP to get the scope from
check_scope() {
  
  if [[ ${IP_OCTETS[0]} -eq 0 ]]; then
    IP_SCOPE="'This' Network"
  elif [[ ${IP_OCTETS[0]} -eq 10 ]]; then
    IP_SCOPE="Private" # Private Use Networks
  elif [[ ${IP_OCTETS[0]} -eq 100 ]] && [[ ${IP_OCTETS[1]} -ge 64 ]] && [[ ${IP_OCTETS[1]} -le 127 ]]; then
    IP_SCOPE="Private" # Private Networks
  elif [[ ${IP_OCTETS[0]} -eq 127 ]]; then
    IP_SCOPE="Loopback" # Host -> Loopback
  elif [[ ${IP_OCTETS[0]} -eq 169 ]] && [[ ${IP_OCTETS[1]} -eq 254 ]]; then
    IP_SCOPE="Link Local" # Subnet -> Link Local : Auto-Assigned IP for no DHCP
  elif [[ ${IP_OCTETS[0]} -eq 172 ]] && [[ ${IP_OCTETS[1]} -le 31 ]]; then
    IP_SCOPE="Private" # Private Use Networks
  elif [ "${IP_ADDRESS%\.*}" = "192.0.0" ]; then
    IP_SCOPE="Private" # IETF Protocol Assignments
  elif [ "${IP_ADDRESS%\.*}" = "192.0.2" ]; then
    IP_SCOPE="TEST-NET-1" # Documentation -> TEST-NET-1
  elif [ "${IP_ADDRESS%\.*}" = "192.88.99" ]; then
    IP_SCOPE="Anycast" # Internet -> 6to4 Relay Anycast
  elif [[ ${IP_OCTETS[0]} -eq 192 ]] && [[ ${IP_OCTETS[1]} -eq 168 ]]; then
    IP_SCOPE="Private" # Private Use Networks
  elif [[ ${IP_OCTETS[0]} -eq 198 ]] && [[ ${IP_OCTETS[1]} -ge 18 ]] && [[ ${IP_OCTETS[1]} -le 19 ]]; then
    IP_SCOPE="Private" # Private Use Networks
  elif [ "${IP_ADDRESS%\.*}" = "198.51.100" ]; then
    IP_SCOPE="TEST-NET-2" # Documentation -> TEST-NET-2
  elif [ "${IP_ADDRESS%\.*}" = "203.0.113" ]; then
    IP_SCOPE="TEST-NET-3" # Documentation -> TEST-NET-3
  elif [[ ${IP_OCTETS[0]} -ge 224 ]] && [[ ${IP_OCTETS[0]} -le 239 ]]; then
    IP_SCOPE="Multicast" # Internet -> Multicast
  elif [[ ${IP_OCTETS[0]} -ge 240 ]] && [[ ${IP_OCTETS[0]} -le 255 ]] && [ "${IP_ADDRESS##*\.}" = "254" ]; then
    IP_SCOPE="Reserved" # n/a -> Reserved
  elif [ "${IP_ADDRESS}" = "255.255.255.255" ]; then
    IP_SCOPE="Limited Broadcast"
  else
    IP_SCOPE="Public"
  fi
}

# Purpose: Validate the IP. Required format [0-255].[0-255].[0-255].[0-255] .
check_valid() {

  ip_regex="((2((5[0-5])|[0-4][0-9])|(1([0-9]{2}))|(0|([1-9][0-9]))|([0-9]))\.){3}(2((5[0-5])|[0-4][0-9])|(1([0-9]{2}))|(0|([1-9][0-9]))|([0-9]))"

  # On Mac option -r does not exist, -E on linux option does not exist
  [ "$(uname -s)" = "Linux" ] && sflag='-r'
  [ "$(uname -s)" = "Darwin" ] && sflag='-E'
  is_valid=$(echo "${IP_ADDRESS}" | sed $sflag "s/${ip_regex}/VALIDIP/")

  # Inverted because we will use it as exit code
  if [ "${is_valid}" != "VALIDIP" ]; then
    IP_VALID=1
  else
    IP_VALID=0
  fi
}

# ------------------------------------------
# Purpose: Program entry point
main() {

  check_valid

  # Final result
  if [[ ${IP_VALID} -eq 0 ]]; then
    if [[ $SILENT -eq 0 ]]; then
      check_class "${IP_ADDRESS}"
      check_scope "${IP_ADDRESS}"
      echo "Valid IP: ${IP_ADDRESS}, Class: $IP_CLASS, Scope: $IP_SCOPE"
      [[ $EXTRA_INFO -eq 0 ]] || __hhs_ip_info "${IP_ADDRESS}"
    fi
  else
    [[ $SILENT -eq 0 ]] && echo "## Invalid IP: ${IP_ADDRESS} ##"
  fi
}

# If no argument is passed, just enter HomeSetup directory
if [[ ${#} -eq 0 ]]; then
  usage 0
fi

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while [[ ${#} -gt 0 ]]; do
  case "${1}" in
    -h | --help)
      usage 0
      ;;
    -v | --version)
      version
      ;;
    -q | --quiet)
      SILENT=1
      ;;
    -i | --info)
      EXTRA_INFO=1
      ;;

    *)
      break
      ;;
  esac
  shift
done

IP_ADDRESS="${1}"
IFS='.' read -r -a IP_OCTETS <<< "${IP_ADDRESS}"

main "${@}"
quit ${IP_VALID}
