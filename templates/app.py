"""@package This is a template python application
   @script: ${app.py}
  @purpose: ${purpose}
  @created: Mon DD, YYYY
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
"""

import sys, os, getopt

PROC_NAME       = os.path.basename(__file__)
VERSION         = (0, 9, 0)
USAGE           = "Usage: python {} [optionals] <mandatories>".format(PROC_NAME)

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

def main(argv):
    """
        App main entry point
    """
    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'i:o:', ['in=', 'out='])

        for opt, arg in opts:
            if opt in ('-v', '--version'):
                version()
                sys.exit(0)
            elif opt in ('-h', '--help'):
                usage()
                sys.exit(0)
            elif opt in ('-i', '--in'):
                print('in: {}'.format(arg))
            elif opt in ('-o', '--out'):
                print('out: {}'.format(arg))
            else:
                assert False, 'Unhandled option: %s' % opt
        
        # Execute the app code
        if len(args) > 0:
            print('Args: {}'.format(args))
        
        app_exec()

    # Caught getopt exceptions
    except getopt.GetoptError as optErr:
        print('Failed to execute app => {}'.format(optErr.msg))
        usage()
        sys.exit(2)
    
    # Caught app exceptions
    except Exception as err:
        print('An exception was thrown executing the app => {}'.format( err ))
        sys.exit(2)

if __name__ == "__main__":
   main( sys.argv[1:] )
   sys.exit(0)
