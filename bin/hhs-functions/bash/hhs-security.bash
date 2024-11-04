#!/usr/bin/env bash

#  Script: hhs-security.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has 'gpg' && __hhs_has 'base64'; then

  # @function: Encrypt file using GPG.
  # @param $1 [Req] : The file to encrypt.
  # @param $2 [Req] : The passphrase used to encrypt the file.
  # @param $3 [Opt] : If provided, keeps the decrypted file, delete it otherwise.
  function __hhs_encrypt_file() {

    local file="${1}" passwd="${2}" keep_file="${3}"

    if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "usage: ${FUNCNAME[0]} <filename> <passphrase> [--keep]"
      return 1
    else
      if [[ ! -f "${file}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}: File not found: \"${file}\" !"
      elif [[ -z "${passwd}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}: Passphrase can't be blank !"
      elif gpg --yes --batch --passphrase="${passwd}" -c "${file}" &>/dev/null; then
        if encode -i "${file}.gpg" -o "${file}"; then
          [[ ${keep_file} =~ --[kK][eE]{2}[pP] ]] || rm -f "${file}.gpg" &>/dev/null
          echo -e "${GREEN}File \"${file}\" has been encrypted !${NC}"
          return 0
        fi
      else
        __hhs_errcho "${FUNCNAME[0]}: Unable to encrypt file: \"$1\" ${NC}"
      fi
    fi

    return 1
  }

  # @function: Decrypt a GPG encrypted file.
  # @param $1 [Req] : The file to decrypt.
  # @param $2 [Req] : The passphrase used to decrypt the file.
  # @param $3 [Opt] : If provided, keeps the encrypted file, delete it otherwise.
  function __hhs_decrypt_file() {

    local file="${1}" passwd="${2}" keep_file="${3}"

    if [[ "$#" -lt 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "usage: ${FUNCNAME[0]} <filename> <passphrase> [--keep]"
      return 1
    else
      if [[ ! -f "${file}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}: File not found: \"${file}\" !"
      elif [[ -z "${passwd}" ]]; then
        __hhs_errcho "${FUNCNAME[0]}: Passphrase can't be blank !"
      elif decode -i "${file}" -o "${file}.gpg"; then
        if gpg --yes --batch --passphrase="${passwd}" "${file}.gpg" &>/dev/null; then
          [[ ${keep_file} =~ --[kK][eE]{2}[pP]keep ]] || rm -f "${file}.gpg" &>/dev/null
          echo -e "${GREEN}File \"${file}\" has been decrypted !${NC}"
          return 0
        fi
      else
        __hhs_errcho "${FUNCNAME[0]}: Unable to decrypt file: \"${file}\""
      fi
    fi

    return 1
  }

fi
