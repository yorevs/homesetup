#!/usr/bin/env python

"""
   @script: DeployerApp.py
  @purpose: Deployer for HomeSetup
  @created: Nov 12, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: ???

import sys

from Versioner import Versioner
from GitUtils import GitUtils
from DocBuilder import Readme

from os import path, environ
from getopt import getopt

APP_NAME = path.basename(__file__)

# Version tuple: (major, minor, build)
APP_VERSION = (0, 9, 0)

# Usage message
APP_USAGE = """
Deployer for HomeSetup

Usage: {} [reset,build,minor,major]
""".format(APP_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(APP_USAGE)
    quit_app(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, APP_VERSION[0], APP_VERSION[1], APP_VERSION[2]))
    quit_app(0)


# @purpose: Quit the app.
def quit_app(exit_code=0, exit_message=''):
    print(exit_message)
    sys.exit(exit_code)


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    if len(argv) > 0 and argv[0] in ['-h', '--help']:
        usage()
    elif len(argv) > 0 and argv[0] in ['-v', '--version']:
        version()

    opts, args = getopt(argv, 'hv', ['help', 'version'])

    for opt, args in opts:
        if opt in ('-h', '--help'):
            usage()
        elif opt in ('-v', '--version'):
            version()

    # print("--- VersionUtils ---")
    # ver_field = 'patch' if len(argv) < 1 else argv[0].strip().lower()
    # # ver_file = environ['HHS_HOME'] + '/.VERSION'
    # ver_file = '../samples/.VERSION'
    # ver = Versioner(ver_field, ver_file)
    # print('Current version: {}\n'.format(ver.current()))
    # ver.update_build()
    # ver.update_version()
    # print('After increase build version: {}\n'.format(ver.current()))
    # ver.update_minor()
    # ver.update_version()
    # print('After increase build minor: {}\n'.format(ver.current()))
    # ver.update_major()
    # ver.update_version()
    # print('After increase build major: {}\n'.format(ver.current()))

    print("--- GitUtils ---")
    # print("TopLevelDir: {}".format(GitUtils.top_level_dir()))
    # print("CurrentBranch: {}".format(GitUtils.current_branch()))
    # print("GitUserName: {}\n".format(GitUtils.username()))
    # print("v1.3.0 Released at {}\n".format(GitUtils.release_date("v1.3.0")))
    # print("Unreleased: ---- Current ---- \n{}\n".format(GitUtils.unreleased()))
    print("ChangeLog: ---- v1.3.0 ---- \n{}\n".format(GitUtils.changelog("v1.3.0", "v1.4.0")))
    # print("ChangeLog: ---- v1.2.0 ---- \n{}\n".format(GitUtils.changelog("v1.2.0", "v1.3.0")))
    # print("ChangeLog: ---- v1.1.0 ---- \n{}\n".format(GitUtils.changelog("v1.1.0", "v1.2.0")))
    # print("ChangeLog: ---- v1.0.0 ---- \n{}\n".format(GitUtils.changelog("v1.0.0", "v1.1.0")))
    # print("ChangeLog: ---- v0.9.0 ---- \n{}\n".format(GitUtils.changelog("v0.9.0", "v1.0.0")))

    print("--- DocUtils ---")
    doc = Readme()
    print(doc)


# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
    quit_app(0)
