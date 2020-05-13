#!/usr/bin/env python

"""
  @package: -
   @script: tcalc.py
  @purpose: Simple app to do mathematical calculations with time.
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: Python 2.7 and Python 3.7

import math
import os
import re
import sys

# This application name.
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (0, 9, 0)

# Help message to be displayed by the application.
USAGE = """
Calculate time based operations

Usage: {} [-d|--decimal] <HH1:MM1[:SS1]> <+|-> <HH2:MM2[:SS2]>
""".format(APP_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: Convert a raw time into decimal
def decimal(time_raw=0):
    return int(round(((time_raw / 60.00) * 100.00) if DECIMAL else time_raw))


DECIMAL = False
TOTAL_SECONDS = 0
OP = '+'

if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
    usage()

if sys.argv[1] in ['-d', '--decimal']:
    DECIMAL = True
    args = sys.argv[2:]
else:
    args = sys.argv[1:]

for tm in args:
    if re.match(r"[+-]", tm):
        OP = tm
    elif re.match(r"^([0-9]{1,2}:?)+", tm):
        try:
            parts = [int(math.floor(float(s))) for s in tm.split(':')]
        except ValueError:
            parts = [0, 0, 0]
        f_hours = parts[0] if len(parts) > 0 else 0
        f_minutes = parts[1] if len(parts) > 1 else 0
        f_secs = parts[2] if len(parts) > 2 else 0
        tm_amount = ((f_hours * 60 + f_minutes) * 60 + f_secs)
        
        if OP == '+':
            TOTAL_SECONDS += tm_amount
        elif OP == '-':
            TOTAL_SECONDS -= tm_amount

TOTAL_SECONDS, seconds = divmod(TOTAL_SECONDS, 60)
hours, minutes = divmod(TOTAL_SECONDS, 60)

if DECIMAL:
    print('{0:02d}.{1:02d}.{2:02d}'.format(hours, decimal(minutes), decimal(seconds)))
else:
    print('{0:02d}:{1:02d}:{2:02d}'.format(hours, decimal(minutes), decimal(seconds)))
