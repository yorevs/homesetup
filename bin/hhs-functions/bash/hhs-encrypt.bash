#!/usr/bin/env bash

#  Script: hhs-encrypt.bash
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

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
      echo "Usage: ${FUNCNAME[0]} <file_name> <passphrase>"
      return 1
    else
      gpg --yes --batch --passphrase="$2" -c "$1" &>/dev/null
      if test $? -eq 0; then
        echo -e "${GREEN}File \"$1\" has been encrypted!${NC}"
        encode -i "$1.gpg" -o "$1"
        rm -f "$1.gpg"
        return 0
      fi
    fi

    echo -e "${RED}Unable to encrypt file: \"$1\" ${NC}"

    return 1
  }

  # @function: Decrypt file using GPG encryption.
  # @param $1 [Req] : The file to decrypt.
  # @param $2 [Req] : The passphrase to decrypt the file.
  # @param $3 [Opt] : If provided, keeps the encrypted file, delete it otherwise.
  function __hhs_decrypt_file() {

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 2 ]; then
      echo "Usage: ${FUNCNAME[0]} <file_name> <passphrase>"
      return 1
    else
      decode -i "$1" -o "$1.gpg"
      gpg --yes --batch --passphrase="$2" "$1.gpg" &>/dev/null
      if test $? -eq 0; then
        echo -e "${GREEN}File \"$1\" has been decrypted!${NC}"
        rm -f "$1.gpg"
        return 0
      fi
    fi

    echo -e "${RED}Unable to decrypt file: \"$1\" ${NC}"

    return 1
  }

fi
