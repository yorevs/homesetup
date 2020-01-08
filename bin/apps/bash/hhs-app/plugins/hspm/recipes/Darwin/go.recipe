function about() {
  echo "Go is an open source programming language that makes it easy to build simple, reliable, and efficient software"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install go${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install go
  return $?
}

function uninstall() {
  command brew uninstall go
  return $?
}