#!/usr/bin/env bash

function about() {
    echo "Subversion is an open source version control system"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install svn${NC}"
        return 1
    fi

    return 0
}

function install() {
    command brew install svn
    return $?
}

function uninstall() {
    command brew uninstall svn
    return $?
}