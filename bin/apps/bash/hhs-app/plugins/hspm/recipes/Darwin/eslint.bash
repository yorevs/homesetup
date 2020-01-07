function about() {
  echo "Linter tool for identifying and reporting on patterns in JavaScript."
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install eslint${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install eslint
  return $?
}

function uninstall() {
  command brew uninstall eslint
  return $?
}
