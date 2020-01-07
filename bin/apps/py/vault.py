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
import atexit
import signal
import sys
import os
import re
import getopt
import getpass
import base64
import subprocess
import datetime
import traceback
import logging as log

# Application name, read from it's own file path
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 0, 0)

# Usage message
USAGE = """
Usage: {} <args> [opts]

    HomeSetup vault v{}

    Options:
      -a  |  --add <name> <hint> [password] : Add a password entry to the vault.
      -d  |  --del <name>                   : Remove a password entry from the vault.
      -u  |  --upd <name> <hint> [password] : Update a password entry from the vault.
      -l  | --list [filter]                 : List all password entries or matching the given filter.
""".format(VERSION, APP_NAME)

OPTIONS_MAP = {}

ENTRY_FORMAT = """[{}{}{}]:
        Name: {}
    Password: {}
        Hint: {}
    Modified: {}
"""

LINE_FORMAT = """{}|{}|{}|{}
"""

VAULT_USER = os.environ.get("HHS_VAULT_USER", getpass.getuser())

HHS_DIR = os.environ.get("HHS_DIR", "/Users/{}/.hhs".format(VAULT_USER))

LOG_FILE = "{}/vault.log".format(HHS_DIR)

MAX_LOG_FILE_SIZE = 1 * 1024 * 1024

VAULT_LOCATION = os.environ.get("HHS_VAULT_LOCATION", HHS_DIR)

VAULT_FILE = "{}/{}".format(VAULT_LOCATION, os.environ.get("HHS_VAULT_FILE", ".vault"))

VAULT_GPG_FILE = "{}.gpg".format(VAULT_FILE)

WELCOME = """

HomeSetup Vault v{}

Settings ==============================

        VAULT_USER: {}
    VAULT_LOCATION: {}
        VAULT_FILE: {}
""".format(VERSION, VAULT_USER, VAULT_LOCATION, VAULT_FILE)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: Terminal colors
class Colors:
    def __init__(self):
        pass
    NC = '\x1b[0m'
    BLUE = '\x1b[0;34m'
    CYAN = '\x1b[0;36m'
    GREEN = '\x1b[0;32m'
    ORANGE = '\x1b[0;33m'
    RED = '\x1b[0;31m'
    YELLOW = '\x1b[0;33m'


