function about() {
  echo "Maven is a software project management and comprehension tool"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install mvn${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install maven
  return $?
}

function uninstall() {
  command brew uninstall maven
  return $?
}
