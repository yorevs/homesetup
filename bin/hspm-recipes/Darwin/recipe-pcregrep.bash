#!/usr/bin/env bash

function about() {
  echo "Searches files for character patterns, but it uses the PCRE regular expression library"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install pcregrep${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install pcre
  return $?
}

function uninstall() {
  command brew uninstall pcre
  return $?
}
