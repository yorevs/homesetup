#!/usr/bin/env python

"""
    @package: -
    @script: vault.py
    @purpose: This application is a vault for passwords
    @created: Thu 21, 2019
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
        @site: https://github.com/yorevs/homesetup
    @license: Please refer to <http://unlicense.org/>
"""

import sys
import os
import re
import getopt
import base64

from subprocess import check_output

APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 0, 0)

# Usage message
USAGE = """
HomeSetup vault v{}

Usage: {} [opts]

    Options:
        -a,  --add <key> <password> <desc> : Add a password to the vault
        -d,  --del <key>                   : Remove a password from the vault
        -u,  --upd <key> <password> <desc> : Update a password from the vault
        -l, --list <filter>                : List all passwords matching the key filter
""".format(VERSION, APP_NAME)

OPER_MAP = {
    'add': None, 'get': None, 'del': None, 'upd': None, 'list': None
}

HHS_DIR = "/Users/hugo/.hhs"

VAULT = {}

VAULT_FILE = "{}/.vault".format(HHS_DIR)

VAULT_GPG_FILE = "{}.gpg".format(VAULT_FILE)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: Represents a vault entity
class VaultEntry(object):
    def __init__(self, key, password, desc):
        self.key = key
        self.password = password
        self.desc = desc

    def __str__(self):
        return "{}|{}|{}".format(self.key, self.password, self.desc)

    def to_string(self, show_password=False):
        return """
        Key: {}
        Password: {}
        Description: {}"""\
            .format(
                self.key,
                self.password if show_password else re.sub('.*', '*' * len(self.password), self.password),
                self.desc)


# @purpose: Encode the vault file into base64
def encode_vault():
    if os.path.exists(VAULT_GPG_FILE):
        with open(VAULT_GPG_FILE, 'r') as vault_file:
            with open(VAULT_FILE, 'w') as enc_vault_file:
                enc_vault_file.write(str(base64.b64encode(vault_file.read())))
                return True
    else:
        return False


# @purpose: Decode the vault file from base64
def decode_vault():
    if os.path.exists(VAULT_FILE):
        with open(VAULT_FILE, 'r') as vault_file:
            with open(VAULT_GPG_FILE, 'w') as dec_vault_file:
                dec_vault_file.write(str(base64.b64decode(vault_file.read())))
                return True
    else:
        return False


# @purpose: Encrypt the vault file
def encrypt_vault(passphrase):
    if os.path.exists(VAULT_FILE):
        check_output([
            'gpg', '--quiet', '--yes', '--batch', '--symmetric',
            '--passphrase={}'.format(passphrase), '--output', VAULT_GPG_FILE, VAULT_FILE
        ]).strip()
        encode_vault()
        os.remove(VAULT_GPG_FILE)


# @purpose: Decrypt the vault file
def decrypt_vault(passphrase):
    if decode_vault():
        check_output([
            'gpg', '--quiet', '--yes', '--batch',
            '--passphrase={}'.format(passphrase), '--output', VAULT_FILE, VAULT_GPG_FILE
        ]).strip()
        os.remove(VAULT_GPG_FILE)


# @purpose: Save all vault entries
def save_vault():
    with open(VAULT_FILE, 'w') as f_vault:
        for entry in VAULT:
            f_vault.write("{}\n".format(str(VAULT[entry])))


# @purpose: Read all existing vault entries
def read_vault():
    if os.path.exists(VAULT_FILE):
        with open(VAULT_FILE, 'r') as f_vault:
            for line in f_vault:
                if not line.strip():
                    continue
                (key, password, desc) = line.split('|')
                entry = VaultEntry(key, password, desc)
                VAULT[key] = entry


# @purpose: List all vault entries
def list_from_vault():
    if len(VAULT) > 0:
        print ('\n=== Listing all vault entries ===\n')
        for entry in VAULT:
            print("[{}]: {}".format(entry, VAULT[entry].to_string()))
    else:
        print ("\n=== Vault is empty ===\n")


# @purpose: Add a vault entry
def add_to_vault(key, password, desc):
    if key not in VAULT.keys():
        entry = VaultEntry(key, password, desc)
        VAULT[key] = entry
        save_vault()
        print ("""\nAdded: {}
        """.format(entry.to_string()))
    else:
        print ("### Entry specified by '{}' already exists in vault".format(key))


# @purpose: Retrieve a vault entry
def get_from_vault(key):
    if key in VAULT.keys():
        entry = VAULT[key]
        print ("\n[{}]: {}".format(entry.key, entry.to_string(True)))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Remove a vault entry
def del_from_vault(key):
    if key in VAULT.keys():
        entry = VAULT[key]
        del VAULT[key]
        save_vault()
        print ("""\nRemoved: {}""".format(entry.to_string()))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Update a vault entry
def update_vault(key, password, desc):
    if key in VAULT.keys():
        entry = VaultEntry(key, password, desc)
        VAULT[key] = entry
        save_vault()
        print ("""\nUpdated: {}
        """.format(entry.to_string()))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


def get_passphrase():
    pw = os.environ.get('HHS_VAULT_PASSPHRASE')
    if pw is None:
        pw = raw_input('Type your passphrase: ')

    return pw


# @purpose: Execute the specified operation
def exec_operation(op):
    pw = get_passphrase()
    try:
        decrypt_vault(pw)
        read_vault()
        if "add" == op:
            add_to_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        elif "get" == op:
            get_from_vault(OPER_MAP[op][0])
        elif "del" == op:
            del_from_vault(OPER_MAP[op][0])
        elif "upd" == op:
            update_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        else:
            list_from_vault()
    finally:
        encrypt_vault(pw)


# @purpose: Execute the app business logic
def app_exec():
    for op in OPER_MAP:
        if not OPER_MAP[op] is None:
            exec_operation(op)
            break


# @purpose: Execute the app business logic
def check_arguments(args, args_num=0):
    if len(args) < args_num:
        print("Invalid number of arguments: {} , expecting: {}".format(len(args), args_num))
        usage(1)


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    try:

        if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
            usage()

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhagdul', ['add=', 'get=', 'del=', 'update=', 'list'])

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-a', '--add'):
                check_arguments(args, 3)
                OPER_MAP['add'] = args
            elif opt in ('-g', '--get'):
                check_arguments(args, 1)
                OPER_MAP['get'] = args
            elif opt in ('-d', '--del'):
                check_arguments(args, 1)
                OPER_MAP['del'] = args
            elif opt in ('-u', '--upd'):
                check_arguments(args, 3)
                OPER_MAP['upd'] = args
            elif opt in ('-l', '--list'):
                OPER_MAP['list'] = args
            else:
                assert False, '### Unhandled option: {}'.format(opt)
            break

        # Execute the app code
        app_exec()

    # Catch getopt exceptions
    except getopt.GetoptError as err:
        print('Invalid option: => {}'.format(err.msg))
        usage(2)

    # Catch ValueErrors
    except ValueError as err:
        print('Failed to execute vault => "{}"'.format(err))
        usage(2)

    # Caught app exceptions
    except Exception as err:
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format(err))
        sys.exit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)

