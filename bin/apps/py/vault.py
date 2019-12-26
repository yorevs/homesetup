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
import getopt
import base64

from subprocess import check_output

PROC_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (0, 9, 0)

# Usage message
USAGE = """
HomeSetup vault v{}

Usage: {} [opts]

    Options:
        -a,  --add <key> <password> <desc> : Add a password to the vault
        -d,  --del <key>                   : Remove a password from the vault
        -u,  --upd <key> <password> <desc> : Update a password from the vault
        -l, --list <filter>                : List all passwords matching the key filter
""".format(VERSION, PROC_NAME)

OPER_MAP = {
    'add': None,
    'del': None,
    'upd': None,
    'list': None
}

PWD_MAP = {}

VAULT_FILE = "/Users/hugo/.hhs/vault.dat"

VAULT_GPG_FILE = "{}.gpg".format(VAULT_FILE)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: TODO: Comment it
class VaultEntry(object):
    def __init__(self, key, password, desc):
        self.key = key
        self.password = password
        self.desc = desc

    def __str__(self):
        return "{}|{}|{}".format(self.key, self.password, self.desc)

    def to_string(self):
        return """
        Key: {}
        Password: {}
        Description: {}
        """.format(self.key, self.password, self.desc)


# @purpose: TODO: Comment it
def assert_vault_exists():
    if not os.path.exists(VAULT_FILE):
        with open(VAULT_FILE, 'w'):
            pass


# @purpose: TODO: Comment it
def decrypt_vault():
    output = check_output(['gpg', '--yes', '--batch', '--passphrase={}'.format('12345'), VAULT_FILE]).strip()
    with open(VAULT_FILE, 'rw') as f_vault:
        f_vault.write(str(base64.b64decode(f_vault.read())))


# @purpose: TODO: Comment it
def encrypt_vault():
    output = check_output(['gpg', '--yes', '--batch', '--passphrase={}'.format('12345'), '-c', VAULT_FILE]).strip()
    with open(VAULT_FILE, 'rw') as f_vault:
        f_vault.write(str(base64.b64encode(f_vault.read())))


# @purpose: TODO: Comment it
def save_vault():
    with open(VAULT_FILE, 'w') as f_vault:
        for entry in PWD_MAP:
            f_vault.write("{}\n".format(str(PWD_MAP[entry])))


# @purpose: TODO: Comment it
def read_vault():
    with open(VAULT_FILE) as f_vault:
        for line in f_vault:
            if not line.strip():
                continue
            (key, password, desc) = line.split('|')
            entry = VaultEntry(key, password, desc)
            PWD_MAP[key] = entry


# @purpose: TODO: Comment it
def list_from_vault():
    for entry in PWD_MAP:
        print("{} -> {}".format(entry, PWD_MAP[entry].to_string()))


# @purpose: TODO: Comment it
def add_to_vault(key, password, desc):
    if not key in PWD_MAP.keys():
        entry = VaultEntry(key, password, desc)
        PWD_MAP[key] = entry
        save_vault()
    else:
        print ("### Password specified by '{}' already exist in vault".format(key))


# @purpose: TODO: Comment it
def del_from_vault(key):
    if key in PWD_MAP.keys():
        del PWD_MAP[key]
        save_vault()
    else:
        print ("### Password specified by '{}' does not exist in vault".format(key))


# @purpose: TODO: Comment it
def update_vault(key, password, desc):
    if key in PWD_MAP.keys():
        entry = VaultEntry(key, password, desc)
        PWD_MAP[key] = entry
        save_vault()
    else:
        print ("### Password specified by '{}' does not exist in vault".format(key))


# @purpose: Execute the specified operation
def exec_operation(op):
    try:
        assert_vault_exists()
        # decrypt_vault()
        read_vault()
        if "add" == op:
            add_to_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        elif "del" == op:
            del_from_vault(OPER_MAP[op][0])
        elif "upd" == op:
            update_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        else:
            list_from_vault()
    finally:
        # encrypt_vault()
        pass


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
    # try:

        if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
            usage()

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhadul', ['add=', 'del', 'update=', 'list'])

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-a', '--add'):
                check_arguments(args, 3)
                OPER_MAP['add'] = args
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

    # # Catch getopt exceptions
    # except getopt.GetoptError as err:
    #     print('Invalid option: => {}'.format(err.msg))
    #     usage(2)
    #
    # # Catch ValueErrors
    # except ValueError as err:
    #     print('Failed to execute vault => "{}"'.format(err))
    #     usage(2)

    # # Caught app exceptions
    # except Exception as err:
    #     print('### A unexpected exception was thrown executing the app => \n\t{}'.format(err))
    #     sys.exit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)
