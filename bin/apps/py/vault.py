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
import base64
import subprocess
import datetime

# Application name, read from it's own file path
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 0, 0)

# Usage message
USAGE = """
HomeSetup vault v{}

Usage: {} [opts]

    Options:
        -a,  --add <key> <hint> [password] : Add a password to the vault
        -d,  --del <key>                   : Remove a password from the vault
        -u,  --upd <key> <hint> [password] : Update a password from the vault
        -l, --list [filter]                : List all passwords or matching the given filter
""".format(VERSION, APP_NAME)

OPER_MAP = {
    'add': None, 'get': None, 'del': None, 'upd': None, 'list': None
}

ENTRY_FORMAT = """[{}]:
         Key: {}
    Password: {}
        Hint: {}
    Modified: {}
"""

LINE_FORMAT = """{}|{}|{}|{}
"""

USERNAME = getpass.getuser()

HHS_DIR = "/Users/{}/.hhs".format(USERNAME)

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

    def __init__(self):
        self.data = {}
        self.is_open = False
        self.is_modified = False
        self.passphrase = self.get_passphrase()

    # @purpose: Encode the vault file into base64
    @staticmethod
    def encode():
        with open(VAULT_GPG_FILE, 'r') as vault_file:
            with open(VAULT_FILE, 'w') as enc_vault_file:
                enc_vault_file.write(str(base64.b64encode(vault_file.read())))
                log("DEBUG", "Vault is encoded !")

    # @purpose: Decode the vault file from base64
    @staticmethod
    def decode():
        with open(VAULT_FILE, 'r') as vault_file:
            with open(VAULT_GPG_FILE, 'w') as dec_vault_file:
                dec_vault_file.write(str(base64.b64decode(vault_file.read())))
                log("DEBUG", "Vault is decoded !")

    # @purpose: Retrieve the vault passphrase
    def get_passphrase(self):
        if not os.path.exists(VAULT_FILE) or os.stat(VAULT_FILE).st_size == 0:
            self.is_open = True
            self.is_modified = True
            print ("@@@ Your Vault '{}' file is empty !".format(VAULT_FILE))
            prompt = "The following password will be assigned to it: "
        else:
            prompt = "Type your Vault passphrase: "
        passphrase = os.environ.get('HHS_VAULT_PASSPHRASE')
        if passphrase:
            return "{}:{}".format(USERNAME, base64.b64decode(passphrase))
        else:
            while not passphrase:
                passphrase = getpass.getpass(prompt).strip()
            return "{}:{}".format(USERNAME, passphrase)

    # @purpose: Open and read the Vault file
    def open(self):
        if not self.is_open:
            self.decrypt()
        if self.is_open:
            self.read()
        else:
            raise TypeError("### Unable to read from Vault file '{}' ".format(VAULT_FILE))
        log("DEBUG", "Vault is open !")

    # @purpose: Close the Vault file and cleanup temporary files
    def close(self):
        if self.is_modified:
            self.save()
        if self.is_open:
            self.encrypt()
        if os.path.exists(VAULT_GPG_FILE):
            os.remove(VAULT_GPG_FILE)
        log("DEBUG", "Vault is closed !")

    # @purpose: Encrypt and then, encode the vault file
    def encrypt(self):
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch', '--symmetric',
            '--passphrase={}'.format(self.passphrase),
            '--output', VAULT_GPG_FILE, VAULT_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        Vault.encode()
        self.is_open = False
        log("DEBUG", "Vault is encrypted !")

    # @purpose: Decode and then, decrypt the vault file
    def decrypt(self):
        Vault.decode()
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch',
            '--passphrase={}'.format(self.passphrase),
            '--output', VAULT_FILE, VAULT_GPG_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        self.is_open = True
        log("DEBUG", "Vault is decrypted !")

    # @purpose: Save all vault entries
    def save(self):
        with open(VAULT_FILE, 'w') as f_vault:
            for entry in self.data:
                f_vault.write(str(self.data[entry]))
            log("DEBUG", "Vault is saved !")

    # @purpose: Read all existing vault entries
    def read(self):
        if os.path.exists(VAULT_FILE):
            try:
                with open(VAULT_FILE, 'r') as f_vault:
                    for line in f_vault:
                        if not line.strip():
                            continue
                        (key, password, hint, modified) = line.strip().split('|')
                        entry = VaultEntry(key, password, hint, modified)
                        self.data[key] = entry
            except ValueError:
                raise TypeError("### Vault file '{}' is invalid".format(VAULT_FILE))

    # @purpose: List all vault entries
    def list(self, filter_expr=None):
        if len(self.data) > 0:
            if filter_expr:
                data = list(filter(lambda x: filter_expr in x, self.data))
                prompt = "\n=== Listing vault entries filtered by '%{}%' ===\n".format(filter_expr)
            else:
                data = self.data
                prompt = "\n=== Listing all vault entries ===\n"
            print (prompt)
            if len(data) > 0:
                for entry_key in data:
                    print(self.data[entry_key].to_string())
            else:
                print ("\nxXx No results to display xXx\n")
        else:
            print ("\nxXx Vault is empty xXx\n")

    # @purpose: Add a vault entry
    def add(self, key, hint, password):
        if key not in self.data.keys():
            if not password:
                passphrase = getpass.getpass("Type a password for '{}': ".format(key)).strip()
            else:
                passphrase = password
            entry = VaultEntry(key, passphrase, hint)
            self.data[key] = entry
            self.is_modified = True
            print ("\nAdded => {}".format(entry.to_string()))
        else:
            print ("### Entry specified by '{}' already exists in vault".format(key))

    # @purpose: Retrieve a vault entry
    def get(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            print ("\n{}".format(entry.to_string(True)))
        else:
            print ("### No entry specified by '{}' was found in vault".format(key))

    # @purpose: Update a vault entry
    def update(self, key, hint, password):
        if key in self.data.keys():
            if not password:
                passphrase = getpass.getpass("Type a password for '{}': ".format(key)).strip()
            else:
                passphrase = password
            entry = VaultEntry(key, passphrase, hint)
            self.data[key] = entry
            self.is_modified = True
            print ("\nUpdated => {}".format(entry.to_string()))
        else:
            print ("### No entry specified by '{}' was found in vault".format(key))

    # @purpose: Remove a vault entry
    def remove(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            del self.data[key]
            self.is_modified = True
            print ("\nRemoved => {}".format(entry.to_string()))
        else:
            print ("### No entry specified by '{}' was found in vault".format(key))


# @purpose: Represents a vault entity
class VaultEntry(object):

    def __init__(self, key, password, hint, modified=None):
        self.key = key
        self.password = password
        self.hint = hint
        self.modified = modified if modified is not None else datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def __str__(self):
        return LINE_FORMAT.format(self.key, self.password, self.hint, self.modified)

    def to_string(self, show_password=False):
        password = self.password if show_password else re.sub('.*', '*' * 6, self.password)
        return ENTRY_FORMAT.format(self.key, self.key, password, self.hint, self.modified)


# @purpose: Execute the specified operation
def exec_operation(op):
    vault = Vault()
    options = OPER_MAP[op]
    try:
        vault.open()
        if "add" == op:
            vault.add(options[0], options[1], None if len(options) < 3 else options[2])
        elif "get" == op:
            vault.get(options[0])
        elif "del" == op:
            vault.remove(options[0])
        elif "upd" == op:
            vault.update(options[0], options[1], None if len(options) < 3 else options[2])
        elif "list" == op:
            vault.list(None if len(options) < 1 else options[0])
        else:
            print('### Unhandled operation: {}'.format(op))
    except subprocess.CalledProcessError:
        print('### Authorization failed or invalid passphrase')
        quit(2)
    # except TypeError as err:
    #     print ("### {}. Trying to recover ...".format(err.message, VAULT_FILE))
    #     vault.open = True
    finally:
        vault.close()


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


def log(level, message):
    # print ("[{}] {}".format(level, message))
    pass

# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    try:

        if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
            usage()

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhagdul', ['add', 'get', 'del', 'upd', 'list'])

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-a', '--add'):
                check_arguments(args, 2)
                OPER_MAP['add'] = args
            elif opt in ('-g', '--get'):
                check_arguments(args, 1)
                OPER_MAP['get'] = args
            elif opt in ('-d', '--del'):
                check_arguments(args, 1)
                OPER_MAP['del'] = args
            elif opt in ('-u', '--upd'):
                check_arguments(args, 2)
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


if __name__ == "__main__":
    main(sys.argv[1:])
    sys.exit(0)