# @purpose: Represents the vault
class Vault(object):

    def __init__(self):
        self.data = {}
        self.is_open = False
        self.is_modified = False
        self.is_new = False
        self.passphrase = None

    def __str__(self):
        vault_str = ""
        for entry_key in self.data:
            vault_str += str(self.data[entry_key])
        return str(vault_str)

    # @purpose: Encode the vault file into base64
    @staticmethod
    def encode():
        with open(VAULT_GPG_FILE, 'r') as vault_file:
            with open(VAULT_FILE, 'w') as enc_vault_file:
                enc_vault_file.write(str(base64.b64encode(vault_file.read())))
                log.debug("Vault is encoded !")

    # @purpose: Decode the vault file from base64
    @staticmethod
    def decode():
        with open(VAULT_FILE, 'r') as vault_file:
            with open(VAULT_GPG_FILE, 'w') as dec_vault_file:
                dec_vault_file.write(str(base64.b64decode(vault_file.read())))
                log.debug("Vault is decoded !")

    # @purpose: Handle interruptions to shutdown gracefully
    def exit_handler(self, signum=0, frame=None):
        if signum != 0 and frame is not None:
            log.warn('Signal handler hooked signum={} frame={}'.format(signum, frame))
            print('')
            ret_val = 1
        else:
            log.info('Exit handler called')
            ret_val = signum
        self.close()
        sys.exit(ret_val)

    # @purpose: Retrieve the vault passphrase
    def get_passphrase(self):
        if not os.path.exists(VAULT_FILE) or os.stat(VAULT_FILE).st_size == 0:
            cprint(Colors.ORANGE, "### Your Vault '{}' file is empty.".format(VAULT_FILE))
            cprint(Colors.ORANGE, ">>> Enter the new passphrase for this Vault")
            confirm_flag = True
        else:
            confirm_flag = False
        passphrase = os.environ.get('HHS_VAULT_PASSPHRASE')
        if passphrase:
            return "{}:{}".format(VAULT_USER, base64.b64decode(passphrase))
        else:
            while not passphrase:
                passphrase = getpass.getpass("Enter passphrase:").strip()
                confirm = None
                if passphrase and confirm_flag:
                    while not confirm:
                        confirm = getpass.getpass("Repeat passphrase:").strip()
                    if confirm != passphrase:
                        cprint(Colors.RED, "### Passphrase and confirmation mismatch")
                        quit(2)
                    else:
                        cprint(Colors.GREEN, "Passphrase successfully stored")
                        log.debug("Vault passphrase created for user={}".format(VAULT_USER))
                        self.is_open = True
                        self.is_modified = True
                        self.is_new = True
            return "{}:{}".format(VAULT_USER, passphrase)

    # @purpose: Open and read the Vault file
    def open(self):
        self.passphrase = self.get_passphrase()
        if not self.is_open:
            self.decrypt()
        if self.is_open:
            self.read()
        else:
            log.error("Attempt to open from Vault failed")
            raise TypeError("### Unable to open from Vault file '{}' ".format(VAULT_FILE))
        log.debug("Vault is open !")

    # @purpose: Close the Vault file and cleanup temporary files
    def close(self):
        if self.is_modified:
            self.save()
        if self.is_open:
            self.encrypt()
        if os.path.exists(VAULT_GPG_FILE):
            os.remove(VAULT_GPG_FILE)
        log.debug("Vault is closed modified={} open={}".format(self.is_modified, self.is_open))

    # @purpose: Encrypt and then, encode the vault file
    def encrypt(self):
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch', '--symmetric',
            '--passphrase={}'.format(self.passphrase),
            '--output', VAULT_GPG_FILE, VAULT_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        log.debug("Vault is encrypted !")
        self.is_open = False
        Vault.encode()

    # @purpose: Decode and then, decrypt the vault file
    def decrypt(self):
        Vault.decode()
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch', '--digest-algo', 'SHA512',
            '--passphrase={}'.format(self.passphrase),
            '--output', VAULT_FILE, VAULT_GPG_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        self.is_open = True
        log.debug("Vault is decrypted !")

    # @purpose: Save all vault entries
    def save(self):
        with open(VAULT_FILE, 'w') as f_vault:
            for entry in self.data:
                f_vault.write(str(self.data[entry]))
            log.debug("Vault data is saved")

    # @purpose: Read all existing vault entries
    def read(self):
        if os.path.exists(VAULT_FILE):
            try:
                with open(VAULT_FILE, 'r') as f_vault:
                    for line in f_vault:
                        if not line.strip():
                            continue
                        (key, password, hint, modified) = line.strip().split('|')
                        entry = Vault.Entry(key, password, hint, modified)
                        self.data[key] = entry
                    log.debug("Vault has been read. Returned entries={}".format(len(self.data)))
            except ValueError:
                log.error("Attempt to read from Vault failed")
                raise TypeError("### Vault file '{}' is invalid".format(VAULT_FILE))

    # @purpose: Filter and sort vault data and return the proper header for listing them
    def fetch_data(self, filter_expr):
        if filter_expr:
            data = list(filter(lambda x: filter_expr in x, self.data))
            header = """\n=== Listing vault entries containing '{}' ===\n""".format(filter_expr)
        else:
            data = list(self.data)
            header = "\n=== Listing all vault entries ===\n"
        data.sort()
        log.debug(
            "Vault data fetched. Returned entries={} filtered={}".format(len(self.data), len(self.data) - len(data)))

        return data, header

    # @purpose: List all vault entries
    def list(self, filter_expr=None):
        if len(self.data) > 0:
            (data, header) = self.fetch_data(filter_expr)
            if len(data) > 0:
                cprint(Colors.ORANGE, header)
                for entry_key in data:
                    print(self.data[entry_key].to_string())
            else:
                cprint(Colors.YELLOW, "\nxXx No results to display containing '{}' xXx\n".format(filter_expr))
        else:
            cprint(Colors.YELLOW, "\nxXx Vault is empty xXx\n")
        log.debug("Vault list issued. User={}".format(getpass.getuser()))

    # @purpose: Add a vault entry
    def add(self, key, hint, password):
        if key not in self.data.keys():
            while not password:
                password = getpass.getpass("Type the password for '{}': ".format(key)).strip()
            entry = Vault.Entry(key, password, hint)
            self.data[key] = entry
            self.is_modified = True
            cprint(Colors.GREEN, "\n=== Entry added ===\n\n{}".format(entry.to_string()))
        else:
            log.error("Attempt to add to Vault failed for key={}".format(key))
            cprint(Colors.RED, "### Entry specified by '{}' already exists in vault".format(key))
        log.debug("Vault add issued. User={}".format(getpass.getuser()))

    # @purpose: Retrieve a vault entry
    def get(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            cprint(Colors.GREEN, "\n{}".format(entry.to_string(True)))
        else:
            log.error("Attempt to get from Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        log.debug("Vault get issued. User={}".format(getpass.getuser()))

    # @purpose: Update a vault entry
    def update(self, key, hint, password):
        if key in self.data.keys():
            if not password:
                passphrase = getpass.getpass("Type a password for '{}': ".format(key)).strip()
            else:
                passphrase = password
            entry = Vault.Entry(key, passphrase, hint)
            self.data[key] = entry
            self.is_modified = True
            cprint(Colors.GREEN, "\n=== Entry updated ===\n\n{}".format(entry.to_string()))
        else:
            log.error("Attempt to update Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        log.debug("Vault update issued. User={}".format(getpass.getuser()))

    # @purpose: Remove a vault entry
    def remove(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            del self.data[key]
            self.is_modified = True
            cprint(Colors.GREEN, "\n=== Entry removed ===\n\n{}".format(entry.to_string()))
        else:
            log.error("Attempt to remove to Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        log.debug("Vault remove issued. User={}".format(getpass.getuser()))

    # @purpose: Represents a vault entity
    class Entry(object):

        def __init__(self, key, password, hint, modified=None):
            self.key = key
            self.password = password
            self.hint = hint
            self.modified = modified if modified is not None else datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        def __str__(self):
            return LINE_FORMAT.format(self.key, self.password, self.hint, self.modified)

        def to_string(self, show_password=False):
            password = self.password if show_password else re.sub('.*', '*' * 6, self.password)
            return ENTRY_FORMAT.format(Colors.GREEN, self.key, Colors.NC, self.key, password, self.hint, self.modified)


# @purpose: Get an argument from the list or None if index is out of range
def get_argument(options, index, fallback=None):
    argument = fallback if len(options) < index + 1 else options[index]
    return argument


# @purpose: Execute the specified operation
def exec_operation(op, vault):
    options = list(OPTIONS_MAP[op])
    vault.open()
    if not vault.is_new:
        if "add" == op:
            vault.add(options[0], options[1], get_argument(options, 2))
        elif "get" == op:
            vault.get(options[0])
        elif "del" == op:
            vault.remove(options[0])
        elif "upd" == op:
            vault.update(options[0], options[1], get_argument(options, 2))
        elif "list" == op:
            vault.list(get_argument(options, 0))
        else:
            cprint(Colors.RED, '### Unhandled operation: {}'.format(op))
            usage(1)


# @purpose: Execute the app business logic
def app_exec(vault):
    for op in OPTIONS_MAP:
        if not OPTIONS_MAP[op] is None:
            exec_operation(op, vault)
            break


# @purpose: Execute the app business logic
def check_arguments(args, args_num=0):
    if len(args) < args_num:
        cprint(Colors.RED, "### Invalid number of arguments: {} , expecting: {}".format(len(args), args_num))
        usage(1)


# @purpose: Initialize the logger
def log_init():
    f_size = os.path.getsize(LOG_FILE)
    f_mode = "a" if f_size < MAX_LOG_FILE_SIZE else "w"
    log.basicConfig(
        filename=LOG_FILE,
        format='%(asctime)s [%(threadName)-10.10s] %(levelname)-5.5s ::%(funcName)s(@line-%(lineno)d) %(message)s ',
        level=log.DEBUG,
        filemode=f_mode)
    log.info(WELCOME)


# @purpose: Colored print
def cprint(color, message):
    print("{}{}{}".format(color, message, Colors.NC))


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    vault = Vault()

    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhagdul', ['add', 'get', 'del', 'upd', 'list'])

        if len(opts) == 0:
            usage()

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-a', '--add'):
                check_arguments(args, 2)
                OPTIONS_MAP['add'] = args
            elif opt in ('-g', '--get'):
                check_arguments(args, 1)
                OPTIONS_MAP['get'] = args
            elif opt in ('-d', '--del'):
                check_arguments(args, 1)
                OPTIONS_MAP['del'] = args
            elif opt in ('-u', '--upd'):
                check_arguments(args, 2)
                OPTIONS_MAP['upd'] = args
            elif opt in ('-l', '--list'):
                OPTIONS_MAP['list'] = args
            else:
                assert False, '### Unhandled option: {}'.format(opt)
            break

        log_init()
        signal.signal(signal.SIGINT, vault.exit_handler)
        atexit.register(vault.exit_handler)
        app_exec(vault)

    # Catch getopt exceptions
    except getopt.GetoptError as err:
        cprint(Colors.RED, 'Invalid option: => {}'.format(err.msg))
        usage(2)

    # Catch keyboard interrupts
    except KeyboardInterrupt:
        print ('')
        quit(1)

    # Catch authentication errors
    except subprocess.CalledProcessError:
        log.error("Attempt to unlock Vault failed for user '{}'".format(VAULT_USER))
        cprint(Colors.RED, "### Authentication failed")
        quit(2)

    # Attempt to fix the vault file
    except TypeError as err:
        if str(err).endswith('Incorrect padding'):
            log.warn("Trying to recover invalid vault file")
            vault.is_open = True
            quit(1)

    # Catch other exceptions
    except Exception as err:
        traceback.format_exc()
        log.error("Exception in user code:")
        log.error('-' * 60)
        log.error(traceback.format_exc())
        log.error('-' * 60)
        cprint(Colors.RED, err)
        quit(2)


if __name__ == "__main__":
    main(sys.argv[1:])
    quit(0)
