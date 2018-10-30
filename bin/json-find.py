#!/usr/bin/env python

import sys
import json
import getopt

from jsonutils.JsonUtils import JsonUtils

STDERR = sys.stderr
def excepthook(*args):
    print >> STDERR, 'caught'
    print >> STDERR, args

sys.excepthook = excepthook

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