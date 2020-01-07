function about() {
  echo "Gradle helps teams build, automate and deliver better software, faster"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install gradle${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install gradle
  return $?
}

function uninstall() {
  command brew uninstall gradle
  return $?
}
