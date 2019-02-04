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

import subprocess
import re

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