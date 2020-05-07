#!/usr/bin/env python

"""
  @package: -
   @script: send-msg.py
  @purpose: IP Message Sender. Sends TCP/UDP messages (multi-threaded).
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <https://opensource.org/licenses/MIT>
"""

# @verified versions: ???

from time import sleep, time as time
from datetime import timedelta
from decimal import Decimal

import os
import sys
import socket
import getopt
import threading
import signal

# This application name.
APP_NAME       = os.path.basename(__file__)

# Version tuple: (major,minor,build)
VERSION         = (1, 0, 1)

# TOD
MAX_THREADS     = 1000

# Help message to be displayed by the application.
USAGE = """
IP Message Sender v{}

Usage: {} [opts]

    Options:
        -m, --message    <message/filename> : The message to be sent. If the message matches a filename, then the
                                              file is read and the content sent instead.
        -p, --port       <port_num>         : The port number [1-65535] ( default is 12345).
        -a, --address    <host_address>     : The address of the datagram receiver ( default is 127.0.0.1 ).
        -k, --packets    <num_packets>      : The number of max datagrams to be send. If zero is specified, then the app
                                              is going to send indefinitely ( default is 100 ).
        -i, --interval   <interval_MS>      : The interval between each datagram ( default is 1 Second ).
        -t, --threads    <threads_num>      : Number of threads [1-{}] to be opened to send simultaneously ( default is 1 ).
        -n, --net_type    <network_type>     : The network type to be used. Either UDP or TCP ( default is TCP ).
    
    E.g:. send-msg.py -m "Hello" -p 12345 -a 0.0.0.0 -k 100 -i 500 -t 2
""".format(str(VERSION), APP_NAME, MAX_THREADS)

MIN_PYTHON      = (2, 6, 6)
MAX_PYTHON      = (2, 7, 15)
CUR_PYTHON      = sys.version_info
NET_TYPE_UDP    = 'UDP'
NET_TYPE_TCP    = 'TCP'
MAX_DISP_LEN    = 500


# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exit_code=0):
    print(USAGE)
    sys.exit(exit_code)


# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(APP_NAME, VERSION[0], VERSION[1], VERSION[2]))
    sys.exit(0)


class TcpUdpIpSender(object):

    def __init__(self, address, port, packets, interval, message, threads, net_type):
        self.host = (address, port)
        self.packets = packets
        self.interval = interval
        self.message = message
        self.threads = threads
        self.isAlive = True
        self.net_type = net_type

        signal.signal(signal.SIGINT, self.__interrupt_handler__)
        signal.signal(signal.SIGTERM, self.__interrupt_handler__)

        self.__initSockets__()

    def __initSockets__(self):
        if self.net_type == NET_TYPE_UDP:
            self.clientSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        else:
            self.clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            try:
                self.clientSocket.connect(self.host)
            except socket.error as err:
                print('\n###Error -> {}'.format(str(err)))
                sys.exit(2)

    def __interrupt_handler__(self, sig_num, frame_num):
        print('Program has been interrupted [Ctrl+C] ^{}'.format(sig_num))
        print('Terminating threads')
        self.isAlive = False
        if self.net_type == NET_TYPE_TCP:
            print('Closing TCP connection')
            self.clientSocket.close()

    def start_send(self):
        print('Start sending {} packets every {} seconds: max. of[{}] to {} \nTHREADS = {}'.format(
            self.net_type
            , self.interval
            , self.packets
            , self.host
            , self.threads
        ))

        threads_num = threading.active_count()

        for i in range(1, self.threads + 1):
            tr = threading.Thread(target=self.send_packet, args=(i,))
            tr.setDaemon(True)
            tr.start()
            sleep(0.011)

        while self.isAlive and threading.active_count() > threads_num:
            sleep(0.50)

    def send_packet(self, i):
        counter = 1
        length = len(self.message)

        while self.isAlive and self.packets <= 0 or counter <= self.packets:
            print('[Thread-%.2d] Sending [%d] bytes, Pkt = %d/%d ...' % (i, length, counter, self.packets))
            if self.net_type == NET_TYPE_UDP:
                self.clientSocket.sendto(self.message, self.host)
            else:
                try:
                    self.clientSocket.sendall(self.message + '\n')
                except socket.error as err:
                    print('\n###Error -> {}'.format(str(err)))
                    sys.exit(2)
            counter += 1
            sleep(self.interval)


def redirect_output(out_file):
    print('Redirecting STDOUT to: {}'.format(out_file))
    sys.stdout = open(out_file, 'w')


def restore_output():
    if sys.stdout != sys.__stdout__:
        out_file = sys.stdout
        sys.stdout = sys.__stdout__
        out_file.close()
        print('Restored STDOUT output from file: {}'.format(out_file))


