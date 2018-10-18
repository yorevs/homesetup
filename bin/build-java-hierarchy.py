#!/usr/bin/env python

"""@package This is a python application to help understanding a Java project and it's class hierarchies
   @script: build-java-hierarchy.py
  @purpose: Build a hierarchy of a Java project
  @created: Mar 20, 2008
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@gmail.com
"""

import sys
import os
import getopt
import re

# This script name.
PROC_NAME       = os.path.basename(__file__)
VERSION         = (1, 0, 1)
USAGE           = "Usage: python {} <input_dir> <output_file>".format(PROC_NAME)
ARG_MAP         = {}
HIERARCHY_MAP   = []

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

def findFiles():
    """
        Scan the specified directory and find all .java files
    """

    iPath = ARG_MAP['inputDir']
    jFiles = []

    if not os.path.exists(iPath):
        print('Input file/directory is invalid or does not exist: {}'.format(iPath))
        sys.exit(2)

    # pylint: disable=W0612
    for root, dirs, files in os.walk(iPath):
        for file in files:
            if file.endswith(".java"):
                jFiles.append(os.path.join(root, file))

    return jFiles


def parseList(javaFileList):
    for file in javaFileList:
        with open(file) as java:
            content = java.readlines()
            for line in content:
                if any(kword in line for kword in ['class', 'interface', 'enum']):
                    p = re.compile(' *(public|private|protected)? *(final|abstract|static)? *(class|@?interface|enum) *(<?[A-Z][a-zA-Z0-9_]+>?) *(extends ([A-Z][a-zA-Z0-9_]+))? *(implements ((([A-Z][a-zA-Z0-9_]+)( *,? *))+))? *{')
                    m = p.match(line.strip())
                    if m and m.group(3) and m.group(4):
                        clazz = Clazz(file, m.group(1),m.group(2),m.group(3),m.group(4),m.group(6),m.group(8))
                        HIERARCHY_MAP.append(clazz)


def printHierarchy():
    oFile = ARG_MAP['outputFile']
    with open(oFile + '.csv', "w") as file:
        file.write("\"Access\",\"Modifier\",\"Type\",\"Class\",\"Parent\",\"Implementations\",\"File\"\n")
        file.write(",,,,,,\n")
        sortedList = sorted(HIERARCHY_MAP, key=lambda k: (k.type, k.name))
        for clazz in sortedList:
            file.write(str(clazz))


class Clazz:
    """
        Represent a parsed Java Class
    """
    def __init__(self, file, access, modifier, type, name, parent, impls):
        self.file = file
        self.access = access
        self.modifier = modifier
        self.type = type
        self.name = name
        self.parent = parent
        self.impls = impls.replace(',',';') if impls else None

    def __str__(self):
        return "\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\"\n".format(
                self.access if self.access else 'package',
                self.modifier if self.modifier else '',
                self.type.replace('@interface','annotation') if self.type else '',
                self.name if self.name else '',
                self.parent if self.parent else '',
                self.impls if self.impls else '',
                self.file if self.file else '')
    
    def __repr__(self):
        return self.__str__()

def app_exec():
    """
        Execute the app business logic
    """
    jflist=findFiles()
    parseList(jflist)
    printHierarchy()

def main(argv):
    """
        App main entry point
    """
    try:

        # Handle program arguments and options
        # Short opts: -<C>, Long opts: --<Word>
        opts, args = getopt.getopt(argv, 'hv', ['help','version'])

        for opt, args in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage(0)
            else:
                assert False, 'Unhandled option: %s' % opt
        
        if len(args) != 2:
            usage(2)
        
        ARG_MAP['inputDir'] = args[0]
        ARG_MAP['outputFile'] = args[1]
        
        app_exec()

    # Caught getopt exceptions
    except getopt.GetoptError as optErr:
        print('Failed to execute app => {}'.format(optErr.msg))
        usage(2)
    
    # Ignore sys.exit
    except SystemExit:
        pass
    
    # Caught all other exceptions
    except Exception as err:
        print('An exception was thrown executing the app => {}'.format( err ))
        sys.exit(2)

if __name__ == "__main__":
   main( sys.argv[1:] )
   sys.exit(0)
