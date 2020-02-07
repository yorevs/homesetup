#!/usr/bin/env bash

#  Script: hhs-security.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "gpg"; then

  # @function: Encrypt file using GPG encryption.
  # @param $1 [Req] : The file to encrypt.
  # @param $2 [Req] : The passphrase to encrypt the file.
  # @param $3 [Opt] : If provided, keeps the decrypted file, delete it otherwise.
  function __hhs_encrypt_file() {

    if [[ "$#" -ne 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <filename> <passphrase>"
      return 1
    else
      if gpg --yes --batch --passphrase="$2" -c "$1" &> /dev/null; then
        if base64 -i "$1.gpg" -o "$1" && rm -f "$1.gpg"; then
          echo -e "${GREEN}File \"$1\" has been encrypted!${NC}"
          return 0
        fi
      fi
    fi

    __hhs_errcho "${FUNCNAME[0]}: Unable to encrypt file: \"$1\" ${NC}"

    return 1
  }

  # @function: Decrypt file using GPG encryption.
  # @param $1 [Req] : The file to decrypt.
  # @param $2 [Req] : The passphrase to decrypt the file.
  # @param $3 [Opt] : If provided, keeps the encrypted file, delete it otherwise.
  function __hhs_decrypt_file() {

    if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <filename> <passphrase>"
      return 1
    else
      if base64 -i "$1" -o "$1.gpg"; then
        if gpg --yes --batch --passphrase="$2" "$1.gpg" &> /dev/null; then
          echo -e "${GREEN}File \"$1\" has been decrypted!${NC}" && rm -f "$1.gpg"
          return 0
        fi
      fi
    fi

    __hhs_errcho "${FUNCNAME[0]}: Unable to decrypt file: \"$1\" ${NC}"

    return 1
  }

fi
