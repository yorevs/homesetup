function about() {
  echo "Is a command line tool to help you forget how to set the JAVA_HOME environment variable"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install jenv${NC}"
    return 1
  fi

  return 0
}

function install() {
  unset nvm
  command brew install jenv
  return $?
}

function uninstall() {
  command brew uninstall jenv
  unset nvm
  return $?
}
