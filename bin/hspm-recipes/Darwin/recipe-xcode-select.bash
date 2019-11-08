#!/usr/bin/env bash

function about() {
  echo "Gives Mac terminal users many commonly used tools, utilities, and compilers"
}

function depends() {

  return 0
}

function install() {
  xcode-select --install
  return $?
}

function uninstall() {
  echo "${YELLOW}### There is no automated way to uninstall this app. Consult XCode uninstallation manual${NC}"
  return $?
}
