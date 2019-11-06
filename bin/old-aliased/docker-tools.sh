#!/usr/bin/env bash

#  Script: hhs-docker-tools.sh
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "docker" && docker info &> /dev/null; then

    # @function: TODO Comment it
    __hhs_docker_exec() {
        if [ -n "$2" ]; then
            docker exec -it "$1" "$2"
        else
            docker exec -it "$1" /bin/sh
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

fi
