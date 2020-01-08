function about() {
  echo "An interactive process viewer for Unix"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install htop${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install htop
  return $?
}

function uninstall() {
  command brew uninstall htop
  return $?
}
