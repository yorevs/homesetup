#!/usr/bin/env python

"""
   @script: ver-update.py
  @purpose: Provides a way to increment a version number
  @created: Nov 12, 2019
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import sys
from os import environ

VERSION = [0,0,0]
VERSION_FILE = environ['HHS_HOME'] + '/.VERSION'


def reset_version():
    VERSION[2] = 0
    VERSION[1] = 9
    VERSION[0] = 0


def update_build():
    VERSION[0] = VERSION[0] + 1
    if VERSION[0] > VERSION_MAP['build']['max_value']:
        update_minor()


def update_minor():
    VERSION[0] = 0
    VERSION[1] = VERSION[1] + 1
    if VERSION[1] > VERSION_MAP['minor']['max_value']:
        update_major()


def update_major():
    VERSION[0] = 0
    VERSION[1] = 0
    VERSION[2] = VERSION[2] + 1
    if VERSION[2] > VERSION_MAP['major']['max_value']:
        reset_version()


VERSION_MAP = { 
    'build': { 
        'max_value': 10, 'fn': update_build
    }, 
    'minor': {
        'max_value': 20, 'fn': update_minor
    }, 
    'major': {
        'max_value': 100, 'fn': update_major
    }
}

VERSION_FIELD = 'build' if len(sys.argv) < 2 else sys.argv[1].strip().lower()

if not VERSION_FIELD in VERSION_MAP:
    print 'Invalid field. Please use one of: %s' % VERSION_MAP.keys()
    sys.exit(1)

with open(VERSION_FILE, 'r+w') as fh:
    VERSION = map(int, reversed(fh.read().strip().split('.')))
    VERSION_MAP[VERSION_FIELD]['fn']()
    upd_version = '%d.%d.%03d' % (VERSION[2], VERSION[1], VERSION[0])
    fh.seek(0)
    fh.write(upd_version)
    fh.truncate()
    print 'Version updated to %s' % upd_version

