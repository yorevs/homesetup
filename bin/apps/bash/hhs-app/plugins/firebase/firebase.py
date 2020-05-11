"""
    @package: -
    @script: firebase.py
    @purpose: This application is a firebase integration
    @created: Mon 27, 2020
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
        @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""
import ast
import atexit
import base64
import getopt
import getpass
import signal
import traceback
import uuid

from datetime import datetime
from os import path

from hhslib.colors import cprint, Colors
from hhslib.commons import *
from hhslib.fetch import *

# Application name, read from it's own file path
from pip._vendor.distlib.compat import raw_input

APP_NAME = path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (1, 1, 0)

# Usage message
USAGE = """
Usage: {} <option> [arguments]

    HomeSetup firebase v{} Manage your firebase integration.
    
    Options:
      -v  |  --version              : Display current program version.
      -h  |     --help              : Display this help message.
      -s  |    --setup              : Setup your Firebase account to use with HomeSetup.
      -u  |   --upload <db_alias>   : Upload dotfiles to your Firebase Realtime Database.
      -d  | --download <db_alias>   : Download dotfiles from your Firebase Realtime Database.
      
    Arguments:
      db_alias  : Alias to be used to identify the firebase object to fetch payload from.
""".format(APP_NAME, ' '.join(map(str, VERSION)))

OPTIONS_MAP = {}

FIREBASE_USER = getpass.getuser()

HOME_DIR = os.environ.get("HOME", "/Users/{}".format(FIREBASE_USER))

HHS_DIR = os.environ.get("HHS_DIR", "/{}/.hhs".format(HOME_DIR))

LOG_FILE = "{}/firebase.log".format(HHS_DIR)

LOG = log_init(LOG_FILE)

# Firebase configuration file.
FB_CFG_FILE = "{}/.firebase".format(HHS_DIR)

# Firebase url template
FB_URL_TPL = "https://{}.firebaseio.com/homesetup"

# Firebase dotfiles url template
FB_DOTFILES_URL_TPL = "{}/dotfiles/{}/{}.json"

# Regex to validate the created UUID
UUID_RE = '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'

# Dotfiles managed by this app.
DOTFILES = {
    'aliases': '{}/.aliases'.format(HOME_DIR),
    'colors': '{}/.colors'.format(HOME_DIR),
    'env': '{}/.env'.format(HOME_DIR),
    'functions': '{}/.functions'.format(HOME_DIR),
    'path': '{}/.path'.format(HHS_DIR),
    'profile': '{}/.profile'.format(HOME_DIR),
    'commands': '{}/.cmd_file'.format(HHS_DIR),
    'savedDirs': '{}/.saved_dirs'.format(HHS_DIR),
    'aliasdef': '{}/.aliasdef'.format(HOME_DIR),
}

WELCOME = """

HomeSetup Firebase v{}

Settings ==============================
        FIREBASE_USER: {}
        FB_CFG_FILE: {}
        STARTED: {}
