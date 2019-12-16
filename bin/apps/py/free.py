#!/usr/bin/env python

"""@package -
   @script: free.py
  @purpose: Report system memory usage.
  @created: Nov 20, 2008
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import os
import re
import subprocess
import sys

PROC_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (0, 9, 0)

# Usage message
USAGE = """
Report system memory usage.

Usage: python {}
""".format(PROC_NAME)


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


def human_readable(str_size):
    byte_size = float(str_size)
    kb, mb, gb, tb = 2 ** 10, 2 ** 20, 2 ** 30, 2 ** 40
    if 0 <= byte_size <= kb:
        ret_val = '%3.2f' % byte_size
        ret_unit = '[B]'
    elif kb < byte_size <= mb:
        ret_val = '%3.2f' % (byte_size / kb)
        ret_unit = '[Kb]'
    elif mb < byte_size <= gb:
        ret_val = '%3.2f' % (byte_size / mb)
        ret_unit = '[Mb]'
    elif gb < byte_size <= tb:
        ret_val = '%3.2f' % (byte_size / gb)
        ret_unit = '[Gb]'
    else:
        ret_val = '%3.2f' % (byte_size / tb)
        ret_unit = '[Tb]'

    return ret_val, ret_unit


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    ret_val = 0
    try:

        if len(sys.argv) > 1 and sys.argv[1] in ['-h', '--help']:
            usage()

        # Get process info
        ps = subprocess.Popen(['ps', '-caxm', '-orss,comm'], stdout=subprocess.PIPE).communicate()[0].decode()
        vm = subprocess.Popen(['vm_stat'], stdout=subprocess.PIPE).communicate()[0].decode()

        # Iterate processes
        process_lines = ps.split('\n')
        sep = re.compile('[\s]+')
        rss_total = 0  # kB

        for row in range(1, len(process_lines)):
            row_text = process_lines[row].strip()
            row_elements = sep.split(row_text)
            try:
                rss = float(row_elements[0]) * 1024
            except Exception as err:
                rss = 0  # ignore...
                pass
            rss_total += rss

        # Process vm_stat
        vm_lines = vm.split('\n')
        sep = re.compile(':[\s]+')
        vm_stats = {}

        for row in range(1, len(vm_lines) - 2):
            row_text = vm_lines[row].strip()
            row_elements = sep.split(row_text)
            vm_stats[(row_elements[0])] = int(row_elements[1].strip('\.')) * 4096

        wired, wu = human_readable(vm_stats["Pages wired down"])
        active, au = human_readable(vm_stats["Pages active"])
        inactive, iu = human_readable(vm_stats["Pages inactive"])
        free, fu = human_readable(vm_stats["Pages free"])
        real, ru = human_readable(rss_total)  # Total memory

        print(' ')
        print('    Wired Memory: %06s %s' % (wired, wu))
        print('   Active Memory: %06s %s' % (active, au))
        print(' Inactive Memory: %06s %s' % (inactive, iu))
        print('     Free Memory: %06s %s' % (free, fu))
        print('     Real Memory: %06s %s' % (real, ru))
        print(' ')

    except Exception as err:  # catch *all* exceptions
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format(err))
        ret_val = 1
    finally:
        sys.exit(ret_val)


# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
