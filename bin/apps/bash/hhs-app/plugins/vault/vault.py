"""
    @package: -
    @script: vault.py
    @purpose: This application is a vault for secrets and passwords
    @created: Thu 21, 2019
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
        @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""
import atexit
import signal
import re
import getopt
import getpass
import base64
import subprocess
import datetime
import traceback

from lib.commons import *


# Application name, read from it's own file path
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 0, 0)

# Usage message
USAGE = """
Usage: {} <option> [arguments]

    HomeSetup vault v{}

    Options:
      -v  |  --version                      : Display current program version.
      -h  |  --help                         : Display this help message.
      -a  |  --add <name> <hint> [password] : Add a password entry to the vault.
      -d  |  --del <name>                   : Remove a password entry from the vault.
      -u  |  --upd <name> <hint> [password] : Update a password entry from the vault.
      -l  |  --list [filter]                : List all password payload or matching the given filter.

    Arguments:
      name      : The name of the vault entry. That will identify the entry (key).
      hint      : Any hint related to that vault entry.
      password  : The password of the vault entry. If not provided, further input will be required.
      filter    : Filter the vault payload by name.
""".format(APP_NAME, ' '.join(map(str, VERSION)))

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

LOG = log_init(LOG_FILE)

VAULT_FILE = os.environ.get("HHS_VAULT_FILE", "{}/{}".format(HHS_DIR, '.vault'))

VAULT_GPG_FILE = "{}.gpg".format(VAULT_FILE)

WELCOME = """

HomeSetup Vault v{}

Settings ==============================
        VAULT_USER: {}
        VAULT_FILE: {}
        STARTED: {}
""".format(VERSION, VAULT_USER, VAULT_FILE, datetime.now())


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
                LOG.debug("Vault is encoded !")

    # @purpose: Decode the vault file from base64
    @staticmethod
    def decode():
        with open(VAULT_FILE, 'r') as vault_file:
            with open(VAULT_GPG_FILE, 'w') as dec_vault_file:
                dec_vault_file.write(str(base64.b64decode(vault_file.read())))
                LOG.debug("Vault is decoded !")

    # @purpose: Handle interruptions to shutdown gracefully
    def exit_handler(self, signum=0, frame=None):
        if signum != 0 and frame is not None:
            LOG.warn('Signal handler hooked signum={} frame={}'.format(signum, frame))
            print('')
            ret_val = 1
        else:
            LOG.info('Exit handler called')
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
                        LOG.debug("Vault passphrase created for user={}".format(VAULT_USER))
                        with open(VAULT_FILE, 'a'):
                            os.utime(VAULT_FILE, None)
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
            LOG.error("Attempt to open from Vault failed")
            raise TypeError("### Unable to open from Vault file '{}' ".format(VAULT_FILE))
        LOG.debug("Vault is open !")

    # @purpose: Close the Vault file and cleanup temporary files
    def close(self):
        if self.is_modified:
            self.save()
        if self.is_open:
            self.encrypt()
        if os.path.exists(VAULT_GPG_FILE):
            os.remove(VAULT_GPG_FILE)
        LOG.debug("Vault is closed modified={} open={}".format(self.is_modified, self.is_open))

    # @purpose: Encrypt and then, encode the vault file
    def encrypt(self):
        cmd_args = [
            'gpg', '--quiet', '--yes', '--batch', '--symmetric',
            '--passphrase={}'.format(self.passphrase),
            '--output', VAULT_GPG_FILE, VAULT_FILE
        ]
        subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        LOG.debug("Vault is encrypted !")
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
        LOG.debug("Vault is decrypted !")

    # @purpose: Save all vault payload
    def save(self):
        with open(VAULT_FILE, 'w') as f_vault:
            for entry in self.data:
                f_vault.write(str(self.data[entry]))
            LOG.debug("Vault payload is saved")

    # @purpose: Read all existing vault payload
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
                    LOG.debug("Vault has been read. Returned payload={}".format(len(self.data)))
            except ValueError:
                LOG.error("Attempt to read from Vault failed")
                raise TypeError("### Vault file '{}' is invalid".format(VAULT_FILE))

    # @purpose: Filter and sort vault payload and return the proper header for listing them
    def fetch_data(self, filter_expr):
        if filter_expr:
            data = list(filter(lambda x: filter_expr in x, self.data))
            header = """\n=== Listing vault payload containing '{}' ===\n""".format(filter_expr)
        else:
            data = list(self.data)
            header = "\n=== Listing all vault payload ===\n"
        data.sort()
        LOG.debug(
            "Vault payload fetched. Returned payload={} filtered={}".format(len(self.data), len(self.data) - len(data)))

        return data, header

    # @purpose: List all vault payload
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
        LOG.debug("Vault list issued. User={}".format(getpass.getuser()))

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
            LOG.error("Attempt to add to Vault failed for key={}".format(key))
            cprint(Colors.RED, "### Entry specified by '{}' already exists in vault".format(key))
        LOG.debug("Vault add issued. User={}".format(getpass.getuser()))

    # @purpose: Retrieve a vault entry
    def get(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            cprint(Colors.GREEN, "\n{}".format(entry.to_string(True)))
        else:
            LOG.error("Attempt to get from Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        LOG.debug("Vault get issued. User={}".format(getpass.getuser()))

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
            LOG.error("Attempt to update Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        LOG.debug("Vault update issued. User={}".format(getpass.getuser()))

    # @purpose: Remove a vault entry
    def remove(self, key):
        if key in self.data.keys():
            entry = self.data[key]
            del self.data[key]
            self.is_modified = True
            cprint(Colors.GREEN, "\n=== Entry removed ===\n\n{}".format(entry.to_string()))
        else:
            LOG.error("Attempt to remove to Vault failed for key={}".format(key))
            cprint(Colors.RED, "### No entry specified by '{}' was found in vault".format(key))
        LOG.debug("Vault remove issued. User={}".format(getpass.getuser()))

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


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    vault = Vault()

    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhagdul', ['version', 'help', 'add', 'get', 'del', 'upd', 'list'])

        if len(opts) == 0:
            usage()

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-a', '--add'):
                OPTIONS_MAP['add'] = args if check_arguments(args, 2) else usage(1)
            elif opt in ('-g', '--get'):
                OPTIONS_MAP['get'] = args if check_arguments(args, 1) else usage(1)
            elif opt in ('-d', '--del'):
                OPTIONS_MAP['del'] = args if check_arguments(args, 1) else usage(1)
            elif opt in ('-u', '--upd'):
                OPTIONS_MAP['upd'] = args if check_arguments(args, 2) else usage(1)
            elif opt in ('-l', '--list'):
                OPTIONS_MAP['list'] = args
            else:
                assert False, '### Unhandled option: {}'.format(opt)
            break

        LOG.info(WELCOME)
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
        LOG.error("Attempt to unlock Vault failed for user '{}'".format(VAULT_USER))
        cprint(Colors.RED, "### Authentication failed")
        quit(2)

    # Attempt to fix the vault file
    except TypeError as err:
        if str(err).endswith('Incorrect padding'):
            LOG.warn("Trying to recover invalid vault file")
            vault.is_open = True
            quit(1)

    # Catch other exceptions
    except Exception as err:
        traceback.format_exc()
        LOG.error("Exception in user code:")
        LOG.error('-' * 60)
        LOG.error(traceback.format_exc())
        LOG.error('-' * 60)
        cprint(Colors.RED, err)
        quit(2)


# Application entry point
if __name__ == "__main__":
    main(sys.argv[1:])
    quit(0)
