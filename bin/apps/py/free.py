#!/usr/bin/env python

"""@package -
   @script: free.py
  @purpose: Report system memory usage.
  @created: Nov 20, 2018
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: Python 2.7 and Python 3.7

import os
import re
import subprocess
import sys

# This application name.
from hhslib.commons import human_readable_bytes

APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (0, 9, 0)

# Usage message
USAGE = """
Report system memory usage.

Usage: {}
""".format(APP_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: Parse the command line arguments and execute the program accordingly.
def main():

    if len(sys.argv) > 1 and sys.argv[1] in ['-h', '--help']:
        usage()

    # Get process info
    ps = subprocess.Popen(['ps', '-caxm', '-orss,comm'], stdout=subprocess.PIPE).communicate()[0].decode()
    vm = subprocess.Popen(['vm_stat'], stdout=subprocess.PIPE).communicate()[0].decode()

    # Iterate processes
    process_lines = ps.split('\n')
    sep = re.compile(' +')
    rss_total = 0  # kB

    for row in range(1, len(process_lines)):
        row_text = process_lines[row].strip()
        row_elements = sep.split(row_text)
        if re.match('^[0-9]+$', row_elements[0]):
            rss = float(row_elements[0]) * 1024
        else:
            rss = 0
        rss_total += rss

    # Process vm_stat
    vm_lines = vm.split('\n')
    sep = re.compile(': +')
    vm_stats = {}

    for row in range(1, len(vm_lines) - 2):
        row_text = vm_lines[row].strip()
        row_elements = sep.split(row_text)
        vm_stats[(row_elements[0])] = int(row_elements[1].strip('\\.')) * 4096

    wired, wu = human_readable_bytes(vm_stats["Pages wired down"])
    active, au = human_readable_bytes(vm_stats["Pages active"])
    inactive, iu = human_readable_bytes(vm_stats["Pages inactive"])
    free, fu = human_readable_bytes(vm_stats["Pages free"])
    real, ru = human_readable_bytes(rss_total)  # Total memory

    print(' ')
    print('    Wired Memory: %06s %s' % (wired, wu))
    print('   Active Memory: %06s %s' % (active, au))
    print(' Inactive Memory: %06s %s' % (inactive, iu))
    print('     Free Memory: %06s %s' % (free, fu))
    print('     Real Memory: %06s %s' % (real, ru))
    print(' ')


# Program entry point.
if __name__ == '__main__':
    main()
