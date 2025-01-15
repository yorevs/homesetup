#!/usr/bin/env bash

JDK_SEARCH_DIR=${JDK_SEARCH_DIR:-"/Library/Java/JavaVirtualMachines"}

USAGE="usage: sudo java-switch <jdk_ver>"

if [[ ! -d "${JDK_SEARCH_DIR}" && ! -L "${JDK_SEARCH_DIR}" ]]; then
    echo -e "\033[31mUnable to find the JDK search dir: '${JDK_SEARCH_DIR}'\033[m" && exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "${USAGE}" && exit 1
fi

if [ "${EUID}" -ne 0 ]; then
    echo -e "\033[31mPlease execute as root (sudo)\033[m"
    exit 127
fi

echo -e "[JDK] Checking for installed JDK versions at: '\033[34m${JDK_SEARCH_DIR}\033[m'..."
for jdk_ver in "${JDK_SEARCH_DIR}"/**.jdk; do

    jdk="$(basename "${jdk_ver}")"
    jdk_ver="${jdk%%\.*}"
    jdk_ver="${jdk_ver#*\-}"

    [[ "$jdk_ver" -eq "$1" ]] && TO_JDK="${jdk}"

    if [[ -n "${TO_JDK}" ]]; then
        echo -e "[JDK] Switching to JDK: '\033[32m${TO_JDK}\033[m'"
        [[ -L "${JDK_SEARCH_DIR}/Current" ]] && sudo rm -f "${JDK_SEARCH_DIR}/Current"
        if [[ -d "${JDK_SEARCH_DIR}/${TO_JDK}" || -L "${JDK_SEARCH_DIR}/${TO_JDK}" ]]; then
            echo -n "[JDK] "
            sudo ln -sfv "${JDK_SEARCH_DIR}/${TO_JDK}" "${JDK_SEARCH_DIR}/Current"
            [[ -d "${JDK_SEARCH_DIR}/Current" || -L "${JDK_SEARCH_DIR}/Current" ]] && exit 0
        else
            echo -e "\033[31m[JDK] Unable to find required JDK -> ${TO_JDK}\033[m" && exit 1
        fi
    fi

done

echo -e "\033[31m[JDK] Unable to find required JDK -> ${1}\033[m" && exit 1
