#!/usr/bin/env bash

function about() {
    echo "The missing package manager for macOS"
}

function depends() {
    if ! command -v xcode-select >/dev/null; then
        echo "${RED}XCode is required to install HomeBrew${NC}"
        return 1
    elif ! command -v ruby >/dev/null; then
        echo "${RED}Ruby is required to install HomeBrew${NC}"
        return 1
    fi

    return 0
}

function install() {
    command ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    return $?
}

function uninstall() {
    command ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    return $?
}