function about() {
  echo "Generate documentation from source code"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install doxygen${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install doxygen
  return $?
}

function uninstall() {
  command brew uninstall doxygen
  return $?
}
