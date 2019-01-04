#!/usr/bin/env bash
# shellcheck disable=SC1090

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

function about() {
    echo "Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install node${NC}"
        return 1
    elif ! command -v nvm >/dev/null; then
        echo "${RED}nvm is required to install node${NC}"
    fi

    return 0
}

function install() {
    nvm install node
    return $?
}

function uninstall() {
    nvm deactivate node
    nvm uninstall node
    return $?
}