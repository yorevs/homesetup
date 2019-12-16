#!/usr/bin/env python

"""
  @package: -
   @script: tcalc.py
  @purpose: Provides time calculations.
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import math
import os
import re
import sys

PROC_NAME       = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION         = (0, 9, 0)

# Usage message
USAGE           = """
Calculate time based operations

Usage: python {} [-d|--decimal] <HH1:MM1[:SS1]> <+|-> <HH2:MM2[:SS2]>
""".format(PROC_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


DECIMAL=False
TOTAL_SECONDS = 0
OP = '+'

if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
    usage()

if sys.argv[1] in ['-d', '--decimal']:
    DECIMAL=True
    args = sys.argv[2:]
else:
    args = sys.argv[1:]


def decimal(time_raw=0):
    time_dec = round(((time_raw / 60.0) * 100.0) if DECIMAL else time_raw)
    return int(time_dec)


for tm in args:
    if re.match(r"[+-]", tm):
        OP = tm
    elif re.match(r"^([0-9]{1,2}:?)+", tm):
        parts = [int(math.floor(float(s))) for s in tm.split(':')]
        f_hours = parts[0] if len(parts) > 0 else 0
        f_mins = parts[1] if len(parts) > 1 else 0
        f_secs = parts[2] if len(parts) > 2 else 0
        tm_amount = ((f_hours * 60 + f_mins) * 60 + f_secs )
        if OP == '+':
            TOTAL_SECONDS += tm_amount
        elif OP == '-':
            TOTAL_SECONDS -= tm_amount

TOTAL_SECONDS, seconds = divmod(TOTAL_SECONDS, 60)
hours, minutes = divmod(TOTAL_SECONDS, 60)

print('{0:02d}:{1:02d}:{2:02d}'.format(hours, decimal(minutes), decimal(seconds)))
