function about() {
  echo "FIGlet is a program for making large letters out of ordinary text"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install figlet${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install figlet
  return $?
}

function uninstall() {
  command brew uninstall figlet
  return $?
}
