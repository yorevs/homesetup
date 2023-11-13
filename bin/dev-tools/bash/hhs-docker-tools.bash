#!/usr/bin/env bash

#  Script: hhs-docker-tools.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# Docker documentation can be found at:
#   https://docs.docker.com/v17.09/engine/reference/commandline/exec/

if [[ -n "${HHS_HAS_DOCKER}" ]]; then

  # @function: Count the number of active docker containers.
  function __hhs_docker_count() {

    local count

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
      return 1
    fi

    count=$(docker container ls -q | wc -l | awk '{print $1}')
    echo "${count:-0}"

    return 0
  }

  # @function: Display information about the container.
  # @param $1 [Req] : The running container ID.
  function __hhs_docker_info() {
    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    fi
    \docker ps | grep "$1" | awk '"'"'{print $1}'"'"'

    return $?
  }

  # @function: Run a command or bash in a running container.
  # @param $1 [Req] : The running container ID.
  # @param $2 [Opt] : The command to be executed on the container.
  function __hhs_docker_exec() {

    if [[ $# -lt 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id> [shell_cmd]"
      echo ''
      echo '  Notes: '
      echo '    - If shell_cmd is not provided /bin/bash will be used.'
      return 1
    elif [[ $# -ge 2 ]]; then
      \docker exec -it "${@}"
    else
      \docker exec -it "$1" '/bin/bash'
    fi

    return $?
  }

  # @function: This is the equivalent of docker exec, but for docker-compose.
  # @param $1 [Req] : The running container ID.
  # @param $2 [Opt] : The command to be executed.
  function __hhs_docker_compose_exec() {

    if [[ $# -lt 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id> [shell_cmd]"
      echo ''
      echo '  Notes: '
      echo '    - If shell_cmd is not provided /bin/bash will be used.'
      return 1
    elif [[ $# -ge 2 ]]; then
      \docker-compose exec "${@}"
    else
      \docker-compose exec "$1" '/bin/bash'
    fi

    return $?
  }

  # @function: Fetch the logs of a container.
  # @param $1 [Req] : The running container ID.
  function __hhs_docker_logs() {

    if [[ $# -ne 1 || '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} <container_id>"
      return 1
    fi
    \docker logs -f "$1"

    return $?
  }

  # @function: Remove all docker volumes not referenced by any containers (dangling).
  function __hhs_docker_remove_volumes() {

    local volumes=() retVal=0

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]}"
    else
      read -d '' -r -a volumes <<<"$(docker volume ls -qf dangling=true)"
      for container in "${volumes[@]}"; do
        echo -en "Removing dangling docker volume: ${container} ... "
        if docker volume rm "${container}" &>/dev/null; then
          echo -e "[   ${GREEN}OK${NC}   ]"
        else
          echo -e "[ ${GREEN}FAILED${NC} ]"
          retVal=1
        fi
      done
    fi

    return $retVal
  }

  # @function: Stop, remove and remove dangling [active?] volumes of all docker containers.
  # @param $1 [Opt] : Option to remove active containers as well.
  function __hhs_docker_kill_all() {

    local all_containers=() all

    if [[ '-h' == "$1" || '--help' == "$1" ]]; then
      echo "Usage: ${FUNCNAME[0]} [-a]"
      echo ''
      echo '    Options: '
      echo '      -a : Remove active and inactive volumes; otherwise it will only remove inactive ones'
    else

      [[ "${1}" == '-a' ]] && all="-a" && shift
      read -r -d '' -a all_containers <<<"$(docker ps ${all} --format "{{.ID}}")"

      for container in "${all_containers[@]}"; do
        echo -en "Stopping Docker container: ${container} ... "
        if docker stop "${container}" &>/dev/null; then
          echo -e "[   ${GREEN}OK${NC}   ]"
          echo -en "Removing Docker container: ${container} ... "
          if docker rm "${container}" &>/dev/null; then
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
