#!/bin/bash

if [[ $# -lt 1 || "${1}" == -h || "${1}" == --help ]]; then
  echo "Usage: docker-build.sh <container_type...>"
  echo ''
  echo '  Arguments'
  echo '    - container_type  : The OS to be installed. One of [ubuntu|centos|fedora]'
else
  containers="$(find . -type d -mindepth 1 | tr '\n' ' ')"
  containers="${containers//\.\//}"
  for next_container in "${@}"; do
    if [[ "${containers}" == *"${next_container}"* ]]; then
      [[ -d "${next_container}/" ]] || echo -e "${RED}Unable to find directory: ${next_container}/${NC}"
      echo ''
      echo -e "${PURPLE}Building ${BLUE}[${next_container}] ... ${NC}"
      echo ''
      if [[ -d "${next_container}/" ]] && \
          ! docker build --no-cache -t "yorevs/hhs-${next_container}" "${next_container}/"; then
        exit 1
      fi
      
    else
      echo "${RED}Invalid container type: \"${next_container}\". Please use one of [${containers}] ! ${NC}"
    fi
  done
fi
