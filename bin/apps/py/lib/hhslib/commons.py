"""
    @package: hhslib
    @script: commons.py
    @purpose: Common functions library
    @created: Mon 27, 2020
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
    @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""

import logging as log
import os
import sys


# Default log file format
DEFAULT_LOG_FMT = '%(asctime)s [%(threadName)-10.10s] %(levelname)-5.5s ::%(funcName)s(@line-%(lineno)d) %(message)s '

# default log file size
MAX_LOG_FILE_SIZE = 1 * 1024 * 1024


# @purpose: Initialize the logger.
def log_init(log_file, level=log.DEBUG, log_fmt=DEFAULT_LOG_FMT, max_log_size=MAX_LOG_FILE_SIZE):
    with open(log_file, 'a'):
        os.utime(log_file, None)
    f_size = os.path.getsize(log_file)
    f_mode = "a" if f_size < max_log_size else "w"
    log.basicConfig(
        filename=log_file,
        format=log_fmt,
        level=level,
        filemode=f_mode)

    return log


# @purpose: Get an argument from the list or None if index is out of range.
def get_argument(options, index, fallback=None):
    argument = fallback if len(options) < index + 1 else options[index]
    return argument


# @purpose: Execute the app business logic.
def check_arguments(args, args_num=0):
    if len(args) < args_num:
        print("### Invalid number of arguments: {} , expecting: {}".format(len(args), args_num))
        return False
    else:
        return True


# @purpose: Handle interruptions to shutdown gracefully.
def exit_handler(signum=0, frame=None):
    if signum != 0 and frame is not None:
        log.warn('Signal handler hooked signum={} frame={}'.format(signum, frame))
        sysout('')
        ret_val = 1
    else:
        log.info('Exit handler called')
        ret_val = signum
    sys.exit(ret_val)


# @purpose: Create a new file with or without contents.
def create_file(filename, contents=None):
    with open(filename, 'w') as f_file:
        if contents is not None:
            f_file.write(contents)


# @purpose: Convert bytes into a Human Readable bytes.
def human_readable_bytes(str_size):
    byte_size = float(str_size)
    kb, mb, gb, tb = 2 ** 10, 2 ** 20, 2 ** 30, 2 ** 40
    if 0 <= byte_size <= kb:
        ret_val = '%3.2f' % byte_size
        ret_unit = '[B]'
    elif kb < byte_size <= mb:
        ret_val = '%3.2f' % (byte_size / kb)
        ret_unit = '[Kb]'
    elif mb < byte_size <= gb:
        ret_val = '%3.2f' % (byte_size / mb)
        ret_unit = '[Mb]'
    elif gb < byte_size <= tb:
        ret_val = '%3.2f' % (byte_size / gb)
        ret_unit = '[Gb]'
    else:
        ret_val = '%3.2f' % (byte_size / tb)
        ret_unit = '[Tb]'

    return ret_val, ret_unit


# @purpose: Read from keyboard
def read(prompt=''):
    if sys.version_info[0] < 3:
        raw_input(prompt)
    else:
        input(prompt)


# @purpose: Print the unicode string
def sysout(string, end='\n'):
    sys.stdout.write(string.encode('utf-8').decode('unicode-escape')+end)


# @purpose: Print the unicode string
def syserr(string, end='\n'):
    sys.stderr.write(string.encode('utf-8').decode('unicode-escape')+end)


