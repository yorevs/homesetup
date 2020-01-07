function about() {
  echo "Tree is a recursive directory listing program that produces a depth-indented listing of files"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install tree${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install tree
  return $?
}

function uninstall() {
  command brew uninstall tree
  return $?
}
