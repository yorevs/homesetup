#!/usr/bin/env bash

function about() {
    echo "Our mission is to drive processes described in build files as targets and extension points dependent upon each other"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install ant${NC}"
        return 1
    fi

    return 0
}

function install() {
    command brew install ant
    return $?
}

function uninstall() {
    command brew uninstall ant
    return $?
}