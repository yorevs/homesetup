#!/usr/bin/env bash

function about() {
    echo "Ruby enVironment (Version) Manager (RVM)"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install jenv${NC}"
        return 1
    fi

    return 0
}

function install() {
    local ret
    unset nvm
    command brew install gnupg
    ret=$?
    if [ $ret -eq 0 ]; then
        gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        ret=$?
        if [ $ret -eq 0 ]; then
            curl -sSL https://get.rvm.io | bash -s stable --ruby
            ret=$?
        fi
    fi

    return $ret
}

function uninstall() {
    local ret
    command brew uninstall gnupg
    ret=$?
    if [ $ret -eq 0 ]; then
        rvm implode
        [ -d "$RVM_DIR" ] && rm -rf "$RVM_DIR"
        unset nvm
    fi

    return $ret
}