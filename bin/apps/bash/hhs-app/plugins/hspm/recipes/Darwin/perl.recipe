function about() {
  echo "Perl is a highly capable, feature-rich programming language with over 30 years of development"
}

function depends() {
  if ! command -v brew >/dev/null; then
    echo "${RED}HomeBrew is required to install perl${NC}"
    return 1
  fi

  return 0
}

function install() {
  command brew install perl
  return $?
}

function uninstall() {
  command brew uninstall perl
  return $?
}
