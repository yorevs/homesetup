# Purpose: TODO Include the purpose of the script


# Script Begin {


# } End script

def main(argv):
    retVal = 0

    try:

        for xml_fname in argv:
            tree = ET.parse(xml_fname)
            root = tree.getroot()
            xml_indent(root)
            tree.write(xml_fname)

        retVal = 0

    except Exception, err:  # catch *all* exceptions
        print '\n        retVal = 1

    finally:
        sys.exit(retVal)


# Program entry point.
if __name__ == '__main__':
    main(sys.argv[1:])