""".format(VERSION, FIREBASE_USER, FB_CFG_FILE, datetime.now())

# Firebase configuration format
FB_CONFIG_FMT = """
# Your Firebase configuration:
# --------------------------
PROJECT_ID={}
USERNAME={}
FIREBASE_URL={}
PASSPHRASE={}
UUID={}
"""


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


class FirebaseConfig:
    # @purpose: Create config from dict
    @staticmethod
    def of(config_dict):
        return FirebaseConfig(
            config_dict['PROJECT_ID'],
            config_dict['USERNAME'],
            config_dict['FIREBASE_URL'],
            config_dict['PASSPHRASE'],
            config_dict['UUID']
        )

    # @purpose: Create a config loading the config file
    @staticmethod
    def from_file():
        if path.exists(FB_CFG_FILE):
            LOG.info("Config file exists, reading payload")
            with open(FB_CFG_FILE, 'r') as f_config:
                cfg = {}
                for line in f_config:
                    line = line.strip()
                    if line.startswith("#") or "=" not in line:
                        continue
                    key, value = line.split("=", 1)
                    cfg[key.strip()] = value.strip()
                return FirebaseConfig.of(cfg) if len(cfg) == 5 else None
        else:
            LOG.warn("Config file does not exist, creating new")
            create_file(FB_CFG_FILE)

    # @purpose: Create a config prompting the user for information
    @staticmethod
    def prompt():
        config = FirebaseConfig()
        print("### Firebase setup")
        print('-' * 31)
        config.project_id = raw_input('Please type you Project ID: ')
        config.username = FIREBASE_USER
        config.passprase = base64.b32encode(getpass.getpass('Please type a password to encrypt you payload: '))
        config.project_uuid = raw_input('Please type a UUID to use or press enter to generate a new one: ')
        config.project_uuid = str(uuid.uuid4()) if not config.project_uuid else config.project_uuid
        config.firebase_url = FB_URL_TPL.format(config.project_id)

        return config

    def __init__(self, project_id=None, username=None, firebase_url=None, passphrase=None, project_uuid=None):
        self.project_id = project_id
        self.username = username
        self.firebase_url = firebase_url
        self.passprase = passphrase
        self.project_uuid = project_uuid

    def __str__(self):
        return FB_CONFIG_FMT.format(
            self.project_id, self.username, self.firebase_url, self.passprase, self.project_uuid
        )

    # @purpose: Save the current config
    def save(self):
        with open(FB_CFG_FILE, 'w') as f_config:
            f_config.write(str(self))
            LOG.info("Firebase configuration saved !")
        
        return self


class DotfilesPayload:
    def __init__(self, db_alias, username):
        self.db_alias = db_alias
        self.data = {
            'lastUpdate': datetime.now().strftime("%d/%m/%Y %H:%M:%S"),
            'lastUser': username
        }

    def __str__(self):
        return json.dumps(self.__dict__)

    def parse_payload(self, payload):
        try:
            dict_entry = dict(ast.literal_eval(json.loads(payload)))
            for key, value in dict_entry.iteritems():
                self.data[key] = value
            return True
        except ValueError:
            return False

    def load_all(self):
        for name, dotfile in DOTFILES.iteritems():
            if path.exists(dotfile):
                LOG.debug("Reading name={} dotfile={}".format(name, dotfile))
                with open(dotfile, 'r') as f_dotfile:
                    self.data[name] = str(base64.b64encode(f_dotfile.read()))
            else:
                LOG.warn("Dotfile {} does not exist. Ignoring it".format(dotfile))

        return self

    def save_all(self):
        for name, dotfile in DOTFILES.iteritems():
            if name in self.data:
                LOG.debug("Saving name={} dotfile={}".format(name, dotfile))
                with open(dotfile, 'w') as f_dotfile:
                    f_dotfile.write(str(base64.b64decode(self.data[name])))
            else:
                LOG.warn("Name={} is not part of data. Ignoring it".format(name))

        return self


# @purpose: Represents the firebase
class Firebase(object):

    def __init__(self):
        self.payload = None
        self.config = None

    def __str__(self):
        return str(self.payload)

    def load_settings(self):
        self.config = FirebaseConfig.from_file()

    def setup(self):
        self.config = FirebaseConfig.prompt().save()
        response = get(self.config.firebase_url, silent=True)
        if response is not None:
            LOG.debug('Successfully fetch from firebase: {} => {}'.format(self.config.firebase_url, response))
            cprint(Colors.GREEN, 'Firebase configuration for \"{}\" succeeded !'.format(self.config.username))

    def upload(self, db_alias):
        url = FB_DOTFILES_URL_TPL.format(self.config.firebase_url, self.config.project_uuid, db_alias)
        entry = DotfilesPayload(db_alias, self.config.username)
        self.payload = json.dumps(entry.load_all().data)
        patch(url, self.payload, silent=True)
        if Firebase.validate_upload(entry, url):
            cprint(Colors.GREEN, 'Dotfiles \"{}\" successfully uploaded !'.format(db_alias))
        else:
            cprint(Colors.RED, 'Failed to upload \"{}\" to firebase'.format(db_alias))
    
    @staticmethod
    def validate_upload(entry, url):
        LOG.debug('Validating upload to {} at {}'.format(url, entry.data['lastUpdate']))
        try:
            uploaded = get(url, silent=True)
            return uploaded is not None and entry.data['lastUpdate'] in uploaded
        except subprocess.CalledProcessError as err:
            LOG.error('Failed to upload \"{}\" to firebase'.format(err))
            return False
        
    def download(self, db_alias):
        url = FB_DOTFILES_URL_TPL.format(self.config.firebase_url, self.config.project_uuid, db_alias)
        entry = DotfilesPayload(db_alias, self.config.username)
        self.payload = get(url, silent=True)
        if entry.parse_payload(self.payload):
            entry.save_all()
            cprint(Colors.GREEN, 'Dotfiles \"{}\" successfully downloaded !'.format(db_alias))
        else:
            cprint(Colors.RED, 'Failed to download \"{}\" from firebase'.format(db_alias))

    def is_setup(self):
        return self.config is not None and self.config.firebase_url is not None


# @purpose: Execute the specified operation
def exec_operation(op, firebase):
    options = list(OPTIONS_MAP[op])
    firebase.load_settings()
    if not firebase.is_setup() or "setup" == op:
        firebase.setup()
    if firebase.is_setup() and "upload" == op:
        firebase.upload(options[0])
    elif firebase.is_setup() and "download" == op:
        firebase.download(options[0])
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
    firebase = Firebase()

    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhsu:d:l', ['version', 'help', 'setup', 'upload', 'download'])

        if len(opts) == 0:
            usage()

        # Parse the command line arguments passed
        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-s', '--setup'):
                OPTIONS_MAP['setup'] = args
            elif opt in ('-u', '--upload'):
                OPTIONS_MAP['upload'] = args if check_arguments(args, 1) else usage(1)
            elif opt in ('-d', '--download'):
                OPTIONS_MAP['download'] = args if check_arguments(args, 1) else usage(1)
            else:
                assert False, '### Unhandled option: {}'.format(opt)
            break

        LOG.info(WELCOME)
        signal.signal(signal.SIGINT, exit_handler)
        atexit.register(exit_handler)
        app_exec(firebase)

    # Catch getopt exceptions
    except getopt.GetoptError as err:
        cprint(Colors.RED, 'Invalid option: => {}'.format(err.msg))
        usage(2)

    # Catch keyboard interrupts
    except KeyboardInterrupt:
        LOG.error("Program was interrupted by the user")
        print ('')
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
