#!/usr/bin/env python

"""
  @package: -
   @script: pprint-xml.py
  @purpose: Pretty print (format) an xml file.
  @created: Jan 20, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

import sys, os
import xml.dom.minidom

PROC_NAME       = os.path.basename(__file__)
# Version tuple: (major,minor,build)
VERSION         = (0, 9, 0)
# Usage message
USAGE           = """
Format an XML file or scans a directory and walk though all subdirectories and format all found xml files.

Usage: python {} <filename>/<dirname> ...
""".format(PROC_NAME)

# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exitCode=0):
    print(USAGE)
    sys.exit(exitCode)

# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME,VERSION[0],VERSION[1],VERSION[2]))
    sys.exit(0)

# @purpose: Format the specified XML file contents and return the formatted XML as a string.
def pretty_print(xml_path):
    xml_dom = xml.dom.minidom.parse(xml_path)
    pretty_xml = xml_dom.toprettyxml()
    
    return pretty_xml

# @purpose: Save the specified contents to the file.
def save_xml_file(filename, xml_content):
    with open(filename, 'w') as xmlFile:
        xmlFile.write(xml_content)

# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    retVal = 0
    try:
        if len(argv) > 0:
            for xml_path in argv:
                if os.path.isdir(xml_path):
                    for subdir, dirs, files in os.walk(xml_path):
                        for next_file in files:
                            file_info = os.path.splitext(next_file)
                            if file_info[1] == '.xml':
                                theFile = os.path.join(subdir,next_file)
                                try:
                                    save_xml_file(theFile, pretty_print(theFile))
                                except Exception as err:
                                    print('#### Failed to format XML file \"{}\": \n  |-> {}'.format(theFile , str(err)))
                                    pass
                else:
                    save_xml_file(xml_path, pretty_print(xml_path))
        else:
            usage()
        retVal = 0
    except Exception as err: # catch *all* exceptions
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format( err ))
        retVal = 1
    finally:
        sys.exit(retVal)

# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
