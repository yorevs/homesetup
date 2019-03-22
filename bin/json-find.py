#!/usr/bin/env python

"""
  @package: -
   @script: json-find.py
  @purpose: Find a object from the json string or file.
  @created: Jan 20, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import sys, os, getopt
import json

from jsonutils.JsonUtils import JsonUtils

PROC_NAME       = os.path.basename(__file__)
# Version tuple: (major,minor,build)
VERSION         = (0, 9, 0)
# Usage message
USAGE           = """
Find a json path from a json string

Usage: python {} -f <filename> -a <alias_to_find>
""".format(PROC_NAME)

# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exitCode=0):
    print(USAGE)
    sys.exit(exitCode)

# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME,VERSION[0],VERSION[1],VERSION[2]))
    sys.exit(0)

try:
    if len(sys.argv) == 1 or sys.argv[1] in [ '-h', '--help' ]:
        usage()

    f_json = None
    json_obj = None
    alias = None
    index=1
    jutils = JsonUtils()
    
    opts, args = getopt.getopt(sys.argv[1:], 'f:a:', ['file','alias'])
    
    for opt, args in opts:
        if opt in ('-f', '--file'):
            f_json = args
            with open(f_json) as json_file:
                json_obj = json.load(json_file)
            index+=2
        elif opt in ('-a', '--alias'):
            alias = args
            index+=2

    if f_json is None:
        json_str = ', '.join(str(x) for x in sys.argv[index:])
        json_obj = json.loads(json_str)
        
    content = jutils.jsonSelect(json_obj, alias)
    print('{}'.format('' if content is None else content))
    
except:
    pass