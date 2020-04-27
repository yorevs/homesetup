#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090

#  Script: firebase.bash
# Purpose: Manager for HomeSetup Firebase integration
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="firebase"

# Usage message
USAGE="
Usage: ${APP_NAME} ${PLUGIN_NAME} <option> [arguments]

    Manage your HomeSetup firebase integration.
    
    Options:
      -v  |  --version              : Display current program version.
      -h  |     --help              : Display this help message.
      -s  |    --setup              : Setup your Firebase account to use with HomeSetup.
      -u  |   --upload <db_alias>   : Upload dotfiles to your Firebase Realtime Database.
      -d  | --download <db_alias>   : Download dotfiles from your Firebase Realtime Database.
      
    Arguments:
      db_alias  : Alias to be used to identify the firebase object to fetch data from.
"

UNSETS=(
  help version cleanup execute load_settings download parse_and_save build_payload upload
)

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

# Firebase configuration file.
FIREBASE_FILE="${HHS_DIR}/.firebase"

# Firebase json response file.
RESPONSE_FILE="${HHS_DIR}/firebase.json"

# Firebase response regex.
RESPONSE_RE='^\{(("aliases":".*")*(,*"commands":".*")*(,*"colors":".*")*(,*"env":".*")*(,*"functions":".*")*(,*"path":".*")*(,*"profile":".*")*(,*"savedDirs":".*")*(,*"aliasdef":".*")*)+\}$'

# Regex to validate the created UUID
UUID_RE='^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'

# File to store the saved commands.
HHS_CMD_FILE=${HHS_CMD_FILE:-${HHS_DIR}/.cmd_file}

# File to store the saved directories.
HHS_SAVED_DIRS_FILE=${HHS_SAVED_DIRS_FILE:-${HHS_DIR}/.saved_dirs}

# Firebase configuration format
FB_CONFIG_FMT="
# Your Firebase configuration:
# --------------------------
PROJECT_ID=%ID%
USERNAME=$(whoami)
FIREBASE_URL=%URL%
PASSPHRASE=%PWD%
UUID=%UUID%
"

FB_ALIAS=''

# @purpose: Load firebase settings.
load_settings() {

  if [[ ! -f "${FIREBASE_FILE}" ]]; then
    echo -e "${YELLOW}Your need to setup your Firebase credentials first.${NC}"
    sleep 1
    setup_firebase
  fi

  [[ -f "${FIREBASE_FILE}" ]] && \. "${FIREBASE_FILE}"
  [[ -z "$PROJECT_ID" || -z "${FIREBASE_URL}" || -z "$PASSPHRASE" || -z "${UUID}" ]] && quit 2 "Invalid settings file!"

  return 0
}

# @purpose: Setup Firebase credentials and settings
setup_firebase() {
  [[ -f "${FIREBASE_FILE}" ]] && rm -f "${FIREBASE_FILE}"
  while [[ ! -f "${FIREBASE_FILE}" ]]; do
    clear
    echo "### Firebase setup"
    echo "-------------------------------"
    read -r -p 'Please type you Project ID: ' PROJECT_ID
    [[ -z "$PROJECT_ID" || "$PROJECT_ID" == "" ]] && __hhs_errcho "${FUNCNAME[0]}: Invalid Project ID: ${PROJECT_ID}${NC}" && sleep 1 && continue
    fb_config="${FB_CONFIG_FMT//\%ID\%/$PROJECT_ID}"
    fb_config="${fb_config//\%URL\%/https://$PROJECT_ID.firebaseio.com/homesetup}"
    read -r -p 'Please type a password to encrypt you data: ' PASSWD
    [[ -z "$PASSWD" ]] && __hhs_errcho "${FUNCNAME[0]}: Blank passwords are not accepted: ${PASSWD}${NC}" && sleep 1 && continue
    fb_config="${fb_config//\%PWD\%/$PASSWD}"
    read -r -p "Please type a UUID to use or press enter to generate a new one: " UUID
    if [[ -n "${UUID}" ]] && [[ "${UUID}" =~ ${UUID_RE} ]]; then
      u_uuid="${UUID}"
    elif [[ -n "${UUID}" ]]; then
      __hhs_errcho "${FUNCNAME[0]}: Invalid UUID: ${UUID}${NC}" && sleep 1 && continue
    else
      u_uuid=$(python -c "import uuid as ul; print(str(ul.uuid4()));")
      echo "=> UUID automatically generated: ${u_uuid}"
    fi
    fb_config="${fb_config//\%UUID\%/${u_uuid}}"
    # Save user's Firebase data
    echo -e "${fb_config}" > "${FIREBASE_FILE}"
    if [ -f "${FIREBASE_FILE}" ] && fetch.bash GET --silent "https://${PROJECT_ID}.firebaseio.com/homesetup/dotfiles/${UUID}.json" &> /dev/null; then
      echo "${GREEN}Firebase configuration suceeded ! ${NC}"
    else
      __hhs_errcho "${FUNCNAME[0]}: Configuration failed !" && continue
    fi
  done
}

