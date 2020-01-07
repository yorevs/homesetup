#!/usr/bin/env bash

function about() {
  echo "Python is a programming language that lets you work quickly and integrate systems more effectively"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install python${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install python
  return $?
}

function uninstall() {
  command brew uninstall python
  return $?
}