def to_millis(d_time):
    ret_val = 0
    if d_time:
        epoch = int(round(time() * 1000))
        diff_time = d_time - epoch
        ret_val = diff_time.total_seconds() * 1000000.0

    return ret_val


def calc_diff_time(time1, time2):
    time_diff = 0
    if time1 and time2 and time1.isValid and time2.isValid:
        t1 = to_millis(time1.timeStamp)
        t2 = to_millis(time2.timeStamp)
        if t2 < t1:
            time_diff = t1 - t2
        else:
            time_diff = t2 - t1

    return time_diff


def human_readable_time(time_us):
    delta = timedelta(microseconds=time_us)
    total_seconds = delta.seconds
    seconds = total_seconds % 60
    minutes = total_seconds / 60 % 60
    hours = total_seconds / 3600
    microseconds = delta.microseconds
    # Using format: HH:MM:SS.uuuuuu
    str_line = '%.2d:%.2d:%.2d.%.6d' % (hours, minutes, seconds, microseconds)

    return str_line


def human_readable_bytes(bytes_size):
    kb, mb, gb, tb = 2 ** 10, 2 ** 20, 2 ** 30, 2 ** 40
    if 0 <= bytes_size <= kb:
        ret_val = '%.3f [B]' % bytes_size
    elif kb < bytes_size <= mb:
        ret_val = '%.3f [Kb]' % (bytes_size / kb)
    elif mb < bytes_size <= gb:
        ret_val = '%.3f [Mb]' % (bytes_size / mb)
    elif gb < bytes_size <= tb:
        ret_val = '%.3f [Gb]' % (bytes_size / gb)
    else:
        ret_val = '%.3f [Tb]' % (bytes_size / tb)

    return ret_val


def fit_to_columns(message):
    length = len(message)
    if length > 0:
        message = '%s' % (
            (
                    message[:MAX_DISP_LEN] + ' ...more<%s>' % human_readable_bytes(length)
            ) if length > MAX_DISP_LEN else message
        )

    return message, length


def main(argv):
    ret_val = 0
    port = 12345
    address = '127.0.0.1'
    packets = 100
    interval = 1.0
    threads = 1
    net_type = NET_TYPE_TCP

    try:
        if len(sys.argv) == 1 or sys.argv[1] in ['-h', '--help']:
            usage()

        # pylint: disable=W0612
        opts, args = getopt.getopt(argv, 'hvm:p:a:k:i:t:n:',
           ['help', 'version', 'message=', 'port=', 'address=', 'packets=', 'interval=', 'threads=', 'net_type'])

        for opt, argument in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage(0)
            elif opt in ('-m', '--message'):
                if os.path.isfile(argument):
                    file_size = os.stat(argument).st_size
                    print('Reading contents from file: %s (%d) [Bs] instead' % (argument, file_size))
                    with open(argument, 'r') as fMsg:
                        message = fMsg.read()
                else:
                    message = argument
            elif opt in ('-p', '--port'):
                assert argument.isdigit() and 0 < int(argument) <= 65535, 'Port Number must be a digit within 1-65535]'
                port = int(argument)
            elif opt in ('-a', '--address'):
                address = argument
            elif opt in ('-k', '--packets'):
                assert argument.isdigit() and 0 <= int(argument), 'Number of packets must be a digit within [0-N]'
                packets = int(argument)
            elif opt in ('-i', '--interval'):
                assert argument.isdigit() and 0 < int(argument), 'Interval must be a digit within [1-N]'
                interval = abs(Decimal(argument) / 1000)
            elif opt in ('-t', '--threads'):
                assert argument.isdigit() and 0 < int(
                    argument) <= MAX_THREADS, 'Number of threads must be a digit within [1-%d]' % MAX_THREADS
                threads = int(argument)
            elif opt in ('-n', '--net_type'):
                net_type = str(argument).upper()
                assert net_type == 'UDP' or net_type == 'TCP', 'Network type must be either UDP or TCP'
            else:
                assert False, 'Unhandled option: %s' % opt

        message = '{}SendMsg.py SELF TEST'.format(net_type)
        p = TcpUdpIpSender(address, port, packets, interval, message, threads, net_type)
        p.start_send()

    # Caught getopt exceptions
    except (getopt.GetoptError, AssertionError) as err:
        print('\n###Error -> {}'.format(str(err)))
        usage(2)

    # Ignore sys.exit
    except SystemExit:
        pass

    except Exception as err:  # catch *all* exceptions
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format(err))
        ret_val = 1
    finally:
        sys.exit(ret_val)


if __name__ == '__main__':
    main(sys.argv[1:])