# @purpose: Build the dotfiles json request payload.
build_payload() {

  local f_aliases f_colors f_env f_functions f_path f_profile f_cmdFile f_saved_dirs f_aliasdef
  local payload='' match=', } }' replacement=' } }'

  # Encode all present dotfiles
  [[ -f "${HOME}"/.aliases ]] && f_aliases=$(grep . "${HOME}"/.aliases | base64)
  [[ -f "${HOME}"/.colors ]] && f_colors=$(grep . "${HOME}"/.colors | base64)
  [[ -f "${HOME}"/.env ]] && f_env=$(grep . "${HOME}"/.env | base64)
  [[ -f "${HOME}"/.functions ]] && f_functions=$(grep . "${HOME}"/.functions | base64)
  [[ -f "${HHS_PATHS_FILE}" ]] && f_path=$(grep . "${HHS_PATHS_FILE}" | base64)
  [[ -f "${HOME}"/.profile ]] && f_profile=$(grep . "${HOME}"/.profile | base64)
  [[ -f "$HHS_CMD_FILE" ]] && f_cmdFile=$(grep . "$HHS_CMD_FILE" | base64)
  [[ -f "${HHS_SAVED_DIRS_FILE}" ]] && f_saved_dirs=$(grep . "${HHS_SAVED_DIRS_FILE}" | base64)
  [[ -f "${HOME}"/.aliasdef ]] && f_aliasdef=$(grep . "${HOME}"/.aliasdef | base64)

  # Generate the request payload using the files above
  payload="{ \"${FB_ALIAS}\" : { "
  [[ -n "$f_aliases" ]] && payload="${payload}\"aliases\" : \"$f_aliases\","
  [[ -n "$f_colors" ]] && payload="${payload}\"colors\" : \"$f_colors\","
  [[ -n "$f_env" ]] && payload="${payload}\"env\" : \"$f_env\","
  [[ -n "$f_functions" ]] && payload="${payload}\"functions\" : \"$f_functions\","
  [[ -n "$f_path" ]] && payload="${payload}\"path\" : \"$f_path\","
  [[ -n "$f_profile" ]] && payload="${payload}\"profile\" : \"$f_profile\","
  [[ -n "$f_cmdFile" ]] && payload="${payload}\"commands\" : \"$f_cmdFile\","
  [[ -n "$f_saved_dirs" ]] && payload="${payload}\"savedDirs\" : \"$f_saved_dirs\","
  [[ -n "$f_aliasdef" ]] && payload="${payload}\"aliasdef\" : \"$f_aliasdef\","
  payload="${payload}\"lastUpdate\" : \"$(date +'%d-%m-%Y %T')\","
  payload="${payload}\"lastUser\" : \"$(whoami)\""
  payload="${payload} } }"
  payload="${payload//$match/$replacement}"

  echo -en "$payload"
}

