#!/usr/bin/env bash

function about() {
  echo "Is an open source static anaylsis tool that automatically finds bugs in your shell scripts."
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install shellcheck${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install shellcheck
  return $?
}

function uninstall() {
  command brew uninstall shellcheck
  return $?
}
