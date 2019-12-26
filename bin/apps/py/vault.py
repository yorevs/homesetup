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
import getpass
import traceback
import base64
import subprocess

APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 0, 0)

# Usage message
USAGE = """
HomeSetup vault v{}

Usage: {} [opts]

    Options:
        -a,  --add <key> <desc> [password] : Add a password to the vault
        -d,  --del <key>                   : Remove a password from the vault
        -u,  --upd <key> <desc> [password] : Update a password from the vault
        -l, --list <filter>                : List all passwords matching the key filter
""".format(VERSION, APP_NAME)

OPER_MAP = {
    'add': None, 'get': None, 'del': None, 'upd': None, 'list': None
}

HHS_DIR = "/Users/hugo/.hhs"

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


# @purpose: Represents the vault
class Vault(object):
    requires_encryption = False
    data = {}

    def __init__(self):
        pass


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
        Description: {}""" \
            .format(
            self.key,
            self.password if show_password else re.sub('.*', '*' * 6, self.password),
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
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch', '--symmetric',
            '--passphrase={}'.format(passphrase),
            '--output', VAULT_GPG_FILE, VAULT_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        encode_vault()
        VaultEntry.requires_encryption = False


# @purpose: Decrypt the vault file
def decrypt_vault(passphrase):
    if decode_vault():
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch',
            '--passphrase={}'.format(passphrase),
            '--output', VAULT_FILE, VAULT_GPG_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        VaultEntry.requires_encryption = True


# @purpose: Save all vault entries
def save_vault():
    with open(VAULT_FILE, 'w') as f_vault:
        for entry in Vault.data:
            f_vault.write("{}\n".format(str(Vault.data[entry])))


# @purpose: Read all existing vault entries
def read_vault():
    if os.path.exists(VAULT_FILE):
        try:
            with open(VAULT_FILE, 'r') as f_vault:
                for line in f_vault:
                    if not line.strip():
                        continue
                    (key, password, desc) = line.split('|')
                    entry = VaultEntry(key, password, desc)
                    Vault.data[key] = entry
        except ValueError:
            print ("### Your Vault file '{}' is not valid".format(VAULT_FILE))


# @purpose: List all vault entries
def list_from_vault():
    if len(Vault.data) > 0:
        print ('\n=== Listing all vault entries ===\n')
        for entry in Vault.data:
            print("[{}]: {}".format(entry, Vault.data[entry].to_string()))
    else:
        print ("\n=== Vault is empty ===\n")


# @purpose: Add a vault entry
def add_to_vault(key, desc, password):
    if key not in Vault.data.keys():
        entry = VaultEntry(key, password, desc)
        Vault.data[key] = entry
        print ("""\nAdded: {}
        """.format(entry.to_string()))
    else:
        print ("### Entry specified by '{}' already exists in vault".format(key))


# @purpose: Retrieve a vault entry
def get_from_vault(key):
    if key in Vault.data.keys():
        entry = Vault.data[key]
        print ("\n[{}]: {}".format(entry.key, entry.to_string(True)))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Update a vault entry
def update_vault(key, desc, password):
    if key in Vault.data.keys():
        entry = VaultEntry(key, password, desc)
        Vault.data[key] = entry
        print ("""\nUpdated: {}
        """.format(entry.to_string()))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Remove a vault entry
def del_from_vault(key):
    if key in Vault.data.keys():
        entry = Vault.data[key]
        del Vault.data[key]
        print ("""\nRemoved: {}""".format(entry.to_string()))
    else:
        print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Retrieve the vault passphrase
def get_pass_phrase():
    if not os.path.exists(VAULT_FILE) or os.stat(VAULT_FILE).st_size == 0:
        prompt = "Vault file is empty. The following password will be assigned to your Vault file: "
    else:
        prompt = "Type your passphrase: "
    pass_phrase = os.environ.get('HHS_VAULT_PASSPHRASE')
    if pass_phrase is not None:
        pass_phrase = base64.b64decode(pass_phrase)
    else:
        while not pass_phrase:
            pass_phrase = getpass.getpass(prompt).strip()

    return pass_phrase


def set_pass_phrase(pass_phrase):
    pass_phrase = str(pass_phrase.strip())
    os.putenv('HHS_VAULT_PASSPHRASE', base64.b64encode(pass_phrase))


# @purpose: Execute the specified operation
def exec_operation(op):
    passphrase = get_pass_phrase()
    try:
        decrypt_vault(passphrase)
        read_vault()
        if "add" == op:
            add_to_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        elif "get" == op:
            get_from_vault(OPER_MAP[op][0])
        elif "del" == op:
            del_from_vault(OPER_MAP[op][0])
        elif "upd" == op:
            update_vault(OPER_MAP[op][0], OPER_MAP[op][1], OPER_MAP[op][2])
        elif "list" == op:
            list_from_vault()
        else:
            print('### Unhandled operation: {}'.format(op))
        save_vault()
        encrypt_vault(passphrase)
    except subprocess.CalledProcessError:
        print('### Authorization failed or invalid passphrase')
        quit(2)
    finally:
        if os.path.exists(VAULT_GPG_FILE):
            os.remove(VAULT_GPG_FILE)


# @purpose: Execute the app business logic
def app_exec():
    for op in OPER_MAP:
        if not OPER_MAP[op] is None:
            exec_operation(op)
            break


# @purpose: Execute the app business logic
def check_arguments(args, args_num=0):
    if len(args) < args_num:
        print("### Invalid number of arguments: {} , expecting: {}".format(len(args), args_num))
        usage(1)


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    try:

        if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
            usage()

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhagdul', ['add', 'get', 'del', 'update', 'list'])

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
        quit(2)

    # Catch keyboard interrupts
    except KeyboardInterrupt:
        print ('')
        quit(2)

    # Caught app exceptions
    except Exception:
        print('### A unexpected exception was thrown executing the app')
        traceback.print_exc()
        quit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)