# @purpose: Download the User dotfiles from Firebase.
download() {

  local fb_alias="$1"

  [[ -f "${RESPONSE_FILE}" ]] && rm -f "${RESPONSE_FILE}"
  fetch.bash GET --silent "${FIREBASE_URL}/dotfiles/${UUID}/${fb_alias}.json" > "${RESPONSE_FILE}"
  ret=$?

  if [[ $ret -eq 0 && -f "${RESPONSE_FILE}" && "$(grep . "${RESPONSE_FILE}")" =~ ${RESPONSE_RE// /} ]]; then
    echo -e "\n${GREEN}Dotfiles \"${fb_alias}\" successfully downloaded!${NC}"
  else
    quit 2 "Failed to download \"${fb_alias}\" Dotfiles!"
  fi

  return 0
}

# @purpose: Upload the User dotfiles to Firebase.
upload() {

  local body fb_alias="$1"

  body=$(build_payload)
  if fetch.bash PATCH --silent --body "$body" "${FIREBASE_URL}/dotfiles/${UUID}.json" &> /dev/null; then
    echo "${GREEN}Dotfiles \"${fb_alias}\" successfully uploaded!${NC}"
  else
    quit 2 "Failed to upload Dotfiles as ${fb_alias}"
  fi
}

# @purpose: Parse the dotfiles response payload and save the files.
parse_and_save() {

  local f_aliases f_colors f_env f_functions f_profile f_cmdFile f_saved_dirs f_aliasdef b64flag

  if [[ "$(uname -s)" == "Linux" ]]; then b64flag='-d'; else b64flag='-D'; fi

  # Encode all received dotfiles
  f_aliases=$(json-find.py -a aliases -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_colors=$(json-find.py -a colors -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_env=$(json-find.py -a env -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_functions=$(json-find.py -a functions -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_profile=$(json-find.py -a profile -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_path=$(json-find.py -a path -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_cmdFile=$(json-find.py -a commands -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_saved_dirs=$(json-find.py -a savedDirs -f "${RESPONSE_FILE}" | base64 "${b64flag}")
  f_aliasdef=$(json-find.py -a aliasdef -f "${RESPONSE_FILE}" | base64 "${b64flag}")

  # Write all files into place
  [[ -n "$f_aliases" ]] && echo "$f_aliases" > "${HOME}/.aliases"
  [[ -n "$f_colors" ]] && echo "$f_colors" > "${HOME}/.colors"
  [[ -n "$f_env" ]] && echo "$f_env" > "${HOME}/.env"
  [[ -n "$f_functions" ]] && echo "$f_functions" > "${HOME}/.functions"
  [[ -n "$f_path" ]] && echo "$f_path" > "${HHS_PATHS_FILE}"
  [[ -n "$f_profile" ]] && echo "$f_profile" > "${HOME}/.profile"
  [[ -n "$f_cmdFile" ]] && echo "$f_cmdFile" > "$HHS_CMD_FILE"
  [[ -n "$f_saved_dirs" ]] && echo "$f_saved_dirs" > "${HHS_SAVED_DIRS_FILE}"
  [[ -n "$f_aliasdef" ]] && echo "$f_aliasdef" > "${HOME}/.aliasdef"
}

# @purpose: HHS plugin required function
function help() {
  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
  exit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
}

# @purpose: HHS plugin required function
function execute() {
  [[ -z "$1" ]] && usage 1
  cmd="$1"
  shift
  args=("$@")

  shopt -s nocasematch
  case "$cmd" in
    -h | --help)
      usage 0
      ;;
    -s | --setup)
      setup_firebase
      ;;
    -u | --upload)
      [[ "${#args[@]}" -eq 0 ]] && usage 1 "Invalid number of arguments for command: \"$cmd\" !"
      FB_ALIAS="$(trim "${args[0]}" | tr '[:upper:]' '[:lower:]')"
      FB_ALIAS="${FB_ALIAS//[[:space:]]/_}"
      load_settings
      upload "${FB_ALIAS}"
      ;;
    -d | --download)
      [[ "${#args[@]}" -eq 0 ]] && usage 1 "Invalid number of arguments for command: \"$cmd\" !"
      FB_ALIAS="$(trim "${args[0]}" | tr '[:upper:]' '[:lower:]')"
      FB_ALIAS="${FB_ALIAS//[[:space:]]/_}"
      echo -e "${ORANGE}"
      read -r -n 1 -p "All of your current .dotfiles will be replaced. Continue y/[n] ?" ANS
      echo -e "${NC}"
      if [[ "$ANS" == "y" || "$ANS" == "Y" ]]; then
        load_settings
        download "${FB_ALIAS}"
        parse_and_save
        echo -e "${YELLOW}? To activate the new dotfiles type: #> ${GREEN}source ~/.bashrc${NC}"
      fi
      ;;
    *)
      usage 1 "Invalid ${PLUGIN_NAME} command: \"$cmd\" !"
      ;;
  esac
  shopt -u nocasematch

  exit 0
}
