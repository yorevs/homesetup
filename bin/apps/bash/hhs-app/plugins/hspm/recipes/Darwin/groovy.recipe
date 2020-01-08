function about() {
  echo "A multi-faceted language for the Java platform"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install groovy${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install groovy
  return $?
}

function uninstall() {
  command brew uninstall groovy
  return $?
}