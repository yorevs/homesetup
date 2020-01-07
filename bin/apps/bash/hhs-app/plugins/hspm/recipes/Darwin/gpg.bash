function about() {
  echo "Compute SHA message digests"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install gpg${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install gpg
  return $?
}

function uninstall() {
  command brew uninstall gpg
  return $?
}
