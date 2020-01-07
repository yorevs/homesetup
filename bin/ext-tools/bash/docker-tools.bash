#!/usr/bin/env bash

#  Script: hhs-docker-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "docker" && docker info &> /dev/null; then

  # @function: TODO Comment it
  __hhs_docker_exec() {
    if [[ $# -ge 2 ]]; then
      docker exec -it "${@}"
    else
      docker exec -it "$1" /bin/sh
    fi

    return $?
  }

  # @function: TODO Comment it
  __hhs_docker_compose_exec() {
    if [[ $# -ge 2 ]]; then
      docker-compose exec "${@}"
    else
      docker-compose exec "$1" /bin/sh
    fi

    return $?
  }

  # @function: TODO Comment it
  __hhs_docker_pidof() {
    docker ps | grep "$1" | awk '"'"'{print $1}'"'"'

    return $?
  }

  # @function: TODO Comment it
  __hhs_docker_tail_logs() {
    docker logs -f "$(docker ps | grep "$1" | awk '"'"'{print $1}'"'"')"

    return $?
  }

  # shellcheck disable=SC2181
  # @function: TODO Comment it
  __hhs_docker_remove_volumes() {
    for container in $(docker volume ls -qf dangling=true); do
      echo -en "Removing Docker volume: ${container} ... "
      docker volume rm "${container}" &> /dev/null
      [[ $? -eq 0 ]] && echo -e "[   ${GREEN}OK${NC}   ]" 
    done
  }

  # shellcheck disable=SC2181
  # @function: TODO Comment it
  __hhs_docker_kill_all() {
    for container in $(docker ps --format "{{.ID}}"); do
      echo -en "Killing Docker volume: ${container} ... "
      docker stop "${container}" &> /dev/null
      docker rm "${container}" &> /dev/null
      [[ $? -eq 0 ]] && echo -e "[   ${GREEN}OK${NC}   ]" 
    done
    __hhs_docker_remove_volumes
  }

fi
