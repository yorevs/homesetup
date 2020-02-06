#!/usr/bin/env bash

#  Script: hhs-docker-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions
#
# Docker documentation can be found at:
#   https://docs.docker.com/v17.09/engine/reference/commandline/exec/

if __hhs_has "docker" && docker info &> /dev/null; then

  # @function: Return the number of active docker containers
  function __hhs_docker_count() {

    count=$(docker container ls | wc -l | awk '{print $1}')
    echo "${count:-0}"

    return 0
  }

  # @function: Run a command or bash in a running container
  # @param $1 [Req] : The running container ID
  # @param $2 [Opt] : The command to be executed
  function __hhs_docker_exec() {

    if [[ $# -lt 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id> [shell_cmd]"
      return 1
    elif [[ $# -ge 2 ]]; then
      docker exec -it "${@}"
    else
      docker exec -it "$1" '/bin/bash'
    fi

    return $?
  }

  # @function: This is the equivalent of docker exec, but for docker-compose
  # @param $1 [Req] : The running container ID
  # @param $2 [Opt] : The command to be executed
  function __hhs_docker_compose_exec() {

    if [[ $# -lt 1 || '-h' == "$1" || '--help' == "$1" ]]; then
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
  # @param $1 [Req] : The running container ID
  function __hhs_docker_info() {
    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    fi
    docker ps | grep "$1" | awk '"'"'{print $1}'"'"'

    return $?
  }

  # @function: Fetch the logs of a container
  # @param $1 [Req] : The running container ID
  function __hhs_docker_logs() {

    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    fi
    docker logs -f "$1"

    return $?
  }

  # @function: Remove all docker volumes not referenced by any containers (dangling)
  function __hhs_docker_remove_volumes() {

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
    else
      for container in $(docker volume ls -qf dangling=true); do
        echo -en "Removing dangling docker volume: ${container} ... "
        if docker volume rm "${container}" &> /dev/null; then
          echo -e "[   ${GREEN}OK${NC}   ]"
          return 0
        else
          echo -e "[ ${GREEN}FAILED${NC} ]"
        fi
      done
    fi

    return 1
  }

  # shellcheck disable=SC2181
  # @function: Stop, remove and remove dangling [active?] volumes of all docker containers
  function __hhs_docker_kill_all() {

    local all_containers=() all

    [[ "${1}" == '-a' ]] && all="-a" && shift

    read -r -d '' -a all_containers <<< "$(docker ps ${all} --format "{{.ID}}")"

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} [-a]"
    else
      for container in "${all_containers[@]}"; do
        echo -en "Stopping Docker container: ${container} ... "
        if docker stop "${container}" &> /dev/null; then
          echo -e "[   ${GREEN}OK${NC}   ]"
          echo -en "Removing Docker container: ${container} ... "
          if docker rm "${container}" &> /dev/null; then
            echo -e "[   ${GREEN}OK${NC}   ]"
          else
            echo -e "[ ${RED}FAILED${NC} ]"
          fi
        else
          echo -e "[ ${RED}FAILED${NC} ]"
        fi
      done
      __hhs_docker_remove_volumes "$@"
    fi

    return 0
  }

fi
