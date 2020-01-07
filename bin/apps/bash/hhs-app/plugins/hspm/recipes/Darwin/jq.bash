function about() {
  echo "Jq is a lightweight and flexible command-line JSON processor."
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install jq${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install jq
  return $?
}

function uninstall() {
  command brew uninstall jq
  return $?
}
