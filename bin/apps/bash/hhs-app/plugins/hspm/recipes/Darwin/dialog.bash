function about() {
  echo "Dialog allows creating text-based color dialog boxes from any shell script language"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install dialog${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install dialog
  return $?
}

function uninstall() {
  command brew uninstall dialog
  return $?
}
