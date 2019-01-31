#!/usr/bin/env bash

function about() {
    echo "Qt | Cross-platform software development for embedded & desktop"
}

function depends() {
    if ! command -v brew >/dev/null; then
        echo "${RED}HomeBrew is required to install qmake${NC}"
        return 1
    fi

    return 0
}

function install() {
    command brew install qt
    local ret=$?
    sed -i '' -E -e "s#(^/usr/local/opt/qt/bin$)*##g" -e '/^\s*$/d' "$PATHS_FILE"
    echo '/usr/local/opt/qt/bin' >> "$PATHS_FILE"
    export PATH="/usr/local/opt/qt/bin:$PATH"
    if ! command -v qmake >/dev/null; then return 1; fi

    return $ret
}

function uninstall() {
    command brew uninstall qt
    local ret=$?
    sed -i '' -E -e "s#(^/usr/local/opt/qt/bin$)*##g" -e '/^\s*$/d' "$PATHS_FILE"
    export PATH="${PATH//\/usr\/local\/opt\/qt\/bin}"
    if command -v qmake >/dev/null; then return 1; fi

    return $?
}