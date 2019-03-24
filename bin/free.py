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

import sys, os, subprocess
import re

PROC_NAME       = os.path.basename(__file__)
# Version tuple: (major,minor,build)
VERSION         = (0, 9, 0)
# Usage message
USAGE           = """
Report system memory usage.

Usage: python {}
""".format(PROC_NAME)

# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exitCode=0):
    print(USAGE)
    sys.exit(exitCode)

# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME,VERSION[0],VERSION[1],VERSION[2]))
    sys.exit(0)

# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    retVal = 0
    try:
        
        if len(sys.argv) > 1 and sys.argv[1] in [ '-h', '--help' ]:
            usage()

        # Get process info
        ps = subprocess.Popen(['ps', '-caxm', '-orss,comm'], stdout=subprocess.PIPE).communicate()[0].decode()
        vm = subprocess.Popen(['vm_stat'], stdout=subprocess.PIPE).communicate()[0].decode()

        # Iterate processes
        processLines = ps.split('\n')
        sep = re.compile('[\s]+')
        rssTotal = 0 # kB

        for row in range(1,len(processLines)):
            rowText = processLines[row].strip()
            rowElements = sep.split(rowText)
            try:
                rss = float(rowElements[0]) * 1024
            except:
                rss = 0 # ignore...
            rssTotal += rss

        # Process vm_stat
        vmLines = vm.split('\n')
        sep = re.compile(':[\s]+')
        vmStats = {}

        for row in range(1,len(vmLines)-2):
            rowText = vmLines[row].strip()
            rowElements = sep.split(rowText)
            vmStats[(rowElements[0])] = int(rowElements[1].strip('\.')) * 4096

        wired = vmStats["Pages wired down"]/1024/1024
        active = vmStats["Pages active"]/1024/1024
        inactive = vmStats["Pages inactive"]/1024/1024
        free = vmStats["Pages free"]/1024/1024
        real = str(rssTotal/1024/1024).strip('\.')

        print ' '
        print('    Wired Memory: %5.4d MB' % ( wired ))
        print('   Active Memory: %5.4d MB' % ( active ))
        print(' Inactive Memory: %5.4d MB' % ( inactive ))
        print('     Free Memory: %5.4d MB' % ( free ))
        print('     Real Memory: %5.4s MB' % ( real ))
        print ' '
        
    except Exception as err: # catch *all* exceptions
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format( err ))
        retVal = 1
    finally:
        sys.exit(retVal)

# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])