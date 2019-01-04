#!/usr/bin/env bash

function about() {
    echo "Is a command line tool to help you forget how to set the JAVA_HOME environment variable"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install htop${NC}"
        return 1
    fi

    return 0
}

function install() {
    command brew install jenv
    return $?
}

function uninstall() {
    command brew uninstall jenv
    return $?
}