#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090,SC2034

#  Script: dotfiles.bash
# Purpose: Manage your HomeSetup dotfiles and more
# Created: Oct 25, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME <command> [<args>]

    Commands:
        FB | firebase   : Execute Firebase tasks; type: '$APP_NAME help FB' for details.
        H  | help       : Provides a help about the command.
"

# Functions to be unset after quit
UNSETS=( exec_command cmd_help cmd_firebase load_fb_settings download_dotfiles \
    parse_and_save_dotfiles build_dotfiles_payload trim upload_dotfiles )

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Firebase configuration file.
FIREBASE_FILE="$HHS_DIR/.firebase"

# Firebase json response file.
DOTFILES_FILE="$HHS_DIR/dotfiles.json"

# Firebase response regex.
FB_RE_RESP='^\{(("aliases":".*")*(,*"commands":".*")*(,*"colors":".*")*(,*"env":".*")*(,*"functions":".*")*(,*"path":".*")*(,*"profile":".*")*(,*"savedDirs":".*")*(,*"aliasdef":".*")*)+\}$'

# File to store the saved commands.
HHS_CMD_FILE=${HHS_CMD_FILE:-$HHS_DIR/.cmd_file}

# File to store the saved directories.
HHS_SAVED_DIRS=${HHS_SAVED_DIRS:-$HHS_DIR/.saved_dirs}

# Loads Firebase settings from file.
load_fb_settings() {

  [ -f "$FIREBASE_FILE" ] || quit 2 "Your need to setup your Firebase credentials first."
  [ -f "$FIREBASE_FILE" ] && \. "$FIREBASE_FILE"
  [ -z "$PROJECT_ID" ] || [ -z "$FIREBASE_URL" ] || [ -z "$PASSPHRASE" ] || [ -z "$UUID" ] && quit 2 "Invalid settings file!"

  return 0
}

