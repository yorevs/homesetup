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

import sys
import json
import getopt

from jsonutils.JsonUtils import JsonUtils

f_json = None
json_obj = None
alias = None

try:
    
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
    print '%s' % '' if content is None else content
    
except:
    pass