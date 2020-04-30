#!/usr/bin/env bash

#  Script: hhs-security.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "gpg"; then

  # @function: Encrypt file using GPG.
  # @param $1 [Req] : The file to encrypt.
  # @param $2 [Req] : The passphrase used to encrypt the file.
  # @param $3 [Opt] : If provided, keeps the decrypted file, delete it otherwise.
  function __hhs_encrypt_file() {

    local keep_file="${3}"

    if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <filename> <passphrase> [--keep]"
      return 1
    else
      if gpg --yes --batch --passphrase="$2" -c "$1" &> /dev/null; then
        if encode "$1.gpg" > "$1"; then
          [[ ${keep_file} =~ --[kK][eE]{2}[pP] ]] || rm -f "$1.gpg" &> /dev/null
          echo -e "${GREEN}File \"$1\" has been encrypted !${NC}"
          return 0
        fi
      fi
    fi

    __hhs_errcho "${FUNCNAME[0]}: Unable to encrypt file: \"$1\" ${NC}"

    return 1
  }

  # @function: Decrypt a GPG encrypted file.
  # @param $1 [Req] : The file to decrypt.
  # @param $2 [Req] : The passphrase used to decrypt the file.
  # @param $3 [Opt] : If provided, keeps the encrypted file, delete it otherwise.
  function __hhs_decrypt_file() {

    local keep_file="$3"

    if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <filename> <passphrase> [--keep]"
      return 1
    else
      if decode "$1" > "$1.gpg"; then
        if gpg --yes --batch --passphrase="$2" "$1.gpg" &> /dev/null; then
          [[ ${keep_file} =~ --[kK][eE]{2}[pP] ]] || rm -f "$1.gpg" &> /dev/null
          echo -e "${GREEN}File \"$1\" has been decrypted !${NC}"
          return 0
        fi
      fi
    fi

    __hhs_errcho "${FUNCNAME[0]}: Unable to decrypt file: \"$1\" ${NC}"

    return 1
  }

fi
