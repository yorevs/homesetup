#!/bin/bash

if [[ $# -lt 1 || "${1}" == -h || "${1}" == --help ]]; then
  echo 'Usage: build.bash <container_type...>'
  echo ''
  echo '  Arguments'
  echo '    - container_type  : The OS to be installed. One of [ubuntu|centos|fedora]'
else
  containers="$(find . -type d -mindepth 1 | tr '\n' ' ')"
  containers="${containers//\.\//}"
  for next_container in "${@}"; do
    if [[ "${containers}" == *"${next_container}"* ]]; then
      [[ -d "${next_container}/" ]] || echo -e "${RED}Unable to find directory: ${next_container}/${NC}"
      echo -e "Building '${next_container}' ... "
      [[ -d "${next_container}/" ]] && docker build -t "yorevs/hhs-${next_container}" "${next_container}/"
    else
      echo "${RED}Invalid container type: \"${next_container}\". Please use one of [${containers}] ! ${NC}"
    fi
  done
fi
