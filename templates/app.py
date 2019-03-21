#!/usr/bin/env python

"""
  @package: This is a template python application
   @script: ${app.py}
  @purpose: ${purpose}
  @created: Mon DD, YYYY
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import sys, os, getopt

PROC_NAME       = os.path.basename(__file__)
# Version tuple: (major,minor,build)
VERSION         = (0, 9, 0)
# Usage message
USAGE           = """
Usage: python {} [optionals] <mandatories>
""".format(PROC_NAME)

ARGS_MAP = {
    'input' : None,
    'output' : None
}

def usage(exitCode=0):
    """
        Help message to be displayed by the script.
    """
    print(USAGE)
    sys.exit(exitCode)

def version():
    """
        Echoes the current script version.
    """
    print('{} v{}.{}.{}'.format(PROC_NAME,VERSION[0],VERSION[1],VERSION[2]))
    sys.exit(0)

def app_exec():
    """
        Execute the app business logic
    """
    print("Hello Python App")
    print(ARGS_MAP)

def main(argv):
    """
        App main entry point
    """
    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'vhi:o:', ['in=', 'out='])

        if len(opts) < 2:
            raise ValueError('### Invalid number of arguments: ({})'.format(len(opts)))

        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage()
            elif opt in ('-i', '--in'):
                ARGS_MAP['input'] = arg
            elif opt in ('-o', '--out'):
                ARGS_MAP['output'] = arg
            else:
                assert False, '### Unhandled option: {}'.format(opt)
        
        # Execute the app code
        if len(args) > 0:
            print('Args: {}'.format(args))
        
        app_exec()

    # Catch getopt exceptions
    except getopt.GetoptError as optErr:
        print('{}'.format(optErr.msg))
        usage(2)
        
    # Catch ValueErrors
    except ValueError as valErr:
        print('{}'.format(valErr))
        usage(2)

    # Caught app exceptions
    except Exception as err:
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format( err ))
        sys.exit(2)

if __name__ == "__main__":
   main( sys.argv[1:] )
   sys.exit(0)
