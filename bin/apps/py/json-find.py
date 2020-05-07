#!/usr/bin/env python

"""
  @package: -
   @script: json-find.py
  @purpose: Find an object from the json string or json file.
  @created: Jan 20, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: Python 2.7 and Python 3.7

import sys
import os
import getopt
import json

from hhslib.jsonutils.JsonUtils import JsonUtils

# This application name.
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
APP_VERSION = (0, 9, 0)

# Usage message
USAGE = """
Find a json path from a json string

Usage: {} -f <filename> -a <search_path>
""".format(APP_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, APP_VERSION[0], APP_VERSION[1], APP_VERSION[2]))
    sys.exit(0)


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):

    if len(argv) < 1 or argv[0] in ['-h', '--help']:
        usage()

    f_json = None
    json_obj = None
    alias = None
    index = 1
    j_utils = JsonUtils()

    opts, args = getopt.getopt(argv[0:], 'f:a:', ['file', 'alias'])

    for opt, args in opts:
        if opt in ('-f', '--file'):
            f_json = args
            with open(f_json) as json_file:
                json_obj = json.load(json_file)
            index += 2
        elif opt in ('-a', '--alias'):
            alias = args
            index += 2

    if f_json is None:
        json_str = ', '.join(str(x) for x in sys.argv[index:])
        json_obj = json.loads(json_str)

    content = j_utils.jsonSelect(json_obj, alias)
    print('{}'.format('' if content is None else content))


# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
