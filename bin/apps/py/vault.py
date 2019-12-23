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

# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


def add_to_vault(key, password, desc):
    print("Key: {}".format(key))
    print("Password: {}".format(password))
    print("Description: {}".format(desc))


def decrypt_vault():
    output = check_output(['decrypt', '/tmp/vault.txt', '12345']).strip()
    print(output)


def encrypt_vault():
    output = check_output(['encrypt', '/tmp/vault.txt', '12345']).strip()
    print(output)


def list_from_vault():
    try:
        decrypt_vault()
        with open("/tmp/vault.txt") as f_vault:
            for line in f_vault:
                (index, key, password, desc) = line.split('|')
                entry = {
                    'index': index,
                    'key': key,
                    'password': password,
                    'desc': desc
                }
                PWD_MAP[index] = entry
                print("{}".format(entry))
    finally:
        encrypt_vault()


# @purpose: Execute operation
def exec_oper(op):
    if "add" == op:
        add_to_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
    elif "del" == op:
        print ("DEL => {}".format(OPER_MAP[op]))
    elif "upd" == op:
        print ("UPD => {}".format(OPER_MAP[op]))
    else:
        list_from_vault()

# @purpose: Execute the app business logic
def app_exec():

    for op in OPER_MAP:
        if not OPER_MAP[op] is None:
            exec_oper(op)
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

    # Catch getopt exceptions
    except getopt.GetoptError as optErr:
        print('Invalid option: => {}'.format(optErr.msg))
        usage(2)

    # Catch ValueErrors
    except ValueError as valErr:
        print('Failed to execute vault => "{}"'.format(valErr))
        usage(2)

    # Caught app exceptions
    except Exception as err:
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format(err))
        sys.exit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)