# Download the User dotfiles from Firebase.
download_dotfiles() {

  local fb_alias="$1"

  rm -f "$DOTFILES_FILE"
  fetch.bash GET --silent "$FIREBASE_URL/dotfiles/$UUID/${fb_alias}.json" >"$DOTFILES_FILE"
  ret=$?

  if [ $ret -eq 0 ] && [ -f "$DOTFILES_FILE" ] && [[ "$(grep . "$DOTFILES_FILE")" =~ ${FB_RE_RESP// /} ]]; then
    echo -e "\n${GREEN}Dotfiles \"${fb_alias}\" sucessfully downloaded!${NC}"
  else
    quit 2 "Failed to download \"${fb_alias}\" Dotfiles!"
  fi

  return 0
}

# Build the dotfiles jso payload.
build_dotfiles_payload() {

  local f_aliases f_colors f_env f_functions f_path f_profile f_cmdFile f_savedDirs f_aliasdef
  local payload=''
  local match=', } }'
  local repl=' } }'

  # Encode all present dotfiles
  [ -f "$HOME"/.aliases ] && f_aliases=$(grep . "$HOME"/.aliases | base64)
  [ -f "$HOME"/.colors ] && f_colors=$(grep . "$HOME"/.colors | base64)
  [ -f "$HOME"/.env ] && f_env=$(grep . "$HOME"/.env | base64)
  [ -f "$HOME"/.functions ] && f_functions=$(grep . "$HOME"/.functions | base64)
  [ -f "$HOME"/.path ] && f_path=$(grep . "$HOME"/.path | base64)
  [ -f "$HOME"/.profile ] && f_profile=$(grep . "$HOME"/.profile | base64)
  [ -f "$HHS_CMD_FILE" ] && f_cmdFile=$(grep . "$HHS_CMD_FILE" | base64)
  [ -f "$HHS_SAVED_DIRS" ] && f_savedDirs=$(grep . "$HHS_SAVED_DIRS" | base64)
  [ -f "$HOME"/.bash_aliasdef ] && f_aliasdef=$(grep . "$HOME"/.bash_aliasdef | base64)

  # Generate the request payload using the files above
  payload="{ \"$fb_alias\" : { "
  [ -n "$f_aliases" ] && payload="${payload}\"aliases\" : \"$f_aliases\","
  [ -n "$f_colors" ] && payload="${payload}\"colors\" : \"$f_colors\","
  [ -n "$f_env" ] && payload="${payload}\"env\" : \"$f_env\","
  [ -n "$f_functions" ] && payload="${payload}\"functions\" : \"$f_functions\","
  [ -n "$f_path" ] && payload="${payload}\"path\" : \"$f_path\","
  [ -n "$f_profile" ] && payload="${payload}\"profile\" : \"$f_profile\","
  [ -n "$f_cmdFile" ] && payload="${payload}\"commands\" : \"$f_cmdFile\","
  [ -n "$f_savedDirs" ] && payload="${payload}\"savedDirs\" : \"$f_savedDirs\","
  [ -n "$f_aliasdef" ] && payload="${payload}\"aliasdef\" : \"$f_aliasdef\","
  payload="${payload}\"lastUpdate\" : \"$(date +'%d-%m-%Y %T')\","
  payload="${payload}\"lastUser\" : \"$(whoami)\""
  payload="${payload} } }"
  payload="${payload//$match/$repl}"

  echo -en "$payload"
}

# Upload the User dotfiles to Firebase.
upload_dotfiles() {

  local body
  local fb_alias="$1"

  body=$(build_dotfiles_payload)
  fetch.bash PATCH --silent --body "$body" "$FIREBASE_URL/dotfiles/$UUID.json" &>/dev/null
  ret=$?
  [ $ret -eq 0 ] && echo "${GREEN}Dotfiles \"${fb_alias}\" sucessfully uploaded!${NC}"
  [ $ret -eq 0 ] || quit 2 "Failed to upload Dotfiles as ${fb_alias}"
}

# Parse the dotfiles response payload and save the files.
parse_and_save_dotfiles() {

  local f_aliases f_colors f_env f_functions f_profile f_cmdFile f_savedDirs f_aliasdef
  local b64flag

  [ "$(uname -s)" = "Linux" ] && b64flag='-d' || b64flag='-D'

  # Encode all received dotfiles
  f_aliases=$(json-find.py -a aliases -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_colors=$(json-find.py -a colors -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_env=$(json-find.py -a env -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_functions=$(json-find.py -a functions -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_profile=$(json-find.py -a profile -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_cmdFile=$(json-find.py -a commands -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_savedDirs=$(json-find.py -a savedDirs -f "$DOTFILES_FILE" | base64 "${b64flag}")
  f_aliasdef=$(json-find.py -a aliasdef -f "$DOTFILES_FILE" | base64 "${b64flag}")

  # Write all files into place
  [ -n "$f_aliases" ] && echo "$f_aliases" >"$HOME/.aliases"
  [ -n "$f_colors" ] && echo "$f_colors" >"$HOME/.colors"
  [ -n "$f_env" ] && echo "$f_env" >"$HOME/.env"
  [ -n "$f_functions" ] && echo "$f_functions" >"$HOME/.functions"
  [ -n "$f_profile" ] && echo "$f_profile" >"$HOME/.profile"
  [ -n "$f_cmdFile" ] && echo "$f_cmdFile" >"$HHS_CMD_FILE"
  [ -n "$f_savedDirs" ] && echo "$f_savedDirs" >"$HHS_SAVED_DIRS"
  [ -n "$f_aliasdef" ] && echo "$f_aliasdef" >"$HOME/.bash_aliasdef"
}

# Provides a help about the command.
cmd_help() {

  shopt -s nocasematch
  case "$1" in
  # Do stuff related to firebase
  FB | firebase)
    echo ''
    echo 'Execute firebase synchronization tasks.'
    echo "Usage: $APP_NAME firebase <task> [args]"
    echo ''
    echo '  Tasks:'
    echo '      s |    setup               : Setup your Firebase account to use with your HomeSetup installation.'
    echo '     ul |   upload <db_alias>    : Upload your custom .dotfiles to your Firebase \"Realtime Database\".'
    echo '     dl | download <db_alias>    : Download your custom .dotfiles from your Firebase \"Realtime Database\".'
    ;;
  H | help)
    echo 'Provides a help to the given command.'
    echo "Usage: $APP_NAME help <command>"
    ;;

  *)
    quit 2 "Command \"$1\" does not exist!"
    ;;
  esac
  shopt -u nocasematch
  quit 1
}

# Execute a Firebase command
cmd_firebase() {

  local body fb_alias u_uuid u_name setupContent=""

  test -z "$1" && cmd_help 'FB'
  task="$1"
  shift
  args=("$@")
  test -z "${args[*]}" -a "$task" != 'setup' && quit 2 "Invalid firebase task or invalid number of arguments: \"$task\" !"
  fb_alias="$(trim "${args[0]}" | tr '[:upper:]' '[:lower:]')"
  fb_alias="${fb_alias//[[:space:]]/_}"
  u_name=$(whoami)
  u_uuid=$(python -c "import uuid as ul; print(str(ul.uuid4()));")

  shopt -s nocasematch
  case "$task" in
  s | setup)
    test -f "$FIREBASE_FILE" && rm -f "$FIREBASE_FILE"
    while [ ! -f "$FIREBASE_FILE" ]; do
      clear
      echo "### Firebase setup"
      echo "-------------------------------"
      read -r -p 'Please type you Project ID: ' ANS
      [ -z "$ANS" ] || [ "$ANS" = "" ] && echo -e "${RED}Invalid Project ID: ${ANS}${NC}" && sleep 1 && continue
      setupContent="${setupContent}PROJECT_ID=${ANS}\n"
      setupContent="${setupContent}USERNAME=$u_name\n"
      setupContent="${setupContent}FIREBASE_URL=https://${ANS}.firebaseio.com/homesetup\n"
      read -r -p 'Please type a password to encrypt you data: ' ANS
      [ -z "$ANS" ] || [ "$ANS" = "" ] && echo -e "${RED}Invalid password: ${ANS}${NC}" && sleep 1 && continue
      setupContent="${setupContent}PASSPHRASE=${ANS}\n"
      read -r -p "Please type a UUID to use or press enter to generate a new one: " ANS
      if [ -n "$ANS" ] && [[ "$ANS" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]]; then
        u_uuid="$ANS"
      elif [ -n "$ANS" ]; then
        echo -e "${RED}Invalid UUID: ${ANS}${NC}" && sleep 1 && continue
      else
        echo "=> UUID automatically generated: $u_uuid"
      fi
      setupContent="${setupContent}UUID=$u_uuid\n"
      # Write user's Firebase data
      echo '# Your Firebase credentials:' >"$FIREBASE_FILE"
      echo "-------------------------------"
      echo -e "$setupContent" >>"$FIREBASE_FILE"
    done
    echo -e "${GREEN}Configuration successfully saved!${NC}"
    ;;
  ul | upload)
    load_fb_settings
    upload_dotfiles "$fb_alias"
    ;;
  dl | download)
    echo -e "${ORANGE}"
    read -r -n 1 -p "All of your current .dotfiles will be replaced. Continue y/[n] ?" ANS
    echo -e "${NC}"
    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
      load_fb_settings
      download_dotfiles "$fb_alias"
      parse_and_save_dotfiles
      echo -e "${YELLOW}? To activate the new dotfiles type: #> ${GREEN}source ~/.bashrc${NC}"
    fi
    ;;
  *)
    quit 2 "Invalid firebase task: \"$task\" !"
    ;;
  esac
  shopt -u nocasematch

  return 0
}

# Execute a dotfiles command.
exec_command() {

  shopt -s nocasematch
  case "${COMMAND}" in
  # Do stuff related to firebase
  cmd_firebase)
    cmd_firebase "$@"
    ret=$?
    ;;
  cmd_help)
    cmd_help "$@"
    ret=$?
    ;;
  *)
    quit 1 "Invalid command \"${COMMAND}\" !"
    ;;
  esac
  shopt -u nocasematch
  quit $ret
}

test -z "$1" && usage

shopt -s nocasematch
# Loop through the command line options.
case "$1" in

# Do stuff related to firebase
FB | firebase)
  COMMAND="cmd_firebase"
  shift
  ;;
# Help about the command
H | help)
  COMMAND="cmd_help"
  shift
  ;;
*)
  quit 1 "Invalid option: \"$1\""
  ;;
esac
shopt -u nocasematch

exec_command "$@"

quit 0