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
  function __hhs_docker_count() {
    count=$(docker container ls | wc -l | awk '{print $1}')
    echo "${count:-0}"
    
    return 0
  }

  # @function: TODO Comment it
  # @param $1 [Req] : TODO Comment it
  # @param $2 [Opt] : TODO Comment it
  function __hhs_docker_exec() {
    if [[ $# -lt 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <container_id> [shell_cmd]"
      return 1
    elif [[ $# -ge 2 ]]; then
      docker exec -it "${@}"
    else
      docker exec -it "$1" '/bin/bash'
    fi

    return $?
  }

  # @function: TODO Comment it
  # @param $1 [Req] : TODO Comment it
  function __hhs_docker_compose_exec() {
    if [[ $# -lt 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <container_id> [shell_cmd]"
      return 1
    elif [[ $# -ge 2 ]]; then
      docker-compose exec "${@}"
    else
      docker-compose exec "$1" '/bin/bash'
    fi

    return $?
  }

  # @function: Display information about the container
  # @param $1 [Req] : TODO Comment it
  function __hhs_docker_info() {
    if [[ $# -ne 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    else
      docker ps | grep "$1" | awk '"'"'{print $1}'"'"'
    fi

    return $?
  }

  # @function: Tail container logs
  # @param $1 [Req] : TODO Comment it
  function __hhs_docker_tail_logs() {
    if [[ $# -ne 1 ]] || [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    else
      docker logs -f "$1"
    fi

    return $?
  }

  # shellcheck disable=SC2181
  # @function: TODO Comment it
  function __hhs_docker_remove_volumes() {
    if [ -n "$1" ] && [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]}"
    elif [ -z "$1" ]; then
      for container in $(docker volume ls -qf dangling=true); do
        echo -en "Removing Docker volume: ${container} ... "
        docker volume rm "${container}" &> /dev/null
        [[ $? -eq 0 ]] && echo -e "[   ${GREEN}OK${NC}   ]"
      done
    fi

    return 0
  }

  # shellcheck disable=SC2181
  # @function: TODO Comment it
  function __hhs_docker_kill_all() {
    if [ -n "$1" ] && [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
      echo "Usage: ${FUNCNAME[0]}"
    elif [ -z "$1" ]; then
      for container in $(docker ps --format "{{.ID}}"); do
        echo -en "Killing Docker volume: ${container} ... "
        docker stop "${container}" &> /dev/null
        docker rm "${container}" &> /dev/null
        [[ $? -eq 0 ]] && echo -e "[   ${GREEN}OK${NC}   ]"
      done
      __hhs_docker_remove_volumes "$@"
    fi

    return 0
  }

fi
