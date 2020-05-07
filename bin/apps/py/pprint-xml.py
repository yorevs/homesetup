#!/usr/bin/env python

"""
  @package: -
   @script: pprint-xml.py
  @purpose: Pretty print (format) an xml file.
  @created: Jan 20, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: Python 2.7 and Python 3.7

import sys
import os
import re
import xml.dom.minidom

# This application name.
APP_NAME = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION = (0, 9, 0)

# Usage message
USAGE = """
Format an XML file or scans a directory and walk though all subdirectories and format all found xml files.

Usage: {} <filename>/<dirname> ...
""".format(APP_NAME)

INDENT = '  '
NEWLINE = '\n'
ENCODING = None


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


# @purpose: Format the specified XML file contents and return the formatted XML as a string.
def pretty_print(xml_path):
    xml_dom = xml.dom.minidom.parse(xml_path)
    pretty_xml = xml_dom.toprettyxml(indent=INDENT, newl=NEWLINE, encoding=ENCODING)
    return pretty_xml


# @purpose: Save the specified contents to the file.
def save_xml_file(filename, xml_content):
    try:
        with open(filename, 'w') as xml_file:
            xml_file.write(xml_content)
    except Exception as err:
        print('#### Failed to format XML file \"{}\": \n  |-> {}'.format(filename, str(err)))
        pass


# @purpose: Walk through directory tree and format each file
def walk_and_format(paths):
    for next_path in paths:
        if os.path.isdir(next_path):
            for subdir, dirs, files in os.walk(next_path):
                for next_file in files:
                    file_info = os.path.splitext(next_file)
                    if file_info[1].lower() == '.xml':
                        xml_file = os.path.join(subdir, next_file)
                        fmt_contents = pretty_print(xml_file).split('\n')
                        filtered = filter(lambda x: not re.match(r'^\s*$', x), fmt_contents)
                        save_xml_file(xml_file, '\n'.join(filtered))
        else:
            fmt_contents = pretty_print(next_path).split('\n')
            filtered = filter(lambda x: not re.match(r'^\s*$', x), fmt_contents)
            save_xml_file(next_path, '\n'.join(filtered))


# @purpose: Parse the command line arguments and execute the program accordingly.
def main(argv):
    if argv[0] == "-h" or argv[0] == "--help":
        usage()
    elif len(argv) > 0:
        walk_and_format(argv)
    else:
        usage()


# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
